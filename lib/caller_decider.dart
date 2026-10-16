part of 'home_imports.dart';


class DialerClass {
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

  Future<void> makeCall({required String number, required BuildContext context}) async {
    debugPrint("fjkfjdk: $number");
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
    }
    else if(numberValue == 0004 ){
      numberToCall = "9082693839";
    }
    else if(numberValue == 0006 ){
      numberToCall = "9653483531";
    } else{
      numberToCall = "";
      Utils.flushBarErrorMessage("Entered Wrong Hughes Number", context);
    }
    if(numberToCall.isNotEmpty) {
      IosAndroidPlatformConfiguration().makePhoneCallForIOS(numberToCall);
    }
    // bool? response = await FlutterPhoneDirectCaller.callNumber(numberToCall);
  }

  String getHughesNumber(String hughesNumber){
    return hughesNumber.startsWith("U_") ? hughesNumber.substring(2) : hughesNumber;
  }


  Future<void> storeDataListInSharedPreferences(List<Map<dynamic, dynamic>> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    prefs.setString('userData50', jsonData);
  }

  Future<List<Map<dynamic, dynamic>>> fetchDataListFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('userData50');

    if (jsonData != null && jsonData.isNotEmpty) {
      List<dynamic> decodedData = jsonDecode(jsonData);
      return List<Map<dynamic, dynamic>>.from(decodedData);
    } else {
      return [];
    }
  }
}