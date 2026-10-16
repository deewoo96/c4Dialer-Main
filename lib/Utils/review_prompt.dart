import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewPrompt {
  static const _launchCountKey = 'review_prompt_launch_count';
  static const _reviewedKey = 'review_prompt_reviewed';
  static const _snoozedUntilKey = 'review_prompt_snoozed_until';
  static const _launchThreshold = 5;
  static const _snoozeDuration = Duration(days: 30);

  static Future<void> maybeShow(BuildContext context) async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(_reviewedKey) ?? false) {
      return;
    }

    final launchCount = (preferences.getInt(_launchCountKey) ?? 0) + 1;
    await preferences.setInt(_launchCountKey, launchCount);
    if (launchCount < _launchThreshold) {
      return;
    }

    final snoozedUntil = preferences.getInt(_snoozedUntilKey) ?? 0;
    if (DateTime.now().millisecondsSinceEpoch < snoozedUntil ||
        !context.mounted) {
      return;
    }

    final choice = await showDialog<_ReviewPromptChoice>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enjoying C4Dialer?'),
        content: const Text(
          'Your feedback helps us improve. Please take a moment to rate us.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_ReviewPromptChoice.later),
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_ReviewPromptChoice.reviewed),
            child: const Text("I've already reviewed"),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_ReviewPromptChoice.rate),
            child: const Text('Rate us'),
          ),
        ],
      ),
    );

    if (choice == null || !context.mounted) {
      return;
    }

    if (choice == _ReviewPromptChoice.later) {
      await preferences.setInt(
        _snoozedUntilKey,
        DateTime.now().add(_snoozeDuration).millisecondsSinceEpoch,
      );
      return;
    }

    if (choice == _ReviewPromptChoice.reviewed) {
      await preferences.setBool(_reviewedKey, true);
      return;
    }

    final storeUri = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse(
            'https://apps.apple.com/in/app/c4dialer/id6736866460?action=write-review')
        : Uri.parse(
            'https://play.google.com/store/apps/details?id=metal.hughes.tata_smart_metal_dialer&hl=en_IN',
          );
    final launched = await launchUrl(
      storeUri,
      mode: LaunchMode.externalApplication,
    );
    if (launched) {
      await preferences.setBool(_reviewedKey, true);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the app store.')),
      );
    }
  }
}

enum _ReviewPromptChoice { later, reviewed, rate }
