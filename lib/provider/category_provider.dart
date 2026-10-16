import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import '../Utils/utils.dart';

class CategoryProviderViewModel with ChangeNotifier {
  String _selectedCategory = "";
  String get selectedCategory => _selectedCategory;



  setSelectedCategory(String selectedCategory, BuildContext context){
    _selectedCategory = selectedCategory;
    Navigator.pop(context);
    notifyListeners();
  }

  setCategory(String selectedCategory){
    _selectedCategory = selectedCategory;
    debugPrint("setCategory: $_selectedCategory");
    notifyListeners();
  }

}

class PhoneCallClass {
  static Future phoneNumberToCall({required String number, required BuildContext context}) async{
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
    String add23= "6610";
    String numberToCall = "";
    int numberValue  = int.parse(number);
    if( numberValue >=1000 && numberValue <= 1099 ) {
      numberToCall = "022$add1$number";
    }else if( numberValue >=1100 && numberValue <= 1299 ){
      numberToCall = "022$add2$number";
    }else if( numberValue >=1300 && numberValue <= 1399){
      numberToCall = "022$add3$number";
    }else if( numberValue >=1400 && numberValue <= 1499 ){
      numberToCall = "022$add4$number";
    }else if( numberValue >=1500 && numberValue <= 1679 ){
      numberToCall = "022$add5$number";
    }else if( numberValue >=1680 && numberValue <= 1999 ){
      numberToCall = "022$add6$number";
    }else if(numberValue >=2000 && numberValue <= 3499 ){
      numberToCall = "022$add7$number";
    }else if(numberValue >=3500 && numberValue <= 4999 ){
      numberToCall = "022$add8$number";
    } else if(numberValue >=5000 && numberValue <= 5999 ){
      numberToCall = "022$add9$number";
    } else if(numberValue >=6000 && numberValue <=6399 ){
      numberToCall = "022$add10$number";
    } else if(numberValue >=6400 && numberValue <=6999 ){
      numberToCall = "022$add11$number";
    } else if(numberValue >=7000 && numberValue <=7099 ){
      numberToCall = "022$add12$number";
    }else if(numberValue >=7100 && numberValue <=7899 ){
      numberToCall = "022$add13$number";
    }else if(numberValue >=7900 && numberValue <=7909 ){
      numberToCall = "022$add14$number";
    }else if(numberValue >=7910 && numberValue <=8009 ){
      numberToCall = "022$add15$number";
    }else if(numberValue >=8010 && numberValue <=8069 ){
      numberToCall = "022$add16$number";
    }else if(numberValue >=8070 && numberValue <=8079 ){
      numberToCall = "022$add17$number";
    }else if(numberValue >=8080 && numberValue <=8099 ){
      numberToCall = "022$add18$number";
    }else if(numberValue >=8100 && numberValue <=8499 ){
      numberToCall = "022$add19$number";
    }else if(numberValue >=8500 && numberValue <=8999 ){
      numberToCall = "022$add20$number";
    }else if(numberValue >=9000 && numberValue <=9099 ){
      numberToCall = "022$add21$number";
    }else if(numberValue >=9100 && numberValue <=9199 ){
      numberToCall = "022$add22$number";
    }else if(numberValue >=9200 && numberValue <=9999 ){
      numberToCall = "022$add23$number";
    } else if(numberValue == 0004 ){
      numberToCall = "9082693839";
    }else if(numberValue == 0006 ){
      numberToCall = "9653483531";
    } else{
      numberToCall = "";
      Utils.flushBarErrorMessage("Entered Wrong Hughes Number", context);
    }

    // if(numberToCall.isNotEmpty) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // int? simNumber = prefs.getInt("secondSim");
      // final DirectCaller directCaller = DirectCaller();
      // directCaller.makePhoneCall(numberToCall, simSlot: simNumber ?? 1);
    // }
    IosAndroidPlatformConfiguration().initiatePhoneCall(numberToCall: numberToCall);

  }
}


class IosAndroidPlatformConfiguration {

  Future<void> initiatePhoneCall({required String numberToCall}) async {
    if (numberToCall.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? simNumber = prefs.getInt("secondSim");
      makePhoneCallChecker(numberToCall: numberToCall, simNumber: simNumber ?? 1);
    }
  }

  void makePhoneCallChecker({required String numberToCall, required int simNumber}) {
    if (Platform.isAndroid) {
      final DirectCaller directCaller = DirectCaller();
      directCaller.makePhoneCall(numberToCall, simSlot: simNumber);
    } else if (Platform.isIOS) {
      // Handle iOS call here
      makePhoneCallForIOS(numberToCall);
    }
  }

  // Future<void> makePhoneCallForIOS(String numberToCall) async{
  //   try{
  //     final Uri launchUri = Uri(
  //       scheme: 'tel',
  //       path: "+91$numberToCall",
  //     );
  //     debugPrint("LaunchUrl: $launchUri");
  //     await launchUrl(launchUri);
  //   }catch(e) {
  //     debugPrint("Error On Calling From Url Launcher: $e");
  //   }
  // }

  // Future<void> makePhoneCallForIOS(String numberToCall) async{
  //   var url = Uri.parse("tel:$numberToCall");
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> makePhoneCallForIOS(String numberToCall) async {
    final Uri url = Uri(scheme: 'tel', path: numberToCall);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
