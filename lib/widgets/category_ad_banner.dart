import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../google_ads/google_ad_class.dart';
import 'banner_widget.dart';
import 'container_shimmer_widget.dart';

/// Ad banner shown at the top of every category page.
///
/// Firebase Realtime Database layout it reads:
///
///   advertiseSection/
///     advertiseBannerUrl        -> shared banner image (used when the category has none)
///     isAdvertiseBannerVisible  -> true  = show the custom image banner
///                                  false = show the Google AdMob banner instead
///   Categories/
///     <category key>            -> banner image URL for that category ("" = use shared)
///
/// The category key is the category name with "." replaced by "_" and "/"
/// replaced by "!" (Firebase keys cannot contain "." or "/"), e.g.
///   "S.S.SCRAP"                  -> "S_S_SCRAP"
///   "COPPER / BRASS/ PIPES & TUBES" -> "COPPER ! BRASS! PIPES & TUBES"
class CategoryAdBanner extends StatefulWidget {
  /// The category name as written in the app, e.g. "S.S.SCRAP".
  final String categoryName;

  const CategoryAdBanner({super.key, required this.categoryName});

  /// Converts a category name to its key under `Categories/` in Firebase.
  static String keyFor(String categoryName) =>
      categoryName.replaceAll('.', '_').replaceAll('/', '!');

  @override
  State<CategoryAdBanner> createState() => _CategoryAdBannerState();
}

class _CategoryAdBannerState extends State<CategoryAdBanner> {
  StreamSubscription<DatabaseEvent>? _sharedSub;
  StreamSubscription<DatabaseEvent>? _categorySub;

  String _sharedUrl = "";
  String _categoryUrl = "";
  bool _showCustomBanner = true;
  BannerAd? _adMobBanner;

  @override
  void initState() {
    super.initState();
    final db = FirebaseDatabase.instance;

    // Shared banner + the on/off switch (same node the app already used).
    _sharedSub = db.ref().child("advertiseSection").onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is! Map || !mounted) return;
      final url = value['advertiseBannerUrl'];
      final visible = value['isAdvertiseBannerVisible'];
      setState(() {
        _sharedUrl = url is String ? url.trim() : "";
        _showCustomBanner = visible is bool ? visible : true;
      });
      if (!_showCustomBanner) _createAdMobBanner();
    });

    // Banner for this specific category.
    final key = CategoryAdBanner.keyFor(widget.categoryName);
    _categorySub = db.ref().child("Categories").child(key).onValue.listen((event) {
      if (!mounted) return;
      final value = event.snapshot.value;
      setState(() {
        _categoryUrl = value is String ? value.trim() : "";
      });
    });
  }

  void _createAdMobBanner() {
    if (_adMobBanner != null) return;
    _adMobBanner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _sharedSub?.cancel();
    _categorySub?.cancel();
    _adMobBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showCustomBanner) {
      final screenWidth = MediaQuery.of(context).size.width;
      // A category-specific image wins; otherwise fall back to the shared one.
      final imageUrl = _categoryUrl.isNotEmpty ? _categoryUrl : _sharedUrl;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: screenWidth,
          height: 52,
          fit: BoxFit.fill,
          placeholder: (context, url) => const ContainerShimmerWidget(height: 52),
          errorWidget: (context, url, error) => const Text(""),
        ),
      );
    }
    if (_adMobBanner == null) return const SizedBox(height: 70);
    return BannerAdWidget(banner: _adMobBanner);
  }
}
