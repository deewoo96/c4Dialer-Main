import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app_colors.dart';
import 'app_string.dart';

class Utils {
  static void makingDirectPhoneCall(String number) async {
    bool? response = await FlutterPhoneDirectCaller.callNumber(number);
  }

  static void openWhatsApp(String mobileNumber, String defaultMessage,
      BuildContext context) async {
    var whatsappUrl = "whatsapp://send?phone=+91$mobileNumber&text=${Uri
        .encodeComponent(defaultMessage)}";
    Uri url = Uri.parse(whatsappUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrlString(whatsappUrl);
      } else {
        if (context.mounted) {
          animatedErrorSnackBarMessage(
            "Unable To Message, Please Try Again Later ☹️", context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        animatedErrorSnackBarMessage(
          "Message ☹️: $e", context);
      }
    }
  }

  static void makingPhoneCall(String mobileNumber, BuildContext context) async {
    var uri = 'tel:$mobileNumber';
    Uri url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      flushBarInfoMessage('Making Call', context);
    } else {
      animatedErrorSnackBarMessage(
          'Unable To Call Please Try Again Later ☹️', context);
    }
  }

  static void animatedErrorSnackBarMessage(String message,
      BuildContext context) {
    AnimatedSnackBar.material(
        message,
        type: AnimatedSnackBarType.error,
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        duration: const Duration(seconds: 8)
    ).show(context);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 5),
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        icon: const Icon(Icons.error),
      )
        ..show(context),
    );
  }

  static void flushBarInfoMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        backgroundColor: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 8),
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        boxShadows: [
          BoxShadow(
            color: AppColors.shimmerDarkColor,
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
        messageText: Text(
          message,
          style: const TextStyle(color: AppColors.blackColor),
        ),
        icon: const Icon(Icons.info_outline, color: AppColors.blackColor,),
      )
        ..show(context),
    );
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        backgroundColor: AppColors.greenColor,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 8),
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        icon: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: FaIcon(
            FontAwesomeIcons.circleCheck, color: AppColors.whiteColor,),
        ),
      )
        ..show(context),
    );
  }

  static void checkNetworkConnectivity(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (ctx) =>
              Container(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        Image.asset(
                          AppString.noNetworkConnection1Img, width: 150,),
                        const SizedBox(height: 10),
                        const Text(
                          "Whoops!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
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
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                )
                            ),
                            child: const Text("Try Again", style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
    }
  }

  static void launchUrlUtils(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // await launchUrl(uri);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void openGoogleMap(
      {required String address, required BuildContext context}) async {
    String url = "http://maps.google.com/?q=$address";
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        Utils.flushBarErrorMessage("'Unable To Search Address ☹️", context);
      }
    }
  }
}

String capitalizeFirstLetterOfEachWord(String text) {
  if (text.isEmpty) {
    return '';
  }
  List<String> words = text.split(' ');
  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
  }

  return words.join(' ');
}
