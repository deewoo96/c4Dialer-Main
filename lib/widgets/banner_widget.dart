import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  final BannerAd? banner;

  const BannerAdWidget({super.key, this.banner});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      // width: screenWidth(context),
      child: AdWidget(ad: banner!),
    );
  }
}