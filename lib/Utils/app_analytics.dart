import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppAnalytics {
  AppAnalytics._();

  static final Stopwatch _screenDuration = Stopwatch();
  static String? _currentScreen;
  static bool _isForeground = true;

  static FirebaseAnalytics? get _analytics =>
      Firebase.apps.isEmpty ? null : FirebaseAnalytics.instance;

  static bool get _isSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static Future<void> trackScreen(String screenName) async {
    final analytics = _analytics;
    if (!_isSupported || analytics == null || _currentScreen == screenName) {
      return;
    }

    await _recordScreenDuration();
    _currentScreen = screenName;
    if (_isForeground) _screenDuration.start();

    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  static Future<void> trackTab(String screenName) async {
    await trackScreen(screenName);
    await trackClick('bottom_navigation', screenName: screenName);
  }

  static Future<void> trackClick(
    String elementName, {
    String? screenName,
  }) async {
    final analytics = _analytics;
    if (!_isSupported || analytics == null) return;

    await analytics.logEvent(
      name: 'ui_click',
      parameters: {
        'element_name': elementName,
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }

  static Future<void> setAppForeground(bool isForeground) async {
    if (!_isSupported || _analytics == null) return;
    if (_isForeground == isForeground) return;

    _isForeground = isForeground;
    if (isForeground) {
      if (_currentScreen != null) _screenDuration.start();
    } else {
      await _recordScreenDuration();
    }
  }

  static Future<void> _recordScreenDuration() async {
    final analytics = _analytics;
    if (!_isSupported || analytics == null) return;

    _screenDuration.stop();
    final durationSeconds = _screenDuration.elapsed.inSeconds;
    _screenDuration.reset();

    final screenName = _currentScreen;
    if (screenName == null || durationSeconds == 0) return;

    await analytics.logEvent(
      name: 'screen_time',
      parameters: {
        'screen_name': screenName,
        'duration_seconds': durationSeconds,
      },
    );
  }
}

class AppAnalyticsNavigatorObserver extends NavigatorObserver {
  String _screenNameFor(Route<dynamic> route) {
    final routeName = route.settings.name;
    return routeName != null && routeName.isNotEmpty
        ? routeName
        : route.runtimeType.toString();
  }

  void _track(Route<dynamic>? route) {
    if (route is! PageRoute<dynamic>) return;

    unawaited(AppAnalytics.trackScreen(_screenNameFor(route)));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _track(route);
    if (previousRoute != null && route is PageRoute<dynamic>) {
      unawaited(
        AppAnalytics.trackClick(
          'page_navigation',
          screenName: _screenNameFor(route),
        ),
      );
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _track(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _track(previousRoute);
  }
}
