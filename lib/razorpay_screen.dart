import 'package:flutter/material.dart';
import 'Utils/app_colors.dart';
import 'Utils/app_string.dart';
import 'widgets/text_widget.dart';

class RazorpayScreen extends StatelessWidget {
  const RazorpayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBlur1Color,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Row(
          children: [
            const Text(
                "C4Dialer",
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
      body: Center(child: TextWidget(color: AppColors.blackColor, text: "For advertising , contact WhatsApp/Call: +91 90826 93839", fontSize: 12, fontWeight: FontWeight.w600)),

    );
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:crypto/crypto.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:readmore/readmore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Utils/app_colors.dart';
// import 'Utils/app_string.dart';
// import 'Utils/common_widgets.dart';
// import 'Utils/utils.dart';
// import 'widgets/container_shimmer_widget.dart';
// import 'widgets/text_widget.dart';
//
//
// class RazorPayScreen extends StatefulWidget {
//   const RazorPayScreen({super.key});
//
//   @override
//   State<RazorPayScreen> createState() => _RazorPayScreenState();
// }
//
// class _RazorPayScreenState extends State<RazorPayScreen> {
//   TextEditingController messageController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   int totalAmount = 0;
//   bool isLoading = false;
//   bool isLoaded = false;
//   bool isSendNotificationOn = false;
//   bool isDirectMessageOn = false;
//   bool isWhatsAppMessageOn= false;
//   bool isPersonalCallOn = false;
//
//   String environmentValue = 'PRODUCTION';
//   String appId = "c18decfa1fe546fe8b873b0dbb5bedea";
//   String merchantId = "M18KTPMPEFP8";
//   String saltKey = "d714eea6-e752-494f-bf21-a6588767d817";
//
//   // String environmentValue = 'UAT_SIM'; // for production pass ==> PRODUCTION
//   // String appId = ""; // Testing
//   // String merchantId = "PGTESTPAYUAT"; // testing
//   // String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399"; // testing
//   String packageName = "com.phonepe.app"; // for production
//   String checksum = "";
//   String saltIndex = "1";
//   String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
//   String callBackURL = "https://rdsgn.in/"; // by default you can set any link like google.com
//   // String callBackURL = "https://webhook.site/a2117bcf-b1d0-4f9e-8ec3-2696b0980f8f"; // by default you can set any link like google.com
//   String body = "";
//   Object? result;
//   bool enableLogging = true;
//   final String apiEndPoint = "/pg/v1/pay";
//
//   getCheckSum(){
//     final requestData = {
//       "merchantId": merchantId,
//       "merchantTransactionId": transactionId,
//       "merchantUserId": "90223250",
//       "amount": totalAmount * 100,
//       "mobileNumber": "9999999999",
//       "callbackUrl": callBackURL,
//       "paymentInstrument": {
//         "type": "PAY_PAGE",
//       },
//     };
//     String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
//     checksum = '${sha256.convert(utf8.encode(base64Body+apiEndPoint+saltKey)).toString()}###$saltIndex';
//     return base64Body;
//   }
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   phonePeInit();
//   //   loadDataFromFirebase();
//   //   // body = getCheckSum().toString();
//   // }
//   @override
//   void initState(){
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       checkDataExist();
//     });
//     super.initState();
//   }
//   Future checkDataExist() async {
//     phonePeInit();
//     // body = getCheckSum().toString();
//     final prefs = await SharedPreferences.getInstance();
//     final storedNotificationData = prefs.getString('bannerDescription');
//     if(storedNotificationData != null){
//       await getNotificationDataFromSharedPreferences();
//     }else{
//      await loadDataFromFirebase();
//     }
//
//   }
//   void phonePeInit() {
//     PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
//         .then((val) => {
//       setState(() {
//         result = 'PhonePe SDK Initialized - $val';
//       })
//     }).catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
//
//   void startPGTransaction() async {
//     try {
//       var response = PhonePePaymentSdk.startTransaction(getCheckSum().toString(), callBackURL, checksum, packageName );
//       // var response = PhonePePaymentSdk.startPGTransaction(body, callBackURL, checksum, {}, apiEndPoint, "");
//       response.then((val) async {
//         if(val != null){
//           String status = val['status'].toString();
//           String error = val['error'].toString();
//
//           if(status == "SUCCESS"){
//             result = "Flow complete - status : SUCCESS";
//             await checkStatus();
//           }else{
//             result = "Flow complete - status : $status and error : $error";
//           }
//         }else{
//           result = "Flow Incomplete";
//         }
//       }).catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     } catch (error) {
//       handleError(error);
//     }
//   }
//
//   void handleError(error) {
//     setState(() {
//       if (error is Exception) {
//         result = error.toString();
//       } else {
//         result = {"error": error};
//       }
//     });
//   }
//
//   Future checkStatus() async{
//     try{
//       String url = "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId";
//       String concatString = "/pg/v1/status/$merchantId/$transactionId$saltKey";
//       var bytes = utf8.encode(concatString);
//       var digest = sha256.convert(bytes).toString();
//       String xVerify = "$digest###$saltIndex";
//
//       Map<String, String> headers = {
//         "Content-Type" : "application/json",
//         "X-VERIFY" : xVerify,
//         "X-MERCHANT-ID" : merchantId
//       };
//
//       await http.get(Uri.parse(url),headers: headers).then((value) async {
//         Map<String, dynamic> response = jsonDecode(value.body);
//         try{
//           if(response["success"] && response["code"] == "PAYMENT_SUCCESS" && response["data"]["state"] == "COMPLETED"){
//              await storeUserDetailsInFirebaseDatabase(paymentStatus: "success").whenComplete((){
//                Utils.flushBarSuccessMessage(response["message"], context);
//              });
//           }else{
//             Utils.flushBarErrorMessage("Something Went Wrong", context);
//           }
//         }catch(error){
//           Utils.flushBarErrorMessage("Something Went Wrong $error", context);
//         }
//       });
//
//     }catch (error) {
//       Utils.flushBarErrorMessage("Error: $error", context);
//     }
//   }
//
//   // ask for phone pe team for this ==> debug or release mode app id
//   void getPackageSignatureForAndroid() {
//     if (Platform.isAndroid) {
//       PhonePePaymentSdk.getPackageSignatureForAndroid()
//           .then((packageSignature) => {
//         setState(() {
//           result = 'getPackageSignatureForAndroid - $packageSignature';
//         })
//       })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     }
//   }
//
//   Future storeUserDetailsInFirebaseDatabase({required String paymentStatus}) async{
//     setState(() {
//       isLoading = true;
//     });
//     // First User Should login then he get hughes number then following code perform so you need to show fist login screen
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String hughesNumber = prefs.getString("number") ?? "";
//     // String hughesNumber = "U_0006";
//     final databaseReference = FirebaseDatabase.instance.ref().child("Users");
//     final List<String> hughesNumberKeys = ["hughes1", "hughes2", "hughes3", "hughes4"];
//     bool foundMatch = false;
//     try{
//       for(String hughesNumberKey in hughesNumberKeys ){
//         final updateDetails =  await databaseReference.orderByChild(hughesNumberKey).equalTo(hughesNumber).once();
//         if(updateDetails.snapshot.value != null){
//           if (updateDetails.snapshot.value is Map) {
//             (updateDetails.snapshot.value as Map).forEach((key, value) {
//               final userKey = key;
//               databaseReference.child(userKey).update({
//                 "message": messageController.text,
//                 "phoneNumber": phoneNumberController.text,
//                 "paymentAmount": totalAmount.toString(),
//                 "payment": paymentStatus
//               }).then((value){
//                 messageController.text = "";
//                 phoneNumberController.text = "";
//               });
//               foundMatch = true;
//             });
//             setState(() {
//               isLoading = false;
//             });
//           }
//         }
//         if (foundMatch) {
//           break;
//         }
//       }
//
//     }catch(error){
//       setState(() {
//         isLoading = false;
//       });
//       Utils.animatedErrorSnackBarMessage("Error: $error", context);
//     }
//   }
//
//   String bannerDeadline = "";
//   String bannerDescription = "";
//   String bannerImage = "";
//   String bannerTitle = "";
//   String notificationDescription = "";
//   String notificationTitle = "";
//   String smsDescription = "";
//   String smsTitle = "";
//   String voiceCallDescription = "";
//   String voiceCallTitle = "";
//   String whatsAppDescription = "";
//   String whatsAppTitle = "";
//   String notificationAmount = "";
//   String smsAmount = "";
//   String voiceCallAmount = "";
//   String whatsAppAmount = "";
//   String forMoreDetailsNumber = "";
//   // ---------------------------- Load Data From Database Section Start-----------------------------------
//   Future loadDataFromFirebase() async{
//     setState(() {isLoaded = true;});
//     late DatabaseReference notificationRef = FirebaseDatabase.instance.ref().child("notificationSection");
//     notificationRef.onValue.listen((event) async{
//       if (event.snapshot.value != null) {
//         final data = event.snapshot.value as Map<dynamic, dynamic>;
//        await saveNotificationDataToSharedPreferences(data);
//
//         setState(() {
//           bannerDeadline = data['bannerDeadline'];
//           bannerDescription = data['bannerDescription'];
//           bannerImage = data['bannerImage'];
//           bannerTitle = data['bannerTitle'];
//           notificationDescription = data['notificationDescription'];
//           notificationTitle = data['notificationTitle'];
//           smsDescription = data['smsDescription'];
//           smsTitle = data['smsTitle'];
//           voiceCallDescription = data['voiceCallDescription'];
//           voiceCallTitle = data['voiceCallTitle'];
//           whatsAppDescription = data['whatsAppDescription'];
//           whatsAppTitle = data['whatsAppTitle'];
//           notificationAmount = data['notificationAmount'];
//           smsAmount = data['smsAmount'];
//           voiceCallAmount = data['voiceCallAmount'];
//           whatsAppAmount = data['whatsAppAmount'];
//           forMoreDetailsNumber = data['forMoreDetailsNumber'];
//           isLoaded = false;
//         });
//       }
//     });
//   }
//   // ---------------------------- Load Data From Database Section End------------------------------------
//
//   Future saveNotificationDataToSharedPreferences (Map<dynamic, dynamic> data) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('bannerDeadline', data['bannerDeadline']);
//     await prefs.setString('bannerDescription', data['bannerDescription']);
//     await prefs.setString('bannerImage', data['bannerImage']);
//     await prefs.setString('bannerTitle', data['bannerTitle']);
//     await prefs.setString('notificationDescription', data['notificationDescription']);
//     await prefs.setString('notificationTitle', data['notificationTitle']);
//     await prefs.setString('smsDescription', data['smsDescription']);
//     await prefs.setString('smsTitle', data['smsTitle']);
//     await prefs.setString('voiceCallDescription', data['voiceCallDescription']);
//     await prefs.setString('voiceCallTitle', data['voiceCallTitle']);
//     await prefs.setString('whatsAppDescription', data['whatsAppDescription']);
//     await prefs.setString('whatsAppTitle', data['whatsAppTitle']);
//     await prefs.setString('notificationAmount', data['notificationAmount']);
//     await prefs.setString('smsAmount', data['smsAmount']);
//     await prefs.setString('voiceCallAmount', data['voiceCallAmount']);
//     await prefs.setString('whatsAppAmount', data['whatsAppAmount']);
//     await prefs.setString('forMoreDetailsNumber', data['forMoreDetailsNumber']);
//   }
//
//   Future getNotificationDataFromSharedPreferences() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       bannerDeadline = prefs.getString('bannerDeadline') ?? '';
//       bannerDescription = prefs.getString('bannerDescription') ?? '';
//       bannerImage = prefs.getString('bannerImage') ?? '';
//       bannerTitle = prefs.getString('bannerTitle') ?? '';
//       notificationDescription = prefs.getString('notificationDescription') ?? '';
//       notificationTitle = prefs.getString('notificationTitle') ?? '';
//       smsDescription = prefs.getString('smsDescription') ?? '';
//       smsTitle = prefs.getString('smsTitle') ?? '';
//       voiceCallDescription = prefs.getString('voiceCallDescription') ?? '';
//       voiceCallTitle = prefs.getString('voiceCallTitle') ?? '';
//       whatsAppDescription = prefs.getString('whatsAppDescription') ?? '';
//       whatsAppTitle = prefs.getString('whatsAppTitle') ?? '';
//       notificationAmount = prefs.getString('notificationAmount') ?? '';
//       smsAmount = prefs.getString('smsAmount') ?? '';
//       voiceCallAmount = prefs.getString('voiceCallAmount') ?? '';
//       whatsAppAmount = prefs.getString('whatsAppAmount') ?? '';
//       forMoreDetailsNumber = prefs.getString('forMoreDetailsNumber') ?? '';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteBlur1Color,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         elevation: 0,
//         title: Row(
//           children: [
//             const Text(
//                 "C4Dialer",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontFamily: "Poppins",
//                     fontWeight: FontWeight.w900,
//                     color: AppColors.blackColor
//                 )),
//             Container(padding: const EdgeInsets.only(left:10), child: Image.asset(AppString.appTitleLogo,width: 100)),
//           ],
//         ),
//         // actions: [
//         //   TextButton(
//         //       onPressed: () async{
//         //     if(totalAmount != 0){
//         //       if(isSendNotificationOn || isDirectMessageOn || isWhatsAppMessageOn || isPersonalCallOn){
//         //         if(phoneNumberController.text.length  == 10){
//         //           if(messageController.text.isNotEmpty){
//         //             showCupertinoDialog(
//         //               context: context,
//         //               builder: (ctx) => CupertinoAlertDialog(
//         //                 title: const Text("Message", style: TextStyle(
//         //                   fontSize: 17,
//         //                   fontFamily: "Poppins",
//         //                   fontWeight: FontWeight.bold,
//         //                   color: AppColors.blackColor,
//         //                 ),),
//         //                 content: Column(
//         //                   children: [
//         //                     const SizedBox(height: 10),
//         //                     Image.asset(AppString.paymentGatewayImg, width: 50,),
//         //                     const SizedBox(height: 10),
//         //                     const Text(
//         //                       "You will now be redirected to Payment gateway for the payment",
//         //                       style: TextStyle(fontSize: 14),
//         //                       textAlign: TextAlign.center,
//         //                     ),
//         //                   ],
//         //                 ),
//         //                 actions: [
//         //                   CupertinoDialogAction(
//         //                     child: const Text("Cancel", style: TextStyle(
//         //                       fontSize: 15,
//         //                       fontFamily: "Poppins",
//         //                       fontWeight: FontWeight.bold,
//         //                       color: AppColors.blackColor,
//         //                     ),),
//         //                     onPressed: () {
//         //                       Navigator.of(context, rootNavigator: true).pop();
//         //                       // Navigator.pop(context);
//         //                     },
//         //                   ),
//         //                   CupertinoDialogAction(
//         //                     child: const Text("Proceed", style: TextStyle(
//         //                       fontSize: 15,
//         //                       fontFamily: "Poppins",
//         //                       fontWeight: FontWeight.bold,
//         //                       color: AppColors.blackColor,
//         //                     ),),
//         //                     onPressed: () {
//         //                       Navigator.of(context, rootNavigator: true).pop();
//         //                       // Navigator.pop(context);
//         //                       startPGTransaction();
//         //                     },
//         //                   ),
//         //                 ],
//         //               ),
//         //             );
//         //             // startPGTransaction();
//         //           }else{
//         //             Utils.animatedErrorSnackBarMessage("Please enter your message to broadcast", context);
//         //           }
//         //         } else{
//         //           Utils.animatedErrorSnackBarMessage("Please enter valid 10 digits mobile number", context);
//         //         }
//         //       }
//         //     }else{
//         //       Utils.animatedErrorSnackBarMessage("Please select at least one broadcast message", context);
//         //     }
//         //   },
//         //       child: isLoading ? const CircularProgressIndicator(color: AppColors.whiteColor,)  : Text("${totalAmount == 0 ? "" : "₹ ${totalAmount}"} Pay Now",style: const TextStyle(fontWeight: FontWeight.bold)))
//         // ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Container(
//         width: double.infinity,
//         height: 50,
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryBlur3Color,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50)
//               )
//           ),
//             onPressed: () async{
//               if(totalAmount != 0){
//                 if(isSendNotificationOn || isDirectMessageOn || isWhatsAppMessageOn || isPersonalCallOn){
//                   if(phoneNumberController.text.length  == 10){
//                     if(messageController.text.isNotEmpty){
//                       showCupertinoDialog(
//                         context: context,
//                         builder: (ctx) => CupertinoAlertDialog(
//                           title: const Text("Message", style: TextStyle(
//                             fontSize: 17,
//                             fontFamily: "Poppins",
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.blackColor,
//                           ),),
//                           content: Column(
//                             children: [
//                               const SizedBox(height: 10),
//                               Image.asset(AppString.paymentGatewayImg, width: 50,),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 "You will now be redirected to Payment gateway for the payment",
//                                 style: TextStyle(fontSize: 14),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             CupertinoDialogAction(
//                               child: const Text("Cancel", style: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.blackColor,
//                               ),),
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true).pop();
//                                 // Navigator.pop(context);
//                               },
//                             ),
//                             CupertinoDialogAction(
//                               child: const Text("Proceed", style: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.blackColor,
//                               ),),
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true).pop();
//                                 // Navigator.pop(context);
//                                 startPGTransaction();
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                       // startPGTransaction();
//                     }else{
//                       Utils.animatedErrorSnackBarMessage("Please enter your message to broadcast", context);
//                     }
//                   } else{
//                     Utils.animatedErrorSnackBarMessage("Please enter valid 10 digits mobile number", context);
//                   }
//                 }
//               }else{
//                 Utils.animatedErrorSnackBarMessage("Please select at least one broadcast message", context);
//               }
//             },
//             child: isLoading ? const CircularProgressIndicator(color: AppColors.whiteColor,)  : Text("${totalAmount == 0 ? "" : "₹ $totalAmount"} Pay Now",style: const TextStyle(fontWeight: FontWeight.bold))
//       ),
//       ),
//       body:
//       isLoaded ? const Center(child: CircularProgressIndicator()) :
//       RefreshIndicator(
//         onRefresh: () async{
//           return Future.delayed(
//             const Duration(seconds: 2),
//                 () async{
//                  await loadDataFromFirebase();
//               if(context.mounted) Utils.flushBarInfoMessage("Details Has Been Updated Successfully", context);
//             },
//           );
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               CachedNetworkImage(
//                 imageUrl: bannerImage,
//                 width: screenWidth,
//                   placeholder: (context, url) => const ContainerShimmerWidget(height: 177,),
//                 errorWidget: (context, url, error) =>  const Text("")
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // TextWidget(
//                     //     color: AppColors.blackColor,
//                     //     text: bannerTitle,
//                     //     fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold,
//                     //
//                     // ),
//                     ReadMoreText(
//                       bannerTitle,
//                       trimLines: 5,
//                       colorClickableText: Theme.of(context).primaryColor,
//                       trimMode: TrimMode.Line,
//                       trimCollapsedText: '...Read More',
//                       trimExpandedText: ' less ',
//                       style:  TextStyle(
//                           color: AppColors.blackColor,
//                           fontSize: screenWidth * 0.05,
//                           fontFamily: AppString.font,
//                           fontWeight: FontWeight.bold
//                       ),
//                     ),
//                     const SizedBox(height: 7),
//                     Container(
//                         width: screenWidth,
//                         child:  ReadMoreText(
//                           bannerDescription,
//                           trimLines: 5,
//                           colorClickableText: Theme.of(context).primaryColor,
//                           trimMode: TrimMode.Line,
//                           trimCollapsedText: '...Read More',
//                           trimExpandedText: ' less ',
//                           style:  TextStyle(
//                               color: AppColors.blackColor,
//                               fontSize: screenWidth * 0.038,
//                               fontFamily: AppString.font,
//                               fontWeight: FontWeight.normal
//                           ),
//                         )
//                     ),
//                     const SizedBox(height: 10),
//                     TextWidget(
//                         color: AppColors.blackColor,
//                         text: bannerDeadline,
//                         fontSize: screenWidth * 0.038, fontWeight: FontWeight.normal
//                     ),
//                     const SizedBox(height: 5),
//                     GestureDetector(
//                       onTap: (){
//                         Utils.openWhatsApp(forMoreDetailsNumber, "",context);
//                       },
//                       child: textWidgets(
//                           color: AppColors.blackColor,
//                           title: "For more details click on below number to chat with us on WhatsApp: +91$forMoreDetailsNumber",
//                           fontSize: screenWidth * 0.038, fontWeight: FontWeight.normal
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       width: screenWidth,
//                       padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColors.whiteColor,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextWidget(
//                               color: AppColors.blackColor,
//                               text: "Broadcast Message",
//                               fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold
//                           ),
//                           const SizedBox(height: 5,),
//                           TextFormField(
//                             controller: messageController,
//                             maxLines: 5,
//                             style: TextStyle(fontSize: screenWidth * 0.035),
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: AppColors.whiteBlur1Color,
//                               hintText: "Type your Broadcast message here...",
//                               hintStyle: TextStyle(fontSize: screenWidth * 0.035),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.01)),
//                                 borderRadius: BorderRadius.circular(20),
//                               )
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           TextWidget(
//                               color: AppColors.blackColor,
//                               text: "Mobile Number",
//                               fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold
//                           ),
//                           const SizedBox(height: 5,),
//                           TextFormField(
//                             controller: phoneNumberController,
//                             style: TextStyle(fontSize: screenWidth * 0.035),
//                             keyboardType: TextInputType.number,
//                             maxLength: 10,
//                             decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: AppColors.whiteBlur1Color,
//                                 hintText: "Enter 10 digit mobile number",
//                                 hintStyle: TextStyle(fontSize: screenWidth * 0.035),
//                                 contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.01)),
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               counterText: ""
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20,),
//                     Container(
//                       width: screenWidth,
//                       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColors.whiteColor,
//                       ),
//                       child: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TextWidget(
//                                   color: AppColors.blackColor,
//                                   text: notificationTitle,
//                                   fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold
//                               ),
//                               const SizedBox(height: 5,),
//                               Container(
//                                 width: screenWidth * 0.7,
//                                 child:  ReadMoreText(
//                                   notificationDescription,
//                                   trimLines: 5,
//                                   colorClickableText: Theme.of(context).primaryColor,
//                                   trimMode: TrimMode.Line,
//                                   trimCollapsedText: '...Read More',
//                                   trimExpandedText: ' less ',
//                                   style:  TextStyle(
//                                       color: AppColors.blackBlurColor,
//                                       fontSize: screenWidth * 0.03,
//                                       fontFamily: AppString.font,
//                                       fontWeight: FontWeight.normal
//                                   ),
//                                 )
//                               ),
//                               const SizedBox(height: 4,),
//                               TextWidget(
//                                   color: AppColors.blueColor,
//                                   text: "₹ $notificationAmount",
//                                   fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child: CupertinoFormRow(
//                               child: CupertinoSwitch(
//                                 value: isSendNotificationOn,
//                                 onChanged: (bool value) {
//                                   setState(() {
//                                     isSendNotificationOn = value;
//                                     isSendNotificationOn ? totalAmount +=  int.parse(notificationAmount) : totalAmount -=  int.parse(notificationAmount);
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10,),
//                     Container(
//                       width: screenWidth,
//                       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColors.whiteColor,
//                       ),
//                       child: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TextWidget(
//                                   color: AppColors.blackColor,
//                                   text: smsTitle,
//                                   fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold
//                               ),
//                               const SizedBox(height: 5,),
//                               Container(
//                                   width: screenWidth * 0.7,
//                                   child:  ReadMoreText(
//                                     smsDescription,
//                                     trimLines: 5,
//                                     colorClickableText: Theme.of(context).primaryColor,
//                                     trimMode: TrimMode.Line,
//                                     trimCollapsedText: '...Read More',
//                                     trimExpandedText: ' less ',
//                                     style:  TextStyle(
//                                         color: AppColors.blackBlurColor,
//                                         fontSize: screenWidth * 0.03,
//                                         fontFamily: AppString.font,
//                                         fontWeight: FontWeight.normal
//                                     ),
//                                   )
//                               ),
//                               const SizedBox(height: 4,),
//                               TextWidget(
//                                   color: AppColors.blueColor,
//                                   text: "₹ $smsAmount",
//                                   fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child:  CupertinoFormRow(
//                               child: CupertinoSwitch(
//                                 value: isDirectMessageOn,
//                                 onChanged: (bool value) {
//                                   setState(() {
//                                     isDirectMessageOn = value;
//                                     isDirectMessageOn ? totalAmount +=  int.parse(smsAmount): totalAmount -= int.parse(smsAmount);
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10,),
//                     Container(
//                       width: screenWidth,
//                       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColors.whiteColor,
//                       ),
//                       child: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TextWidget(
//                                   color: AppColors.blackColor,
//                                   text: whatsAppTitle,
//                                   fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold
//                               ),
//                               const SizedBox(height: 5,),
//                               Container(
//                                   width: screenWidth * 0.7,
//                                   child:  ReadMoreText(
//                                     whatsAppDescription,
//                                     trimLines: 5,
//                                     colorClickableText: Theme.of(context).primaryColor,
//                                     trimMode: TrimMode.Line,
//                                     trimCollapsedText: '...Read More',
//                                     trimExpandedText: ' less ',
//                                     style:  TextStyle(
//                                         color: AppColors.blackBlurColor,
//                                         fontSize: screenWidth * 0.03,
//                                         fontFamily: AppString.font,
//                                         fontWeight: FontWeight.normal
//                                     ),
//                                   )
//                               ),
//                               const SizedBox(height: 4,),
//                               TextWidget(
//                                   color: AppColors.blueColor,
//                                   text: "₹ $whatsAppAmount",
//                                   fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child:  CupertinoFormRow(
//                               child: CupertinoSwitch(
//                                 value: isWhatsAppMessageOn,
//                                 onChanged: (bool value) {
//                                   setState(() {
//                                     isWhatsAppMessageOn = value;
//                                     isWhatsAppMessageOn ? totalAmount +=   int.parse(whatsAppAmount): totalAmount -=  int.parse(whatsAppAmount);
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10,),
//                     Container(
//                       width: screenWidth,
//                       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColors.whiteColor,
//                       ),
//                       child: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TextWidget(
//                                   color: AppColors.blackColor,
//                                   text: voiceCallTitle,
//                                   fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold
//                               ),
//                               const SizedBox(height: 5,),
//                               Container(
//                                   width: screenWidth * 0.7,
//                                   child:  ReadMoreText(
//                                     voiceCallDescription,
//                                     trimLines: 5,
//                                     colorClickableText: Theme.of(context).primaryColor,
//                                     trimMode: TrimMode.Line,
//                                     trimCollapsedText: '...Read More',
//                                     trimExpandedText: ' less ',
//                                     style:  TextStyle(
//                                         color: AppColors.blackBlurColor,
//                                         fontSize: screenWidth * 0.03,
//                                         fontFamily: AppString.font,
//                                         fontWeight: FontWeight.normal
//                                     ),
//                                   )
//                               ),
//                               const SizedBox(height: 4,),
//                               TextWidget(
//                                   color: AppColors.blueColor,
//                                   text: "₹ $voiceCallAmount",
//                                   fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child:   CupertinoFormRow(
//                               child: CupertinoSwitch(
//                                 value: isPersonalCallOn,
//                                 onChanged: (bool value) {
//                                   setState(() {
//                                     isPersonalCallOn = value;
//                                     isPersonalCallOn ? totalAmount +=  int.parse(voiceCallAmount): totalAmount -=  int.parse(voiceCallAmount);
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 150),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



