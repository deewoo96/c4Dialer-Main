import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5883654875397368/7589309503'; // Main Banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5883654875397368/7589309503'; // Main Banner
    }

    return 'ca-app-pub-3940256099942544/6300978111'; // Test banner for non-mobile platforms.
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5883654875397368/7959061976'; // Main rewarded ad
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5883654875397368/7959061976'; // Main rewarded ad
    }

    return 'ca-app-pub-3940256099942544/5224354917'; // Test rewarded ad for non-mobile platforms.
  }

  // static String get openAppAdUnitId {
  //   if (Platform.isAndroid) {
  //     // return 'ca-app-pub-5883654875397368/9553542801'; // Main Banner
  //     return 'ca-app-pub-3940256099942544/9257395921'; // Testing Purpose
  //   } else if (Platform.isIOS) {
  //     // return 'ca-app-pub-5883654875397368/9553542801'; // Main Banner
  //     return 'ca-app-pub-3940256099942544/9257395921'; // Testing Purpose
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }


  static final BannerAdListener bannerListener =  BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad Loaded"),
    onAdFailedToLoad: (ad, error){
      ad.dispose();
      debugPrint("Ad Failed to load $error");
    },
    onAdOpened: (ad) => debugPrint("Ad Opened"),
    onAdClosed: (ad) => debugPrint("Ad Closed"),
  );

}