import 'dart:convert';
import 'package:c4dialer_v2/widgets/banner_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:mobile_number/mobile_number.dart';
import 'dart:io' show Platform, SocketException;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'Utils/app_colors.dart';
import 'Utils/app_string.dart';
import 'Utils/common_widgets.dart';
import 'Utils/review_prompt.dart';
import 'Utils/utils.dart';
import 'google_ads/google_ad_class.dart';
import 'home_imports.dart';
import 'notification/notification_provider.dart';
import 'notification/notification_screen.dart';
import 'notification/notification_services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'provider/category_provider.dart';
import 'widgets/container_shimmer_widget.dart';
import 'widgets/full_screen_upgrade_alert.dart';

class Metal {
  final String key;
  final dynamic value;

  Metal(this.key, this.value);

  // Convert Metal to a Map (for JSON)
  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };

  // Create Metal from a Map (from JSON)
  factory Metal.fromJson(Map<String, dynamic> json) => Metal(
        json['key'],
        json['value'],
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final Upgrader _upgrader = Upgrader(
    durationUntilAlertAgain: const Duration(days: 1),
  );

  final bool _showMetalsSection = false;
  bool isMetalDataLoading = false;
  bool isFirebaseDataLoading = false;
  String add1 = "6654";
  String add2 = "6752";
  String add3 = "6638";
  String add4 = "6615";
  String add5 = "6658";
  String add6 = "6615";
  String add7 = "6636";
  String add8 = "6639";
  String add9 = "6659";
  String add10 = "6749";
  String add11 = "6743";
  String add12 = "6615";
  String add13 = "6743";
  String add14 = "6658";
  String add15 = "6743";
  String add16 = "6615";
  String add17 = "6743";
  String add18 = "6615";
  String add19 = "6743";
  String add20 = "6651";
  String add21 = "6615";
  String add22 = "6743";
  String add23 = "6610";
  String numberToCall = "";

  // int simNumber;
  int simNumber = 1;
  List<String> tappedValues = [];
  Widget dialerWidget(String textValue, String tappedValue) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              setState(() {
                if (tappedValues.length < 4) {
                  tappedValues.add(tappedValue);
                } else {
                  Utils.flushBarErrorMessage(
                      "You Can Only Enter 4 Digits Hughes Number", context);
                }
              });
              if (tappedValues.length == 4) {
                try {
                  String number = tappedValues.join('');
                  int numberValue = int.parse(number);
                  if (numberValue >= 1000 && numberValue <= 1099) {
                    numberToCall = "022$add1$number";
                  } else if (numberValue >= 1100 && numberValue <= 1299) {
                    numberToCall = "022$add2$number";
                  } else if (numberValue >= 1300 && numberValue <= 1399) {
                    numberToCall = "022$add3$number";
                  } else if (numberValue >= 1400 && numberValue <= 1499) {
                    numberToCall = "022$add4$number";
                  } else if (numberValue >= 1500 && numberValue <= 1679) {
                    numberToCall = "022$add5$number";
                  } else if (numberValue >= 1680 && numberValue <= 1999) {
                    numberToCall = "022$add6$number";
                  } else if (numberValue >= 2000 && numberValue <= 3499) {
                    numberToCall = "022$add7$number";
                  } else if (numberValue >= 3500 && numberValue <= 4999) {
                    numberToCall = "022$add8$number";
                  } else if (numberValue >= 5000 && numberValue <= 5999) {
                    numberToCall = "022$add9$number";
                  } else if (numberValue >= 6000 && numberValue <= 6399) {
                    numberToCall = "022$add10$number";
                  } else if (numberValue >= 6400 && numberValue <= 6999) {
                    numberToCall = "022$add11$number";
                  } else if (numberValue >= 7000 && numberValue <= 7099) {
                    numberToCall = "022$add12$number";
                  } else if (numberValue >= 7100 && numberValue <= 7899) {
                    numberToCall = "022$add13$number";
                  } else if (numberValue >= 7900 && numberValue <= 7909) {
                    numberToCall = "022$add14$number";
                  } else if (numberValue >= 7910 && numberValue <= 8009) {
                    numberToCall = "022$add15$number";
                  } else if (numberValue >= 8010 && numberValue <= 8069) {
                    numberToCall = "022$add16$number";
                  } else if (numberValue >= 8070 && numberValue <= 8079) {
                    numberToCall = "022$add17$number";
                  } else if (numberValue >= 8080 && numberValue <= 8099) {
                    numberToCall = "022$add18$number";
                  } else if (numberValue >= 8100 && numberValue <= 8499) {
                    numberToCall = "022$add19$number";
                  } else if (numberValue >= 8500 && numberValue <= 8999) {
                    numberToCall = "022$add20$number";
                  } else if (numberValue >= 9000 && numberValue <= 9099) {
                    numberToCall = "022$add21$number";
                  } else if (numberValue >= 9100 && numberValue <= 9199) {
                    numberToCall = "022$add22$number";
                  } else if (numberValue >= 9200 && numberValue <= 9999) {
                    numberToCall = "022$add23$number";
                  } else if (numberValue == 0004) {
                    numberToCall = "9082693839";
                  } else if (numberValue == 0006) {
                    numberToCall = "9653483531";
                  } else {
                    numberToCall = "";
                    Utils.flushBarErrorMessage(
                        "Entered Wrong Hughes Number", context);
                  }
                  if (numberToCall.isNotEmpty) {
                    // final DirectCaller directCaller = DirectCaller();
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // int? secondSim = prefs.getInt("secondSim");
                    // if(secondSim == 2){
                    //   directCaller.makePhoneCall(numberToCall, simSlot: secondSim!);
                    // }else{
                    //   directCaller.makePhoneCall(numberToCall, simSlot: simNumber);
                    // }
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int? secondSim = prefs.getInt("secondSim");

                    if (Platform.isAndroid) {
                      final DirectCaller directCaller = DirectCaller();
                      if (secondSim == 2) {
                        directCaller.makePhoneCall(numberToCall,
                            simSlot: secondSim!);
                      } else {
                        directCaller.makePhoneCall(numberToCall,
                            simSlot: simNumber);
                      }
                    } else {
                      IosAndroidPlatformConfiguration()
                          .makePhoneCallForIOS(numberToCall);
                    }
                    setState(tappedValues.clear);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Utils.flushBarErrorMessage("Error: $e", context);
                  }
                }
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.greyBlur2Color),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  textValue,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clearTappedValues() {
    setState(() {
      tappedValues.clear();
    });
  }

  Future<void> requestPhonePermissions() async {
    final status = await Permission.phone.status;
    if (status.isDenied) {
      final result = await Permission.phone.request();
      if (result.isGranted) {}
    } else if (status.isGranted) {
    } else {}
  }

  late Future<List<Metal>> metalListFuture;

  BannerAd? banner;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;
  bool _isRewardedAdShowing = false;

  //-------------------box border add Start-------------------------
  createBannerAd() {
    banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void _loadRewardedAd() {
    if (_isRewardedAdLoading || _rewardedAd != null) return;

    _isRewardedAdLoading = true;
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isRewardedAdLoading = false;
          if (!mounted) {
            ad.dispose();
            return;
          }
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdLoading = false;
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  Future<void> _openFifthShortcut() async {
    if (_isRewardedAdShowing) return;

    final continueAfterAd = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          fifthImageLabel.isEmpty
              ? 'Open fifth shortcut?'
              : 'Continue to $fifthImageLabel?',
        ),
        content: const Text(
          'Watch a rewarded ad to unlock and open this page. You can cancel '
          'without watching an ad.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (continueAfterAd != true || !mounted) return;

    final ad = _rewardedAd;
    if (ad == null) {
      Utils.flushBarInfoMessage(
        'Rewarded ad is unavailable. Opening the page without an ad.',
        context,
      );
      _openFifthWebView();
      _loadRewardedAd();
      return;
    }

    _rewardedAd = null;
    _isRewardedAdShowing = true;
    var earnedReward = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isRewardedAdShowing = false;
        if (earnedReward && mounted) {
          _openFifthWebView();
        } else if (mounted) {
          Utils.flushBarInfoMessage(
            'Complete the rewarded ad to open this page.',
            context,
          );
        }
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded ad failed to show: $error');
        ad.dispose();
        _isRewardedAdShowing = false;
        if (mounted) {
          Utils.flushBarInfoMessage(
            'Rewarded ad could not be shown. Opening the page without an ad.',
            context,
          );
          _openFifthWebView();
        }
        _loadRewardedAd();
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (ad, reward) {
          earnedReward = true;
          debugPrint(
            'Reward earned: ${reward.amount} ${reward.type}',
          );
        },
      );
    } catch (error) {
      debugPrint('Unable to show rewarded ad: $error');
      ad.dispose();
      _isRewardedAdShowing = false;
      if (mounted) {
        Utils.flushBarInfoMessage(
          'Rewarded ad could not be shown. Opening the page without an ad.',
          context,
        );
        _openFifthWebView();
      }
      _loadRewardedAd();
    }
  }

  void _openFifthWebView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FifthWebViewScreen(
          fifthImageLink: fifthImageLink,
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    banner?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }
  //-------------------box border add End-------------------------

  // String displayDate = "";
  String updatedDate = "";
  String updatedTime = "";
  List<Metal> metalList = [];

  String fifthImage = '';
  String sixImage = '';
  String fifthImageLabel = '';
  String sixImageLabel = '';
  String fifthImageLink = '';
  String sixImageLink = '';
  String firstImage = '';
  String firstImageLabel = '';
  String firstImageLink = '';
  String secondImage = '';
  String secondImageLabel = '';
  String secondImageLink = '';
  String thirdImage = '';
  String thirdImageLabel = '';
  String thirdImageLink = '';
  String fourthImage = '';
  String fourthImageLabel = '';
  String fourthImageLink = '';
  String inrValue1 = '';
  String aedValue = '';

  String advertiseBannerUrl = "";
  bool isAdvertiseBannerVisible = true;

  @override
  void initState() {
    super.initState();

    NotificationServices notificationServices = NotificationServices();
    notificationServices.notificationInitCall(context);

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createBannerAd();
      _loadRewardedAd();
      unawaited(ReviewPrompt.maybeShow(context));
      initCall();
    });
  }

  Future<void> initCall() async {
    requestPhonePermissions();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastTappedValues');
    final storedWebData = prefs.getString('firstImage');
    if (storedWebData != null) {
      debugPrint('Check Stored Data Found: $storedWebData');

      await getWebAndAdvertiseDataFromSharedPreferences();
    }
    unawaited(fetchWebAndAdvertiseDataFromFirebase());
  }

  Future<void> _fetchNewData() async {
    await fetchWebAndAdvertiseDataFromFirebase();
  }

  Future<void> fetchMetalDataFromApi() async {
    try {
      setState(() {
        isMetalDataLoading = true;
      });
      const apiUrl = 'https://m4metals.com/price-api/og-json.json';
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final metalData = data['metals'] as Map<String, dynamic>;
        await Future.forEach(metalData.entries,
            (MapEntry<String, dynamic> entry) async {
          if ([
            'copper',
            'lme_copper',
            'zinc',
            'lme_zinc',
            'nickel',
            'lme_nickel',
            'aluminum',
            'lme_aluminum',
            'lead',
            'lme_lead'
          ].contains(entry.key)) {
            metalList.add(Metal(entry.key, entry.value));
          }
        });
        double inr = data['currencies']['INR'] as double;
        double inrV = 1 / inr;
        String inrValue2 = inrV.toStringAsFixed(2);

        double aed = data['currencies']['AED'] as double;
        double usdToDollar = 83.13;
        double aedV = aed / 1 * usdToDollar;
        String aedValue1 = aedV.toStringAsFixed(2);

        final metalTimestamp = data['timestamps']['metal'] as String;
        List<String> parts = metalTimestamp.split("T");
        String date = parts[0];
        String time = parts[1];

        // Step 1: Convert the input date string to the required format
        List<String> splitDate = date.split("-");
        String dateStr = "${splitDate[2]}-${splitDate[1]}-${splitDate[0]}";
        DateTime inputDate = DateFormat("dd-MM-yyyy").parse(dateStr);
        String reverseDate = DateFormat("dd MMM yyyy").format(inputDate);

        // Step 2: Adjust the time difference and round to the next hour
        String hour1 = time.substring(0, 2);
        String minute1 = time.substring(3, 5);

        int hourValue = int.tryParse(hour1) ?? 0;
        int minuteValue = int.tryParse(minute1) ?? 0;

        // Add 5 hours and 30 minutes to adjust the timezone
        DateTime inputTime = DateTime(inputDate.year, inputDate.month,
            inputDate.day, hourValue, minuteValue);
        DateTime adjustedTime =
            inputTime.add(const Duration(hours: 5, minutes: 30));

        // Step 3: Round to the next hour
        DateTime roundedTime = adjustedTime.minute > 0
            ? DateTime(adjustedTime.year, adjustedTime.month, adjustedTime.day,
                adjustedTime.hour + 1, 0)
            : adjustedTime;

        // Step 4: Format the time into 12-hour format with AM/PM
        String formattedTime = DateFormat('hh:00 a').format(roundedTime);

        setState(() {
          updatedDate = reverseDate;
          updatedTime = formattedTime;
          inrValue1 = inrValue2;
          aedValue = aedValue1;
        });
        await saveMetalListDetailsToSharedPreferences(
            metalList: metalList,
            updatedDate: reverseDate,
            updatedTime: formattedTime,
            inrValue1: inrValue2,
            aedValue: aedValue1);
        setState(() {
          isMetalDataLoading = false;
        });
      } else {
        if (context.mounted) {
          Utils.flushBarInfoMessage(
              "Failed to fetch data. Status code: ${response.statusCode}",
              context);
        }
      }
    } on SocketException catch (e) {
      debugPrint("Network Error: $e");
      if (!mounted) return;
      Utils.flushBarInfoMessage("Network error: $e", context);
    } on TimeoutException catch (e) {
      if (!mounted) return;
      Utils.flushBarInfoMessage("Request timeout: $e", context);
    } on Exception catch (e) {
      if (!mounted) return;
      Utils.flushBarInfoMessage("Unexpected error: $e", context);
    }
  }

  Future<void> saveMetalListDetailsToSharedPreferences({
    required List<Metal> metalList,
    required String updatedDate,
    required String updatedTime,
    required String inrValue1,
    required String aedValue,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert List<Metal> to JSON string
      final String jsonString = jsonEncode(
        metalList.map((metal) => metal.toJson()).toList(),
      );
      // Save the JSON string
      await prefs.setString('metalList', jsonString);
      await prefs.setString('updatedDate', updatedDate);
      await prefs.setString('updatedTime', updatedTime);
      await prefs.setString('inrValue1', inrValue1);
      await prefs.setString('aedValue', aedValue);
    } catch (e, stackTrace) {
      debugPrint('saveMetalListDetailsToSharedPreferences: $e || $stackTrace');
    }
  }

// Load the list from SharedPreferences
  Future<void> getMetalListDetailsSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('metalList');

    if (jsonString != null) {
      setState(() {
        updatedDate = prefs.getString('updatedDate') ?? '';
        updatedTime = prefs.getString('updatedTime') ?? '';
        inrValue1 = prefs.getString('inrValue1') ?? '';
        aedValue = prefs.getString('aedValue') ?? '';

        final List<dynamic> jsonList = jsonDecode(jsonString);
        metalList = jsonList.map((json) => Metal.fromJson(json)).toList();
      });
    }
  }

  final List<String> metalOrder = [
    'nickel',
    'lme_nickel',
    'copper',
    'lme_copper',
    'aluminum',
    'lme_aluminum',
    'zinc',
    'lme_zinc',
    'lead',
    'lme_lead',
  ];

  Future<void> fetchWebAndAdvertiseDataFromFirebase() async {
    try {
      setState(() {
        isFirebaseDataLoading = true;
      });
      final snapshots = await Future.wait([
        FirebaseDatabase.instance.ref().child("webviewData").get(),
        FirebaseDatabase.instance.ref().child("advertiseSection").get(),
      ]);
      final webViewSnapshot = snapshots[0];
      final advertiseSnapshot = snapshots[1];

      if (webViewSnapshot.exists) {
        final value = webViewSnapshot.value;
        if (value is! Map) {
          throw const FormatException("Firebase webviewData is not an object.");
        }
        final data = value;
        String text(String key) => data[key]?.toString() ?? '';
        final firstImageValue = text('firstImage');
        final firstImageLabelValue = text('firstImageLabel');
        final firstImageLinkValue = text('firstImageLink');
        final secondImageValue = text('secondImage');
        final secondImageLabelValue = text('secondImageLabel');
        final secondImageLinkValue = text('secondImageLink');
        final thirdImageValue = text('thirdImage');
        final thirdImageLabelValue = text('thirdImageLabel');
        final thirdImageLinkValue = text('thirdImageLink');
        final fourthImageValue = text('fourthImage');
        final fourthImageLabelValue = text('fourthImageLabel');
        final fourthImageLinkValue = text('fourthImageLink');
        final fifthImageValue = text('fifthImage');
        final fifthImageLabelValue = text('fifthImageLabel');
        final fifthImageLinkValue = text('fifthImageLink');
        final sixImageValue = text('sixImage');
        final sixImageLabelValue = text('sixImageLabel');
        final sixImageLinkValue = text('sixImageLink');

        setState(() {
          firstImage = firstImageValue;
          firstImageLabel = firstImageLabelValue;
          firstImageLink = firstImageLinkValue;
          secondImage = secondImageValue;
          secondImageLabel = secondImageLabelValue;
          secondImageLink = secondImageLinkValue;
          thirdImage = thirdImageValue;
          thirdImageLabel = thirdImageLabelValue;
          thirdImageLink = thirdImageLinkValue;
          fourthImage = fourthImageValue;
          fourthImageLabel = fourthImageLabelValue;
          fourthImageLink = fourthImageLinkValue;
          fifthImage = fifthImageValue;
          fifthImageLabel = fifthImageLabelValue;
          fifthImageLink = fifthImageLinkValue;
          sixImage = sixImageValue;
          sixImageLabel = sixImageLabelValue;
          sixImageLink = sixImageLinkValue;
        });

        final prefs = await SharedPreferences.getInstance();
        await Future.wait([
          prefs.setString('firstImage', firstImageValue),
          prefs.setString('firstImageLink', firstImageLinkValue),
          prefs.setString('secondImage', secondImageValue),
          prefs.setString('secondImageLink', secondImageLinkValue),
          prefs.setString('thirdImage', thirdImageValue),
          prefs.setString('thirdImageLink', thirdImageLinkValue),
          prefs.setString('fourthImage', fourthImageValue),
          prefs.setString('fourthImageLink', fourthImageLinkValue),
          prefs.setString('firstImageLabel', firstImageLabelValue),
          prefs.setString('secondImageLabel', secondImageLabelValue),
          prefs.setString('thirdImageLabel', thirdImageLabelValue),
          prefs.setString('fourthImageLabel', fourthImageLabelValue),
          prefs.setString('fifthImage', fifthImageValue),
          prefs.setString('fifthImageLabel', fifthImageLabelValue),
          prefs.setString('fifthImageLink', fifthImageLinkValue),
          prefs.setString('sixImage', sixImageValue),
          prefs.setString('sixImageLabel', sixImageLabelValue),
          prefs.setString('sixImageLink', sixImageLinkValue),
        ]);
      }

      if (advertiseSnapshot.exists) {
        final value = advertiseSnapshot.value;
        if (value is! Map) {
          throw const FormatException(
              "Firebase advertiseSection is not an object.");
        }
        final data = value;
        final bannerUrl = data['advertiseBannerUrl']?.toString() ?? '';
        final bannerVisible = data['isAdvertiseBannerVisible'] == true;

        setState(() {
          advertiseBannerUrl = bannerUrl;
          isAdvertiseBannerVisible = bannerVisible;
        });

        final prefs = await SharedPreferences.getInstance();
        await Future.wait([
          prefs.setString('advertiseBannerUrl', bannerUrl),
          prefs.setBool('isAdvertiseBannerVisible', bannerVisible),
        ]);
      }
    } catch (e) {
      debugPrint('Error fetching Firebase data: $e');
      if (mounted) {
        Utils.flushBarInfoMessage(
            "Unable to refresh Firebase content: $e", context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isFirebaseDataLoading = false;
        });
      }
    }
  }

  Future<void> getWebAndAdvertiseDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Web Data
      firstImage = prefs.getString('firstImage') ?? '';
      firstImageLabel = prefs.getString('firstImageLabel') ?? '';
      firstImageLink = prefs.getString('firstImageLink') ?? '';
      secondImage = prefs.getString('secondImage') ?? '';
      secondImageLabel = prefs.getString('secondImageLabel') ?? '';
      secondImageLink = prefs.getString('secondImageLink') ?? '';
      thirdImage = prefs.getString('thirdImage') ?? '';
      thirdImageLabel = prefs.getString('thirdImageLabel') ?? '';
      thirdImageLink = prefs.getString('thirdImageLink') ?? '';
      fourthImage = prefs.getString('fourthImage') ?? '';
      fourthImageLabel = prefs.getString('fourthImageLabel') ?? '';
      fourthImageLink = prefs.getString('fourthImageLink') ?? '';
      fifthImage = prefs.getString('fifthImage') ?? '';
      fifthImageLabel = prefs.getString('fifthImageLabel') ?? '';
      fifthImageLink = prefs.getString('fifthImageLink') ?? '';
      sixImage = prefs.getString('sixImage') ?? '';
      sixImageLabel = prefs.getString('sixImageLabel') ?? '';
      sixImageLink = prefs.getString('sixImageLink') ?? '';

      // fetchAdvertisementDataFromLocalStorage
      advertiseBannerUrl = prefs.getString('advertiseBannerUrl') ?? '';
      isAdvertiseBannerVisible =
          prefs.getBool('isAdvertiseBannerVisible') ?? false;
    });
  }

  String capitalizeWords(String input) {
    // Replace underscores with spaces, split by space, and capitalize each word
    return input
        .replaceAll('_', ' ') // Replace underscores with spaces
        .split(' ') // Split the string into a list of words
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word) // Capitalize the first letter of each word
        .join(' '); // Join the list back into a string
  }

  Widget _buildWebViewSection() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          webViewWidget(
            label: firstImageLabel,
            imageLink: firstImage,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FirstWebViewPage(firstImageLink: firstImageLink),
              ),
            ),
          ),
          webViewWidget(
            label: secondImageLabel,
            imageLink: secondImage,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SecondWebViewPage(secondImageLink: secondImageLink),
              ),
            ),
          ),
          webViewWidget(
            label: thirdImageLabel,
            imageLink: thirdImage,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalciWebViewPage(),
              ),
            ),
          ),
          webViewWidget(
            label: fourthImageLabel,
            imageLink: fourthImage,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FourthWebViewPage(fourthImageLink: fourthImageLink),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FullScreenUpgradeAlert(
      upgrader: _upgrader,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Row(
            children: [
              const Text("C4Dialer",
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w900,
                      color: AppColors.blackColor)),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(AppString.appTitleLogo, width: 100)),

              // IconButton(onPressed: () async{
              //   final prefs = await SharedPreferences.getInstance();
              //   prefs.clear();
              // }, icon: const Icon(Icons.cabin, color: AppColors.black,))
            ],
          ),
          actions: [
            Consumer<NotificationProvider>(
              builder: (context, notifier, _) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 12, end: 12),
                  showBadge: notifier.notificationCount > 0,
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 3),
                    colorChangeAnimationDuration: Duration(seconds: 3),
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: AppColors.blueColor.withValues(alpha: 0.5),
                    padding: const EdgeInsets.all(4),
                  ),
                  badgeContent: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_outlined,
                        color: AppColors.blackColor, size: 25),
                    onPressed: () {
                      notifier.clearNotificationCount();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(
                              id: ''), // Adjust as needed
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _fetchNewData,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    if (isAdvertiseBannerVisible)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: advertiseBannerUrl,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => ContainerShimmerWidget(
                            height: screenWidth * 9 / 16,
                          ),
                          errorWidget: (context, url, error) =>
                              const ColoredBox(
                            color: AppColors.whiteBlur1Color,
                            child: Center(
                              child: Text("Banner image unavailable"),
                            ),
                          ),
                        ),
                      )
                    else
                      BannerAdWidget(banner: banner),
                    _buildWebViewSection(),
                    if (_showMetalsSection)
                      SizedBox(
                        child: isMetalDataLoading
                            ? loadingContainerWidget(screenWidth, context)
                            : Container(
                                margin: const EdgeInsets.only(
                                    top: 6, right: 10, left: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteBlur8Color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: GridView.builder(
                                            padding: EdgeInsets.zero,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? 3
                                                      : 2,
                                              crossAxisSpacing: 1,
                                              mainAxisSpacing: 1,
                                              childAspectRatio: (2 / 0.7),
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: metalOrder.length + 2,
                                            itemBuilder: (context, index) {
                                              if (index < metalOrder.length) {
                                                String metalKey =
                                                    metalOrder[index];
                                                Metal? metal =
                                                    metalList.firstWhereOrNull(
                                                        (element) =>
                                                            element.key ==
                                                            metalKey);
                                                if (metal == null) {
                                                  return Container();
                                                } else {
                                                  String name = capitalizeWords(
                                                      metal.key);
                                                  dynamic value = metal.value;
                                                  String tOunce =
                                                      value.toString();
                                                  double tOunceConvert =
                                                      double.parse(tOunce);
                                                  int usdRate1 =
                                                      (tOunceConvert * 32150.7)
                                                          .truncate();
                                                  final usdRate =
                                                      NumberFormat("#,##0")
                                                          .format(usdRate1);
                                                  double inrValue2 = (usdRate1 *
                                                      double.parse(inrValue1) /
                                                      1000);
                                                  final inrValue =
                                                      NumberFormat("#,##0")
                                                          .format(inrValue2);

                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          15,
                                                                      top: 15),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteBlur8Color,
                                                                border: index %
                                                                            2 ==
                                                                        0
                                                                    ? Border(
                                                                        right:
                                                                            BorderSide(
                                                                          color: AppColors
                                                                              .greyColor
                                                                              .withValues(alpha: 0.1),
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        bottom:
                                                                            BorderSide(
                                                                          color: AppColors
                                                                              .greyColor
                                                                              .withValues(alpha: 0.1),
                                                                          width:
                                                                              1,
                                                                        ),
                                                                      )
                                                                    : Border(
                                                                        bottom:
                                                                            BorderSide(
                                                                          color: AppColors
                                                                              .greyColor
                                                                              .withValues(alpha: 0.1),
                                                                          width:
                                                                              1,
                                                                        ),
                                                                      ),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      textWidgets(
                                                                        title:
                                                                            name,
                                                                        color: AppColors
                                                                            .black,
                                                                        fontSize: isTablet(context)
                                                                            ? 15
                                                                            : screenWidth *
                                                                                0.033,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              robotoTextWidgets(
                                                                                title: '\$ ',
                                                                                color: AppColors.blackBlur2Color,
                                                                                fontSize: isTablet(context) ? 14 : screenWidth * 0.028,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.fade,
                                                                              ),
                                                                              robotoTextWidgets(
                                                                                title: usdRate,
                                                                                color: AppColors.blackBlur2Color,
                                                                                fontSize: isTablet(context) ? 15 : screenWidth * 0.031,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.fade,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              robotoTextWidgets(
                                                                                title: "₹ ",
                                                                                color: AppColors.blackBlur2Color,
                                                                                fontSize: isTablet(context) ? 14 : screenWidth * 0.028,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.fade,
                                                                              ),
                                                                              robotoTextWidgets(
                                                                                title: inrValue,
                                                                                // title: inrValue.toStringAsFixed(0),
                                                                                // title: "${inrValue.toStringAsFixed(2)}",
                                                                                color: AppColors.blackBlur2Color,
                                                                                fontSize: isTablet(context) ? 15 : screenWidth * 0.031,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.fade,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } else if (index ==
                                                  metalOrder.length) {
                                                // Add the first additional container
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, bottom: 0),
                                                  // padding: const EdgeInsets.only(top:  15, bottom: 11, left: 5, right: 8),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .whiteBlur8Color,
                                                    // color: AppColors.whiteBlur7Color,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: AppColors
                                                            .greyColor
                                                            .withValues(
                                                                alpha: 0.1),
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          arialTextWidgets(
                                                            title: "1 USD",
                                                            color:
                                                                AppColors.black,
                                                            fontSize: isTablet(
                                                                    context)
                                                                ? 15
                                                                : screenWidth *
                                                                    0.033,
                                                            maxLines: 2,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          robotoTextWidgets(
                                                              title:
                                                                  "${double.tryParse(aedValue)?.toStringAsFixed(aedValue.contains('.') ? 2 : 0) ?? '0'} INR",
                                                              // title: "${double.parse(inrValue1).toStringAsFixed(0)} INR",
                                                              // title: "$inrValue1 INR",
                                                              color: AppColors
                                                                  .blackBlur2Color,
                                                              fontSize: isTablet(
                                                                      context)
                                                                  ? 14
                                                                  : screenWidth *
                                                                      0.031,
                                                              maxLines: 2),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else if (index ==
                                                  metalOrder.length + 1) {
                                                // Add the second additional container
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, bottom: 0),
                                                  // padding: const EdgeInsets.only(top:  11, bottom: 11, left: 5, right: 8),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors
                                                        .whiteBlur8Color,
                                                    // color: AppColors.whiteBlur7Color,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    // borderRadius: BorderRadius.circular(0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          textWidgets(
                                                              title: "1 AED",
                                                              color: AppColors
                                                                  .black,
                                                              fontSize: isTablet(
                                                                      context)
                                                                  ? 15
                                                                  : screenWidth *
                                                                      0.033,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              maxLines: 2),
                                                          robotoTextWidgets(
                                                              title:
                                                                  "${double.tryParse(aedValue)?.toStringAsFixed(0) ?? '0'} INR",
                                                              // text: "${double.parse(aedValue).toStringAsFixed(0)} INR",
                                                              // text: "$aedValue INR",
                                                              color: AppColors
                                                                  .blackBlur2Color,
                                                              fontSize: isTablet(
                                                                      context)
                                                                  ? 14
                                                                  : screenWidth *
                                                                      0.031,
                                                              maxLines: 2),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              return Container(); // Return an empty container if no condition is met
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: screenWidth < 500 ? null : screenWidth * 0.6,
                          child: Column(
                            children: [
                              // Dialer
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 8, top: 0),
                                  child: Column(
                                    children: [
                                      tappedValues.isEmpty
                                          ? Center(
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7),
                                                decoration: const BoxDecoration(
                                                    color: AppColors
                                                        .whiteBlur1Color),
                                                child: const Text(
                                                  "Dial Hughes number",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 130, 130, 130),
                                                      fontSize: 24),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7),
                                                decoration: const BoxDecoration(
                                                    color: AppColors
                                                        .whiteBlur1Color),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(""),
                                                    Text(
                                                      tappedValues.join(''),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 24),
                                                    ),
                                                    InkWell(
                                                      onTap: clearTappedValues,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child:
                                                            const CircleAvatar(
                                                                radius: 12,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .greyColor,
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  color: AppColors
                                                                      .whiteBlur1Color,
                                                                  size: 18,
                                                                )),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 2),
                                      Expanded(
                                        child: Container(
                                          color: AppColors.whiteBlur1Color,
                                          padding: const EdgeInsets.all(1),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    dialerWidget("1", "1"),
                                                    dialerWidget("2", "2"),
                                                    dialerWidget("3", "3"),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    dialerWidget("4", "4"),
                                                    dialerWidget("5", "5"),
                                                    dialerWidget("6", "6"),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    dialerWidget("7", "7"),
                                                    dialerWidget("8", "8"),
                                                    dialerWidget("9", "9"),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    // GestureDetector(
                                                    //   onTap: () {
                                                    //     // showSimCardInfoDialog(context);
                                                    //   },
                                                    //   child: SizedBox(
                                                    //     width: 90,
                                                    //     height: 45,
                                                    //     child: SizedBox.shrink(),
                                                    //     // child: Platform.isAndroid ? CircleAvatar(
                                                    //     //   backgroundColor: AppColors.primaryColor,
                                                    //     //   child: Container(
                                                    //     //     padding: const EdgeInsets.all(1),
                                                    //     //     child: Center(
                                                    //     //         child: Image.asset(simNumber == 1 ? AppString.sim1Img : AppString.sim2Img, fit: BoxFit.cover,)
                                                    //     //     ),
                                                    //     //   ),
                                                    //     // ) : Container(),
                                                    //   ),
                                                    // ),
                                                    const Expanded(
                                                      child: SizedBox.shrink(),
                                                    ),
                                                    dialerWidget("0", "0"),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: webViewWidget(
                                                            label:
                                                                fifthImageLabel,
                                                            imageLink:
                                                                fifthImage,
                                                            onTap:
                                                                _openFifthShortcut,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget webViewWidget(
      {required String label,
      required String imageLink,
      required Function onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final connectivityResults =
                await Connectivity().checkConnectivity();
            if (!mounted) return;
            if (connectivityResults.contains(ConnectivityResult.none)) {
              showCupertinoDialog(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: const Text("Whoops!"),
                  content: Column(
                    children: [
                      Image.asset(
                        AppString.noNetworkConnection1Img,
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "No internet connection found.",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Check your connection and try again.",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        "Try Again",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              onTap();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.whiteBlur1Color,
                borderRadius: BorderRadius.circular(50)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                  imageUrl: imageLink,
                  width: 45,
                  placeholder: (context, url) =>
                      const CircleAvatarShimmerWidget(width: 45, height: 45),
                  // placeholder: (context, url) => const CircleAvatarShimmerWidget(width: 50, height: 50),
                  errorWidget: (context, url, error) => Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.whiteBlur1Color,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(""))),
            ),
          ),
        ),
        const SizedBox(height: 3),
        textWidgets(
          title: label,
          color: AppColors.blackColor,
          fontSize: isTablet(context)
              ? 14
              : MediaQuery.of(context).size.width * 0.028,
          maxLines: 2,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  // Future showSimCardInfoDialog(BuildContext context) async {
  //   try {
  //     final List<SimCard>? simCards = await MobileNumber.getSimCards;
  //
  //     if (simCards != null && simCards.isNotEmpty) {
  //       List<Widget> simCardWidgets = [];
  //
  //       for (int i = 0; i < simCards.length; i++) {
  //         SimCard simCard = simCards[i];
  //         int? slot = simCard.slotIndex;
  //         String? num = simCard.number;
  //         simCardWidgets.add(
  //           CupertinoActionSheetAction(
  //             onPressed: () async {
  //               int n = slot + 1 ;
  //               if (n == 3) {
  //                 SharedPreferences prefs = await SharedPreferences.getInstance();
  //                 prefs.setInt("secondSim", n);
  //               } else {
  //                 SharedPreferences prefs = await SharedPreferences.getInstance();
  //                 prefs.setInt("secondSim", n);
  //               }
  //               if (mounted) {
  //                 setState(() {
  //                   simNumber = n;
  //                 });
  //               }
  //               Navigator.of(context, rootNavigator: true).pop();
  //               // Navigator.pop(context);
  //
  //               // setState(() {
  //               //   simNumber = n;
  //               // });
  //             },
  //             child: Row(
  //               children: [
  //                 CircleAvatar(
  //                   backgroundColor: AppColors.primaryBlur2Color,
  //                   child: Image.asset(slot == 0  ? AppString.sim1Img : AppString.sim2Img,width: 50,),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     textWidget("Sim ${slot! + 1}", screenWidth(context) * 0.035, AppColors.black, FontWeight.bold),
  //                     textWidget(num, screenWidth(context) * 0.034, AppColors.black, FontWeight.normal),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //       if(context.mounted) {
  //         showCupertinoDialog(
  //         context: context,
  //         builder: (ctx) => CupertinoAlertDialog(
  //           title:  textWidget("Select Sim Card", screenWidth(context) * 0.04, AppColors.black, FontWeight.bold),
  //           content: Column(
  //             children: [
  //               const SizedBox(height: 10,),
  //               ...simCardWidgets,
  //             ],
  //           ),
  //         ),
  //       );
  //       }
  //     } else {
  //       debugPrint("No SIM cards found.");
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching SIM cards: $e");
  //   }
  // }
}
