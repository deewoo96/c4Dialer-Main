import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_analytics.dart';
import '../home_screen.dart';
import '../login_screen.dart';

import '../razorpay_screen.dart';

class PersistentBottomBar extends StatefulWidget {
  const PersistentBottomBar({
    super.key,
  });

  @override
  State<PersistentBottomBar> createState() => _PersistentBottomBarState();
}

class _PersistentBottomBarState extends State<PersistentBottomBar> {
  static const List<String> _tabNames = [
    'Home',
    'Search',
    'Broadcast',
    'Profile',
  ];

  NavigatorConfig _analyticsNavigatorConfig() => NavigatorConfig(
        navigatorObservers: [AppAnalyticsNavigatorObserver()],
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(AppAnalytics.trackScreen(_tabNames.first));
    });
  }

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const HomeScreen(),
          navigatorConfig: _analyticsNavigatorConfig(),
          item: ItemConfig(
            activeForegroundColor: AppColors.greyColor,
            textStyle:
                const TextStyle(color: AppColors.blackColor, fontSize: 13),
            icon: const Icon(
              Icons.home,
              color: AppColors.blackColor,
              size: 20,
            ),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const LoginScreen(),
          navigatorConfig: _analyticsNavigatorConfig(),
          item: ItemConfig(
            activeForegroundColor: AppColors.greyColor,
            textStyle:
                const TextStyle(color: AppColors.blackColor, fontSize: 13),
            icon: const Icon(
              Icons.search,
              color: AppColors.blackColor,
              size: 20,
            ),
            title: "Search",
          ),
        ),
        PersistentTabConfig(
          screen: const RazorpayScreen(),
          navigatorConfig: _analyticsNavigatorConfig(),
          item: ItemConfig(
            activeForegroundColor: AppColors.greyColor,
            textStyle:
                const TextStyle(color: AppColors.blackColor, fontSize: 13),
            icon: const Icon(
              Icons.web,
              color: AppColors.blackColor,
              size: 20,
            ),
            title: "Broadcast",
          ),
        ),
        PersistentTabConfig(
          screen: const LoginScreen(),
          navigatorConfig: _analyticsNavigatorConfig(),
          item: ItemConfig(
            activeForegroundColor: AppColors.greyColor,
            textStyle:
                const TextStyle(color: AppColors.blackColor, fontSize: 13),
            icon: const Icon(
              Icons.person,
              color: AppColors.blackColor,
              size: 20,
            ),
            title: "Profile",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
         navBarOverlap: const NavBarOverlap.none(),
      margin: EdgeInsets.zero,
      stateManagement: true,
      tabs: _tabs(),
      onTabChanged: (index) {
        unawaited(AppAnalytics.trackTab(_tabNames[index]));
      },
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarDecoration: const NavBarDecoration(
          color: AppColors.whiteColor,
        ),
        itemPadding: const EdgeInsets.only(top: 10, bottom: 10),
        navBarConfig: navBarConfig,
      ),
    );
  }
}
