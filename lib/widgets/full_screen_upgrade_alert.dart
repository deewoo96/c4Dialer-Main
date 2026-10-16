import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenUpgradeAlert extends UpgradeAlert {
  FullScreenUpgradeAlert({
    super.key,
    required super.upgrader,
    required super.child,
  });

  @override
  UpgradeAlertState createState() => _FullScreenUpgradeAlertState();
}

class _FullScreenUpgradeAlertState extends UpgradeAlertState {
  @override
  void showTheDialog({
    Key? key,
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool barrierDismissible,
    required UpgraderMessages messages,
  }) {
    _showUpgradePage(
      context,
      title: title ?? '',
      message: message,
      releaseNotes: releaseNotes,
    );
  }

  Future<void> _showUpgradePage(
    BuildContext context, {
    required String title,
    required String message,
    required String? releaseNotes,
  }) async {
    await widget.upgrader.saveLastAlerted();
    if (!context.mounted) {
      return;
    }

    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => PopScope(
          canPop: false,
          child: _RequiredUpgradePage(
            title: title,
            message: message,
            releaseNotes: releaseNotes,
          ),
        ),
      ),
    );
  }
}

class _RequiredUpgradePage extends StatelessWidget {
  const _RequiredUpgradePage({
    required this.title,
    required this.message,
    required this.releaseNotes,
  });

  final String title;
  final String message;
  final String? releaseNotes;

  Future<void> _openStore(BuildContext context) async {
    final storeUri = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse('https://apps.apple.com/in/app/c4dialer/id6736866460')
        : Uri.parse(
            'https://play.google.com/store/apps/details?id=metal.hughes.tata_smart_metal_dialer&hl=en_IN',
          );

    try {
      final launched = await launchUrl(
        storeUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showStoreError(context);
      }
    } on PlatformException catch (error) {
      debugPrint('Could not open the app store: $error');
      if (context.mounted) {
        _showStoreError(context);
      }
    }
  }

  void _showStoreError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the app store.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.system_update, size: 72),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(message, textAlign: TextAlign.center),
                  if (releaseNotes != null &&
                      releaseNotes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What’s new',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(releaseNotes!),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openStore(context),
                      icon: const Icon(Icons.download),
                      label: const Text('Update now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
