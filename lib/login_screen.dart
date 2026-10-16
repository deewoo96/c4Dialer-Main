import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/app_colors.dart';
import 'Utils/app_string.dart';
import 'Utils/common_widgets.dart';
import 'Utils/utils.dart';
import 'bottom_bar/restart_widget.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final TextEditingController _hughesController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final double profileHeight = 90;
  bool isLoading = false;
  bool otpVisibility = false;
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


  @override
  void initState() {
    // analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  // Number not exist isLoggedIn: true and hughesNumber: U_0006 from LoginScreen afterVerifyOtp
  // I/flutter (15761): its happeningi automaitcaly clreared
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
                "Login Now",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w900,
                    color: AppColors.blackColor
                )),
            Container(padding: const EdgeInsets.only(left:10), child: Image.asset(AppString.appTitleLogo,width: 100)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset(AppString.login2Image,width: 170,)),
              CircleAvatar(
                radius: profileHeight / 2,
                backgroundColor: AppColors.primaryBlur3Color,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    AppString.callPng, width: screenWidth * 0.15,),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.08,
              ),
              Text("Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.07,
                  color: AppColors.blackColor,
                  fontFamily: 'Poppins',
                ),),
              Text(
                "Login to continue",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.05,
                  color: AppColors.blackColor,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(
                height: screenWidth * 0.05,
              ),
              TextFormField(
                controller: _hughesController,
                cursorColor: AppColors.blackColor,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                maxLength: 4,
                style: TextStyle(
                    color: AppColors.blackColor, fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBlur3Color)
                  ),
                  focusedBorder:  const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryBlur3Color)
                  ),
                  counterText: "",
                  labelStyle: const TextStyle(fontFamily: 'Poppins',
                    color: AppColors.hintLabelTextColor,),
                  contentPadding: EdgeInsets.only(left: screenWidth * 0.1),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.008),
                    child: const Icon(Icons.call,color: AppColors.primaryBlur3Color,),
                  ),
                  labelText: "Hughes number",
                ),),

              Visibility(
                visible: otpVisibility,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenWidth * 0.03,
                    ),
                    textWidget(
                        "Please enter the OTP received on your hughes number ${_hughesController.text}", screenWidth * 0.035,AppColors.blackColor,FontWeight.normal),
                    SizedBox(
                      height: screenWidth * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01),
                      child: SizedBox(
                        width: screenWidth,
                        child: Pinput(
                          autofocus: true,
                          length: 4,
                          controller: _otpController,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          defaultPinTheme: PinTheme(
                            height: 60,
                            width: 60,
                            textStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: screenWidth * 0.06,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.2),
                                width: 1.0,
                              ),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            height: screenWidth * 0.15,
                            width: screenWidth * 0.16,
                            textStyle: TextStyle(
                              fontSize: screenWidth * 0.06,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: AppColors.primaryColor.withValues(alpha: 0.2),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenWidth * 0.04,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlur3Color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          )
                      ),
                      onPressed: () async {
                        if (!otpVisibility) {
                          await checkNumberIsValid();
                        }else{
                          await verifyOtp();
                        }
                      },
                      child: isLoading ? const CircularProgressIndicator(color: AppColors.whiteColor,) : Text(
                        otpVisibility ? "Verify" : "Submit",
                        // otpVisibility ? "Verify" : "Send Otp",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.whiteColor
                        ),
                      )
                  )
              )


            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkNumberIsValid() async {
    bool isValid = false;
    String number = _hughesController.text;
    debugPrint("number: $number");
    if(number.isEmpty || number == ""){
      Utils.flushBarErrorMessage("Enter Correct Hughes Number", context);
    }else{
      if(number.length==4){
          String joinedHughesNumber= "";
        int numberValue = int.parse(number);

          if( numberValue >=1000 && numberValue <= 1099 ) {
            joinedHughesNumber = "22$add1$number";
            isValid = true;
          }else if( numberValue >=1100 && numberValue <= 1299 ){
            joinedHughesNumber = "22$add2$number";
            isValid = true;
          }else if( numberValue >=1300 && numberValue <= 1399){
            joinedHughesNumber = "22$add3$number";
            isValid = true;
          }else if( numberValue >=1400 && numberValue <= 1499 ){
            joinedHughesNumber = "22$add4$number";
            isValid = true;
          }else if( numberValue >=1500 && numberValue <= 1679 ){
            joinedHughesNumber = "22$add5$number";
            isValid = true;
          }else if( numberValue >=1680 && numberValue <= 1999 ){
            joinedHughesNumber = "22$add6$number";
            isValid = true;
          }else if(numberValue >=2000 && numberValue <= 3499 ){
            joinedHughesNumber = "22$add7$number";
            isValid = true;
          }else if(numberValue >=3500 && numberValue <= 4999 ){
            joinedHughesNumber = "22$add8$number";
            isValid = true;
          } else if(numberValue >=5000 && numberValue <= 5999 ){
            joinedHughesNumber = "22$add9$number";
            isValid = true;
          } else if(numberValue >=6000 && numberValue <=6399 ){
            joinedHughesNumber = "22$add10$number";
            isValid = true;
          } else if(numberValue >=6400 && numberValue <=6999 ){
            joinedHughesNumber = "22$add11$number";
            isValid = true;
          } else if(numberValue >=7000 && numberValue <=7099 ){
            joinedHughesNumber = "22$add12$number";
            isValid = true;
          }else if(numberValue >=7100 && numberValue <=7899 ){
            joinedHughesNumber = "22$add13$number";
            isValid = true;
          }else if(numberValue >=7900 && numberValue <=7909 ){
            joinedHughesNumber = "22$add14$number";
            isValid = true;
          }else if(numberValue >=7910 && numberValue <=8009 ){
            joinedHughesNumber = "22$add15$number";
            isValid = true;
          }else if(numberValue >=8010 && numberValue <=8069 ){
            joinedHughesNumber = "22$add16$number";
            isValid = true;
          }else if(numberValue >=8070 && numberValue <=8079 ){
            joinedHughesNumber = "22$add17$number";
            isValid = true;
          }else if(numberValue >=8080 && numberValue <=8099 ){
            joinedHughesNumber = "22$add18$number";
            isValid = true;
          }else if(numberValue >=8100 && numberValue <=8499 ){
            joinedHughesNumber = "22$add19$number";
            isValid = true;
          }else if(numberValue >=8500 && numberValue <=8999 ){
            joinedHughesNumber = "22$add20$number";
            isValid = true;
          }else if(numberValue >=9000 && numberValue <=9099 ){
            joinedHughesNumber = "22$add21$number";
            isValid = true;
          }else if(numberValue >=9100 && numberValue <=9199 ){
            joinedHughesNumber = "22$add22$number";
            isValid = true;
          }else if(numberValue >=9200 && numberValue <=9999 ){
            joinedHughesNumber = "22$add23$number";
            isValid = true;
          } else if(numberValue == 0004){
            joinedHughesNumber = "9082693839";
            isValid = true;
          }else if(numberValue == 0006){ // exist
          joinedHughesNumber = "9653483531";
          isValid = true;
        } else if(numberValue == 0039){ // test login: no OTP, logs in directly
          joinedHughesNumber = "0039";
          isValid = true;
        } else {
          Utils.flushBarErrorMessage("Entered Wrong Hughes Number", context);
          isValid = false;
        }
        if(isValid){
          if(joinedHughesNumber == "9082693839" || joinedHughesNumber == "9653483531" || joinedHughesNumber == "0039") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("joinedHughesNumber", joinedHughesNumber);
            await prefs.setString("number", number);
            afterVerifyOtp(context, number);
          }else{
            Utils.flushBarInfoMessage("You will receive a call for the OTP", context);
            const apiKey = 'c16b5e94-ab6b-11ed-813b-0200cd936042';
            final sendOtpUrl = "https://2factor.in/API/V1/$apiKey/VOICE/$joinedHughesNumber/AUTOGEN";
            debugPrint("Send Otp Url: $sendOtpUrl");
            try {
              final response = await http.get(Uri.parse(sendOtpUrl));
              if (response.statusCode == 200) {
                setState(() {otpVisibility = true;});
                final responseBody = jsonDecode(response.body);
                if (responseBody['Status'] == 'Success') {
                  String sessionId = responseBody['Details'];

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("joinedHughesNumber", joinedHughesNumber);
                  await prefs.setString("sessionId", sessionId);
                  await prefs.setString("number", number);

                  debugPrint("Send Otp On Voice Call Status: ${response.statusCode}");
                  debugPrint("Send Otp On Voice Call Response: ${response.body}");
                } else {
                  String error = responseBody['Details'];
                  if(context.mounted) Utils.flushBarErrorMessage(error, context);
                }
              } else {
                final Map<String, dynamic> responseData = json.decode(response.body);
                final String errorMessage = responseData['Error'];
                if(context.mounted) Utils.flushBarErrorMessage(errorMessage, context);
              }
            } catch (e) {
              if(context.mounted) Utils.flushBarErrorMessage("Error $e", context);
            }
          }
        }else{
          Utils.flushBarErrorMessage("Entered Wrong Hughes Number", context);
        }
      }else{
        Utils.flushBarErrorMessage("Enter Correct 4 Digits Hughes Number", context);
      }
    }
  }

  Future<void> verifyOtp()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   String? joinedHughesNumber = prefs.getString("joinedHughesNumber");
   String? number = prefs.getString("number");
   String? sessionId = prefs.getString("sessionId");
    const apiKey = 'c16b5e94-ab6b-11ed-813b-0200cd936042';
    debugPrint("joinedHughesNumber: $joinedHughesNumber");

    final verifyUrl = "https://2factor.in/API/V1/$apiKey/VOICE/VERIFY/$sessionId/${_otpController.text}";

    debugPrint("Verify Otp Url: $verifyUrl");
    try{
      final verifyResponse = await http.get(Uri.parse(verifyUrl));
      if (verifyResponse.statusCode == 200) {
        final responseBody = json.decode(verifyResponse.body);

        debugPrint("Verify Otp Voice Call Response: ${verifyResponse.body} || Status Code: ${verifyResponse.statusCode}");

        if (responseBody['Status'] == "Success") {
          afterVerifyOtp(context, number!);
        } else {
          prefs.remove("number");
          prefs.remove("sessionId");
          _otpController.clear();
          otpVisibility = false;
          setState(() {});
          Utils.flushBarErrorMessage("OTP verification failed: ${responseBody['Details']}", context);
        }
      }else{
        _otpController.clear();
        otpVisibility = false;
        setState(() {});
        final responseBody = json.decode(verifyResponse.body);
        if (responseBody['Status'] == "Error") {
          Utils.flushBarErrorMessage(responseBody['Details'], context);
        }

        // final Map<String, dynamic> responseData = json.decode(verifyResponse.body);
        // final String errorMessage = responseData['Error'];
        // Utils.flushBarErrorMessage(errorMessage, context);
      }
    }catch(error){
      debugPrint("errorMessage:::::: $error");
      _otpController.clear();
      otpVisibility = false;
      setState(() {});
      Utils.flushBarErrorMessage("Error: $error", context);
    }
  }

  Future<void> afterVerifyOtp(BuildContext context, String hughesNumber) async {
    if (!mounted) return;
    setState(() {isLoading = true;});
    final dynamicLoginNumber = "U_$hughesNumber";
    try {
      final databaseReference = FirebaseDatabase.instance.ref().child("Users");
      final userLookups = await Future.wait([
        for (final field in ["hughes1", "hughes2", "hughes3", "hughes4"])
          databaseReference
              .orderByChild(field)
              .equalTo(hughesNumber)
              .once()
              .timeout(const Duration(seconds: 20)),
      ]);

      Map<dynamic, dynamic>? userDetails;
      for (final result in userLookups) {
        final matches = result.snapshot.value;
        if (matches is Map) {
          for (final value in matches.values) {
            if (value is Map) {
              userDetails = Map<dynamic, dynamic>.from(value);
              break;
            }
          }
        }
        if (userDetails != null) break;
      }

      if (userDetails == null) {
        final existingDynamicUser = await databaseReference
            .child(dynamicLoginNumber)
            .get()
            .timeout(const Duration(seconds: 20));
        if (existingDynamicUser.value is Map) {
          userDetails =
              Map<dynamic, dynamic>.from(existingDynamicUser.value as Map);
        }
      }

      final prefs = await SharedPreferences.getInstance();
      if (userDetails != null) {
        final storedNumber = (userDetails["hughes1"] ?? hughesNumber).toString();
        await Future.wait([
          prefs.setString("companyName",
              (userDetails["companyName"] ?? "").toString()),
          prefs.setString("companyDetails",
              (userDetails["companyDetails"] ?? "").toString()),
          prefs.setString("categorySelected",
              (userDetails["categorySelected"] ?? "").toString()),
          prefs.setString("productKeyword",
              (userDetails["productKeyword"] ?? "").toString()),
          prefs.setString("url", (userDetails["url"] ?? "").toString()),
          prefs.setString(
              "hughes2", (userDetails["hughes2"] ?? "").toString()),
          prefs.setString(
              "hughes3", (userDetails["hughes3"] ?? "").toString()),
          prefs.setString(
              "hughes4", (userDetails["hughes4"] ?? "").toString()),
          prefs.setString("name", (userDetails["name"] ?? "").toString()),
          prefs.setString("name1", (userDetails["name1"] ?? "").toString()),
          prefs.setString("name2", (userDetails["name2"] ?? "").toString()),
          prefs.setString("phoneNumber",
              (userDetails["phoneNumber"] ?? "").toString()),
          prefs.setString("phoneNumber1",
              (userDetails["phoneNumber1"] ?? "").toString()),
          prefs.setString("phoneNumber2",
              (userDetails["phoneNumber2"] ?? "").toString()),
          prefs.setBool("isLoggedIn", true),
          prefs.setString("number",
              storedNumber.startsWith("U_") ? storedNumber : hughesNumber),
        ]);
        debugPrint(
            "isLoggedIn: true and hughesNumber: $hughesNumber from LoginScreen afterVerifyOtp");
        FocusManager.instance.primaryFocus?.unfocus();
        if (!mounted) return;
        Utils.flushBarSuccessMessage(
            "You Have Logged In Successfully", context);
        RestartAppWidget.restartApp(context);
      } else {
        debugPrint("User with Hughes Number $hughesNumber not found.");
        final reference = databaseReference.child(dynamicLoginNumber);
        final newUserData = <String, dynamic>{
          "categorySelected": "",
          "companyDetails": "",
          "companyName": "",
          "hughes1": dynamicLoginNumber,
          "hughes2": "",
          "hughes3": "",
          "hughes4": "",
          "login_status": true,
          "name": "",
          "name1": "",
          "name2": "",
          "phoneNumber": "",
          "phoneNumber1": "",
          "phoneNumber2": "",
          "productKeyword": "",
          "url": "",
        };
        await reference
            .set(newUserData)
            .timeout(const Duration(seconds: 20));
        await Future.wait([
          prefs.setString("number", dynamicLoginNumber),
          prefs.setBool("isLoggedIn", true),
        ]);
        FocusManager.instance.primaryFocus?.unfocus();
        if (!mounted) return;
        RestartAppWidget.restartApp(context);
      }
    } catch (error) {
      debugPrint("Login error for $hughesNumber: $error");
      if (mounted) {
        Utils.animatedErrorSnackBarMessage("Error: $error", context);
      }
    } finally {
      if (mounted) {
        setState(() {isLoading = false;});
      }
    }
  }


  }
