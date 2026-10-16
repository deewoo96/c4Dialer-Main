import 'package:flutter/material.dart';

import '../widgets/text_widget.dart';
import 'app_colors.dart';

// Widget buildBannerWidget(BannerAd? banner) {
//   if (banner == null) {
//     return Container();
//   } else {
//     return SizedBox(
//       height: 70,
//       child: AdWidget(ad: banner),
//     );
//   }
// }

bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width > 600;
}

Widget textWidget(String? title, double? fontSize, Color? color, FontWeight? fontWeight) {
  return Text(title!, style: TextStyle(fontFamily: "Poppins",  color: color, fontSize: fontSize, fontWeight: fontWeight ));
}

Widget textWidgets({required String? title, required double? fontSize, Color? color, FontWeight?
fontWeight,TextOverflow? overflow, int? maxLines, TextAlign? textAlign,double? letterSpacing= 0,TextDecoration? decoration,}) {
  return Text(
      title!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: "Poppins",
          color: color, fontSize: fontSize,
          fontWeight: fontWeight ,
          overflow: overflow,
          letterSpacing: letterSpacing!,
          decoration: decoration
      ));
}

Widget robotoTextWidgets({required String? title, required double? fontSize, Color? color, FontWeight?
fontWeight,TextOverflow? overflow, int? maxLines, TextAlign? textAlign,double? letterSpacing= 0,TextDecoration? decoration,}) {
  return Text(
      title!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: "Roboto",
          color: color, fontSize: fontSize,
          fontWeight: fontWeight ,
          overflow: overflow,
          letterSpacing: letterSpacing!,
          decoration: decoration
      ));
}

Widget arialTextWidgets({required String? title, required double? fontSize, Color? color, FontWeight?
fontWeight,TextOverflow? overflow, int? maxLines, TextAlign? textAlign,double? letterSpacing= 0,TextDecoration? decoration,}) {
  return Text(
      title!,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: "Arial",
          color: color, fontSize: fontSize,
          fontWeight: fontWeight ,
          overflow: overflow,
          letterSpacing: letterSpacing!,
          decoration: decoration
      ));
}


double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
Widget listTileContainer({required String title}){
  return Container(
    decoration: BoxDecoration(
        border: Border(
        bottom: BorderSide(
        color: AppColors.greyColor.withValues(alpha: 0.2)
    ))),
    child: ListTile(
      dense: true,
      leading: const Text(""),
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      title: TextWidget(color: AppColors.blackColor, text: title, fontSize: 13, fontWeight: FontWeight.w500,),
    ),
  );
}
Widget loadingContainerWidget(double screenWidth, BuildContext context){
  return Container(
    margin: const EdgeInsets.only(top:6,right: 10, left: 10),
    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    decoration: BoxDecoration(
        color: AppColors.whiteBlur8Color,
        borderRadius: BorderRadius.circular(5),
    ),
    width: screenWidth,
    height: 150,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    rowLoadingWidget("Nickel", "Lme Nickel",screenWidth, context),
                    const SizedBox(height: 15,),
                    rowLoadingWidget("Copper", "Lme Copper",screenWidth, context),
                    const SizedBox(height: 15,),
                    rowLoadingWidget("Aluminum", "Aluminum Copper",screenWidth, context),
                    const SizedBox(height: 15,),
                    rowLoadingWidget("Zinc", "Lme zinc",screenWidth, context),
                    const SizedBox(height: 15,),
                    rowLoadingWidget("Lead", "Lme lead",screenWidth, context),
                    const SizedBox(height: 15,),
                    rowLoadingWidget("1 USD", "1 AED",screenWidth, context),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget rowLoadingWidget(String leftTitle, String rightTitle,double screenWidth, BuildContext context){
  return Row(
    children: [
     Expanded(
       child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               textWidgets(
                 title: leftTitle,
                 color: AppColors.black,
                 maxLines: 2,
                 fontSize: isTablet(context) ? 15 : screenWidth * 0.033,
                 fontWeight: FontWeight.w500,
                 overflow: TextOverflow.fade,
               ),
               Column(
                 children: [
                   textWidgets(
                     title: "--",
                     color: AppColors.blackColor,
                     fontSize: isTablet(context) ? 15 : screenWidth * 0.031,
                     fontWeight: FontWeight.bold,
                     maxLines: 2,

                   ),
                   textWidgets(
                     title: "--",
                     color: AppColors.blackColor,
                     fontSize: isTablet(context) ? 15 : screenWidth * 0.031,
                     fontWeight: FontWeight.bold,
                     maxLines: 2,

                   ),
                 ],
               ),
             ],
           ),
         ],
       ),
     ),
      Expanded(
       child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               textWidgets(
                 title: leftTitle,
                 color: AppColors.black,
                 fontSize: isTablet(context) ? 15 :  screenWidth * 0.033,
                 fontWeight: FontWeight.w500,
                 overflow: TextOverflow.fade,
                 maxLines: 2,

               ),
               Column(
                 children: [
                   textWidgets(
                     title: "--",
                     color: AppColors.blackColor,
                     fontSize: isTablet(context) ? 15 : screenWidth * 0.031,
                     fontWeight: FontWeight.bold,
                     maxLines: 2,

                   ),
                   textWidgets(
                     title: "--",
                     color: AppColors.blackColor,
                     fontSize: isTablet(context) ? 15 : screenWidth * 0.031,
                     fontWeight: FontWeight.bold,
                     maxLines: 2,

                   ),
                 ],
               ),
             ],
           ),
         ],
       ),
     ),

    ],
  );
}

