import 'dart:async';

import 'package:c4dialer_v2/after_login_bottom_navbar_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Utils/app_colors.dart';
import 'Utils/app_analytics.dart';
import 'Utils/app_string.dart';
import 'bottom_bar/persistent_bottom_bar.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'bottom_bar/restart_widget.dart';
import 'notification/notification_services.dart';
import 'notification/notification_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/category_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationServices().storeNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CategoryProviderViewModel()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider()),
      ],
      child: const RestartAppWidget(
        child: MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool status = false;
  String hughesNumber = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCall();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    unawaited(
        AppAnalytics.setAppForeground(state == AppLifecycleState.resumed));
  }

  Future initCall() async {
    await checkStatus();
  }

  Future checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('isLoggedIn') ?? false;
    hughesNumber = prefs.getString("number") ?? "";
    setState(() {});
    debugPrint("isLoggedIn From Main Method: $status");
    debugPrint("hughesNumber From Main Method: $hughesNumber");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'C4Dialer',
        navigatorObservers: [AppAnalyticsNavigatorObserver()],
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primaryBlur3Color,
            foregroundColor: Colors.black,
          ),
          fontFamily: AppString.font,
        ),
        home: status
            ? AfterLoginPersistentBottomBar(hughesNumber: hughesNumber)
            : const PersistentBottomBar());
  }
}
