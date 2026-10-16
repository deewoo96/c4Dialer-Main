import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/app_colors.dart';
import 'category_ad_banner.dart';

/// Opens the URL stored as a string at `Categories/<normalized category key>`.
class CategoryWhatsappButton extends StatefulWidget {
  final String categoryName;
  final bool showButton;

  const CategoryWhatsappButton({
    super.key,
    required this.categoryName,
    this.showButton = false,
  });

  @override
  State<CategoryWhatsappButton> createState() => _CategoryWhatsappButtonState();
}

class _CategoryWhatsappButtonState extends State<CategoryWhatsappButton> {
  bool _isLoading = false;

  Future<void> _openGroup() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final key = CategoryAdBanner.keyFor(widget.categoryName);
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child("Categories")
          .child(key)
          .get();
      final value = snapshot.value;
      final inviteLink = value is String ? value.trim() : "";
      final uri = Uri.tryParse(inviteLink);

      if (uri == null ||
          !uri.hasScheme ||
          uri.host.isEmpty ||
          (uri.scheme != "https" &&
              uri.scheme != "http" &&
              uri.scheme != "whatsapp")) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("WhatsApp group link is unavailable.")),
          );
        }
        return;
      }

      final didLaunch = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!didLaunch && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Unable to open the WhatsApp group link.")),
        );
      }
    } catch (error, stackTrace) {
      debugPrint("Unable to open category WhatsApp group: $error\n$stackTrace");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Unable to load the WhatsApp group link.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showButton) return const SizedBox.shrink();

    return IconButton(
      tooltip: "Open WhatsApp group",
      onPressed: widget.categoryName.isEmpty || _isLoading ? null : _openGroup,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: AppColors.greyColor,
            ),
    );
  }
}
