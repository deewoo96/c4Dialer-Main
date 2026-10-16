// import 'package:c4dialer/Utils/app_colors.dart';
// import 'package:c4dialer/Utils/utils.dart';
// import 'package:c4dialer/widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:readmore/readmore.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../Utils/app_string.dart';
//
// class MyProfileWidget extends StatefulWidget {
//   String appBarTitle,
//       companyName,
//       selectedCategory,
//       companyAddress,
//       productKeyword,
//       websiteUrl,
//       firstPhoneNumber,
//       secondPhoneNumber,
//       firstHughesNumber,
//       secondHughesNumber,
//       thirdHughesNumber,
//       fourthHughesNumber,
//       name1,
//       name2;
//
//   MyProfileWidget({
//     super.key,
//     required this.appBarTitle,
//     required this.companyName,
//     required this.selectedCategory,
//     required this.companyAddress,
//     required this.productKeyword,
//     required this.websiteUrl,
//     required this.firstPhoneNumber,
//     required this.secondPhoneNumber,
//     required this.firstHughesNumber,
//     required this.secondHughesNumber,
//     required this.thirdHughesNumber,
//     required this.fourthHughesNumber,
//     required this.name1,
//     required this.name2,
//   });
//
//
//   @override
//   State<MyProfileWidget> createState() => _MyProfileWidgetState();
// }
//
// class _MyProfileWidgetState extends State<MyProfileWidget> {
//   String add1 = "6654";
//   String add2 = "6752";
//   String add3 = "6615";
//   String add4 = "6658";
//   String add5 = "6615";
//   String add6 = "6636";
//   String add7 = "6639";
//   String add8 = "6659";
//   String add9 = "6749";
//   String add10 = "6743";
//   String add11 = "6615";
//   String add12 = "6743";
//   String add13 = "6615";
//   String add14 = "6743";
//   String add15 = "6651";
//   String add16 = "6615";
//   String add17 = "6743";
//   String add18 = "6610";
//   String numberToCall = "";
//   Future<void> makeCall(number) async {
//     int numberValue  = int.parse(number);
//     if( numberValue >=1000 && numberValue <= 1099 ) {
//       numberToCall = "022$add1$number";
//     }else if( numberValue >=1100 && numberValue <= 1299 ){
//       numberToCall = "022$add2$number";
//     }else if( numberValue >=1300 && numberValue <= 1499){
//       numberToCall = "022$add3$number";
//     }else if( numberValue >=1500 && numberValue <= 1679 ){
//       numberToCall = "022$add4$number";
//     }else if( numberValue >=1680 && numberValue <= 1999 ){
//       numberToCall = "022$add5$number";
//     }else if( numberValue >=2000 && numberValue <= 3499 ){
//       numberToCall = "022$add6$number";
//     }else if(numberValue >=3500 && numberValue <= 4999 ){
//       numberToCall = "022$add7$number";
//     }else if(numberValue >=5000 && numberValue <= 5999 ){
//       numberToCall = "022$add8$number";
//     } else if(numberValue >=6000 && numberValue <= 5399 ){
//       numberToCall = "022$add9$number";
//     } else if(numberValue >=6400 && numberValue <=6999 ){
//       numberToCall = "022$add10$number";
//     } else if(numberValue >=7000 && numberValue <=7099 ){
//       numberToCall = "022$add11$number";
//     } else if(numberValue >=7100 && numberValue <=7999 ){
//       numberToCall = "022$add12$number";
//     }else if(numberValue >=8000 && numberValue <=8099 ){
//       numberToCall = "022$add13$number";
//     }else if(numberValue >=8100 && numberValue <=8499 ){
//       numberToCall = "022$add14$number";
//     }else if(numberValue >=8500 && numberValue <=8999 ){
//       numberToCall = "022$add15$number";
//     }else if(numberValue >=9000 && numberValue <=9099 ){
//       numberToCall = "022$add16$number";
//     }else if(numberValue >=9100 && numberValue <=9199 ){
//       numberToCall = "022$add17$number";
//     }else if(numberValue >=9200 && numberValue <=9999 ){
//       numberToCall = "022$add18$number";
//     }else{
//       Utils.flushBarErrorMessage("Entered Wrong Hughes Number", context);
//     }
//     bool? response = await FlutterPhoneDirectCaller.callNumber(numberToCall);
//     debugPrint("call Response: $response");
//   }
//   bool isLinkClicked= false;
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.whiteBlur1Color,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         automaticallyImplyLeading: false,
//         leading: GestureDetector(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back_ios_outlined,color: AppColors.black,)),
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
//             Container(padding:  EdgeInsets.only(left:10), child: Image.asset(AppString.appTitleLogo,width: 100)),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding:  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     padding:  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                     decoration: BoxDecoration(
//                         color: AppColors.whiteColor,
//                         borderRadius: BorderRadius.circular(5)
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextWidget(color: AppColors.blackColor, text: widget.companyName, fontSize: 13, fontWeight: FontWeight.bold),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         TextWidget(color: AppColors.blueColor, text: widget.selectedCategory, fontSize: 12, fontWeight: FontWeight.w500),
//
//                         widget.productKeyword.isEmpty ? Container() : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height:15,
//                             ),
//                             TextWidget(color: AppColors.blackColor, text: "Product Keywords", fontSize: 12, fontWeight: FontWeight.w600),
//                             Container(
//                               width: screenWidth * 0.8,
//                               child:  ReadMoreText(
//                                 "widget.productKeyword",
//                                 trimLines: 5,
//                                 colorClickableText: Colors.blue,
//                                 trimMode: TrimMode.Line,
//                                 trimCollapsedText: '...Read More',
//                                 trimExpandedText: ' less ',
//                                 style: TextStyle(
//                                     color: AppColors.blackBlurColor,
//                                     fontSize: 12,
//                                     fontFamily: "Poppins",
//                                     fontWeight: FontWeight.w500
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         widget.companyAddress.isEmpty ? Container() :
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height:15,
//                             ),
//                             TextWidget(color: AppColors.blackColor, text: "Address", fontSize: 12, fontWeight: FontWeight.w600),
//                             Container(
//                               width: screenWidth * 0.8,
//                               child:  ReadMoreText(
//                                 widget.companyAddress,
//                                 trimLines: 5,
//                                 colorClickableText: Colors.blue,
//                                 trimMode: TrimMode.Line,
//                                 trimCollapsedText: '...Read More',
//                                 trimExpandedText: ' less ',
//                                 style: TextStyle(
//                                     color: AppColors.blackBlurColor,
//                                     fontSize: 12,
//                                     fontFamily: "Poppins",
//                                     fontWeight: FontWeight.w500
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         widget.websiteUrl.isEmpty ? Container() : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height:15,
//                             ),
//                             TextWidget(color: AppColors.blackColor, text: "Website", fontSize: 12, fontWeight: FontWeight.w600),
//                             GestureDetector(
//                               onTap: (){
//                                 setState(() {
//                                   isLinkClicked = true;
//                                 });
//                               },
//                               child: Container(
//                                 width: screenWidth * 0.8,
//                                 decoration: BoxDecoration(
//                                   color: isLinkClicked ? AppColors.greyBlur2Color : AppColors.whiteColor,
//                                 ),
//                                 child:  ReadMoreText(
//                                   "jfdfkjdfjdkfjkdjkdfjkdj",
//                                   // widget.websiteUrl,
//                                   trimLines: 5,
//                                   colorClickableText: AppColors.blueColor,
//                                   trimMode: TrimMode.Line,
//                                   trimCollapsedText: '...Read More',
//                                   trimExpandedText: ' less ',
//                                   style: TextStyle(
//                                       color:  AppColors.blueColor,
//                                       fontSize: 12,
//                                       fontFamily: "Poppins",
//                                       fontWeight: FontWeight.w500
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     padding:  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                     decoration: BoxDecoration(
//                         color: AppColors.whiteColor,
//                         borderRadius: BorderRadius.circular(5)
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextWidget(color: AppColors.blackColor, text: "Contact Details", fontSize: 13, fontWeight: FontWeight.bold),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         widget.firstPhoneNumber.isEmpty ? Container() :  Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             TextWidget(color: AppColors.blackColor, text: widget.name1, fontSize: 12, fontWeight: FontWeight.w600),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   TextWidget(color: AppColors.blackColor, text: widget.firstPhoneNumber, fontSize: 12, fontWeight: FontWeight.w600),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   InkWell(
//                                       onTap: (){
//                                         Utils.makingDirectPhoneCall(widget.firstPhoneNumber);
//                                       },
//                                       child: FaIcon(
//                                         FontAwesomeIcons.phone,
//                                         color: Colors.blue,
//                                         size: 17,
//                                       )
//                                   ),
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                   InkWell(
//                                       onTap: (){
//                                         Utils.openWhatsApp(widget.firstPhoneNumber, "Hi ${widget.name1}",context);
//                                       },
//                                       child: FaIcon(
//                                         FontAwesomeIcons.whatsapp,
//                                         color: Colors.green,)
//                                   ),
//
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         widget.secondPhoneNumber.isEmpty ? Container() : Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             TextWidget(color: AppColors.blackColor, text: widget.name2, fontSize: 12, fontWeight: FontWeight.w600),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   TextWidget(color: AppColors.blackColor, text: widget.secondPhoneNumber, fontSize: 12, fontWeight: FontWeight.w600),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   InkWell(
//                                       onTap: (){
//                                         Utils.makingDirectPhoneCall(widget.secondPhoneNumber);
//                                       },
//                                       child: FaIcon(
//                                         FontAwesomeIcons.phone,
//                                         color: Colors.blue,
//                                         size: 17,
//                                       )
//                                   ),
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                   InkWell(
//                                       onTap: (){
//                                         Utils.openWhatsApp(widget.secondPhoneNumber, "Hi ${widget.name2}",context);
//                                       },
//                                       child: FaIcon(
//                                         FontAwesomeIcons.whatsapp,
//                                         color: Colors.green,)
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Wrap(
//                     spacing: 5.0,
//                     runSpacing: 5.1,
//                     children: [
//                       widget.firstHughesNumber.isEmpty ? Container() :
//                       GestureDetector(
//                         onTap: ()=> makeCall(widget.firstHughesNumber),
//                         child: Container(
//                           width: 90,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                               color: AppColors.whiteColor,
//                               borderRadius: BorderRadius.circular(50)
//                           ),
//                           child: Center(child: TextWidget(color: AppColors.blackColor, text: widget.firstHughesNumber, fontSize: 12, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                       widget.secondHughesNumber.isEmpty ? Container() :
//                       GestureDetector(
//                         onTap: ()=> makeCall(widget.secondHughesNumber),
//                         child: Container(
//                           width: 90,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                               color: AppColors.whiteColor,
//                               borderRadius: BorderRadius.circular(50)
//                           ),
//                           child: Center(child: TextWidget(color: AppColors.blackColor, text: widget.secondHughesNumber, fontSize: 12, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                       widget.thirdHughesNumber.isEmpty ? Container() :
//                       GestureDetector(
//                         onTap: ()=> makeCall(widget.thirdHughesNumber),
//                         child: Container(
//                           width: 90,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                               color: AppColors.whiteColor,
//                               borderRadius: BorderRadius.circular(50)
//                           ),
//                           child: Center(child: TextWidget(color: AppColors.blackColor, text: widget.thirdHughesNumber, fontSize: 12, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                       widget.fourthHughesNumber.isEmpty ? Container() :
//                       GestureDetector(
//                         onTap: ()=> makeCall(widget.fourthHughesNumber),
//                         child: Container(
//                           width: 90,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                               color: AppColors.whiteColor,
//                               borderRadius: BorderRadius.circular(50)
//                           ),
//                           child: Center(child: TextWidget(color: AppColors.blackColor, text: widget.fourthHughesNumber, fontSize: 12, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 50,
//             margin: EdgeInsets.only(bottom: 10,left: 7,right: 7),
//             child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.whiteColor,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50)
//                     )
//                 ),
//                 onPressed: (){},
//                 child: Text("Edit Profile",style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold),)
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
