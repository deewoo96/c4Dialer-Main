import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_string.dart';
import '../Utils/common_widgets.dart';
import '../Utils/utils.dart';
import '../home_imports.dart';
import '../provider/category_provider.dart';
import 'text_widget.dart';

class ProfileWidget extends StatefulWidget {
  final String appBarTitle,
      companyName,
      selectedCategory,
      companyAddress,
      productKeyword,
      websiteUrl,
      firstPhoneNumber,
      secondPhoneNumber,
      firstHughesNumber,
      secondHughesNumber,
      thirdHughesNumber,
      fourthHughesNumber,
      name1,
      name2,
      profileImageUrl;

  const ProfileWidget({
    super.key,
    required this.appBarTitle,
    required this.companyName,
    required this.selectedCategory,
    required this.companyAddress,
    required this.productKeyword,
    required this.websiteUrl,
    required this.firstPhoneNumber,
    required this.secondPhoneNumber,
    required this.firstHughesNumber,
    required this.secondHughesNumber,
    required this.thirdHughesNumber,
    required this.fourthHughesNumber,
    required this.name1,
    required this.name2,
    required this.profileImageUrl,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
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
  Future<void> makeCall(number) async {
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
      Utils.flushBarErrorMessage("Entered Wrong Hughes Number", context);
    }
    IosAndroidPlatformConfiguration()
        .initiatePhoneCall(numberToCall: numberToCall);

    // if(numberToCall.isNotEmpty) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   int? simNumber = prefs.getInt("secondSim");
    //   final DirectCaller directCaller = DirectCaller();
    //   directCaller.makePhoneCall(numberToCall, simSlot: simNumber!);
    // }
  }

  bool isLinkClicked = false;
  bool isFirstButtonClicked = false;
  bool isSecondButtonClicked = false;
  bool isThirdButtonClicked = false;
  bool isFourthButtonClicked = false;

  bool is1PhoneTextClicked = false;
  bool is1PhoneTapClicked = false;
  bool is1PhoneWhatsAppTapClicked = false;

  bool is2PhoneTextClicked = false;
  bool is2PhoneTapClicked = false;
  bool is2PhoneWhatsAppTapClicked = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteBlur1Color,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              color: AppColors.black,
            )),
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
          ],
        ),
      ),
      body: SizedBox(
        width: isTablet(context) ? screenWidth * 0.6 : null,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                      color: AppColors.blackColor,
                                      text: widget.companyName,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  TextWidget(
                                      color: AppColors.blueColor,
                                      text: widget.selectedCategory,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: AppColors.primaryBlur3Color,
                                radius: 23,
                                child: Container(
                                  child: widget.profileImageUrl.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            showImageViewer(
                                                context,
                                                Image.network(
                                                        widget.profileImageUrl)
                                                    .image,
                                                swipeDismissible: true,
                                                doubleTapZoomable: true);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                AppColors.blueColor,
                                            radius: 23,
                                            backgroundImage: NetworkImage(
                                                widget.profileImageUrl),
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 23,
                                          child: FaIcon(FontAwesomeIcons.user)
                                          // child: Image.asset(AppString.userImg)
                                          ),
                                ),
                              ),
                            ],
                          ),
                          widget.productKeyword.isEmpty ||
                                  widget.productKeyword == "null"
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextWidget(
                                        color: AppColors.blackColor,
                                        text: "Product Keywords",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    SizedBox(
                                      width: screenWidth * 0.8,
                                      child: ReadMoreText(
                                        widget.productKeyword,
                                        trimLines: 5,
                                        colorClickableText: Colors.blue,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '...Read More',
                                        trimExpandedText: ' less ',
                                        style: const TextStyle(
                                            color: AppColors.blackBlurColor,
                                            fontSize: 12,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                          widget.companyAddress.isEmpty
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextWidget(
                                        color: AppColors.blackColor,
                                        text: "Address",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    widget.companyAddress == "null"
                                        ? SizedBox(
                                            width: screenWidth * 0.8,
                                            child: const ReadMoreText(
                                              "No Address Provided",
                                              trimLines: 5,
                                              colorClickableText: Colors.blue,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: '...Read More',
                                              trimExpandedText: ' less ',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.blackBlurColor,
                                                  fontSize: 12,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Utils.openGoogleMap(
                                                  address:
                                                      widget.companyAddress,
                                                  context: context);
                                            },
                                            child: SizedBox(
                                              width: screenWidth * 0.8,
                                              child: GestureDetector(
                                                child: ReadMoreText(
                                                  widget.companyAddress,
                                                  trimLines: 5,
                                                  colorClickableText: Colors.blue,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText:
                                                      '...Read More',
                                                  trimExpandedText: ' less ',
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .blackBlurColor,
                                                      fontSize: 12,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                          widget.websiteUrl.isEmpty ||
                                  widget.websiteUrl == "null"
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextWidget(
                                        color: AppColors.blackColor,
                                        text: "Website",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    GestureDetector(
                                      onTap: () {
                                        Utils.launchUrlUtils(widget.websiteUrl);
                                        setState(() {
                                          isLinkClicked = true;
                                        });
                                      },
                                      child: Container(
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          color: isLinkClicked
                                              ? AppColors.greyBlur2Color
                                                  .withValues(alpha: 0.5)
                                              : AppColors.whiteColor,
                                        ),
                                        child: ReadMoreText(
                                          widget.websiteUrl,
                                          trimLines: 5,
                                          colorClickableText:
                                              AppColors.blueColor,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: '...Read More',
                                          trimExpandedText: ' less ',
                                          style: const TextStyle(
                                              color: AppColors.blueColor,
                                              fontSize: 12,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    widget.firstPhoneNumber.isEmpty
                        ? Container()
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                    color: AppColors.blackColor,
                                    text: "Contact Details",
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                const SizedBox(
                                  height: 10,
                                ),
                                widget.firstPhoneNumber.isEmpty
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                              color: AppColors.blackColor,
                                              text: widget.name1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        is1PhoneTextClicked =
                                                            true;
                                                      });
                                                      Utils.makingDirectPhoneCall(
                                                          widget
                                                              .firstPhoneNumber);
                                                    },
                                                    child: TextWidget(
                                                        color: is1PhoneTextClicked
                                                            ? AppColors
                                                                .blueColor
                                                            : AppColors
                                                                .blackColor,
                                                        text: widget
                                                            .firstPhoneNumber,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        is1PhoneTapClicked =
                                                            true;
                                                      });
                                                      Utils.makingDirectPhoneCall(
                                                          widget
                                                              .firstPhoneNumber);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .squarePhone,
                                                      color: is1PhoneTapClicked
                                                          ? AppColors.purpleDark
                                                          : AppColors
                                                              .blueColor,
                                                      size: 30,
                                                    )),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        is1PhoneWhatsAppTapClicked =
                                                            true;
                                                      });
                                                      Utils.openWhatsApp(
                                                          widget
                                                              .firstPhoneNumber,
                                                          "Hi ${widget.name1}",
                                                          context);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .squareWhatsapp,
                                                      size: 30,
                                                      color:
                                                          is1PhoneWhatsAppTapClicked
                                                              ? AppColors
                                                                  .purpleDark
                                                              : AppColors
                                                                  .greenColor,
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                widget.secondPhoneNumber.isEmpty
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                              color: AppColors.blackColor,
                                              text: widget.name2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        is2PhoneTextClicked =
                                                            true;
                                                      });
                                                      Utils.makingDirectPhoneCall(
                                                          widget
                                                              .secondPhoneNumber);
                                                    },
                                                    child: TextWidget(
                                                        color: is2PhoneTextClicked
                                                            ? AppColors
                                                                .blueColor
                                                            : AppColors
                                                                .blackColor,
                                                        text: widget
                                                            .secondPhoneNumber,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        is2PhoneTapClicked =
                                                            true;
                                                      });
                                                      Utils.makingDirectPhoneCall(
                                                          widget
                                                              .secondPhoneNumber);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .squarePhone,
                                                      color: is2PhoneTapClicked
                                                          ? AppColors.purpleDark
                                                          : AppColors
                                                              .blueColor,
                                                      size: 30,
                                                    )),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        is2PhoneWhatsAppTapClicked =
                                                            true;
                                                      });
                                                      Utils.openWhatsApp(
                                                          widget
                                                              .secondPhoneNumber,
                                                          "Hi ${widget.name2}",
                                                          context);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .squareWhatsapp,
                                                      size: 30,
                                                      color:
                                                          is2PhoneWhatsAppTapClicked
                                                              ? AppColors
                                                                  .purpleDark
                                                              : AppColors
                                                                  .greenColor,
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 5.1,
                      children: [
                        widget.firstHughesNumber.isEmpty
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  makeCall(DialerClass().makeCall(
                                      number: widget.firstHughesNumber
                                              .startsWith("U_")
                                          ? widget.firstHughesNumber
                                              .substring(2)
                                          : widget.firstHughesNumber,
                                      context: context));
                                  setState(() {
                                    isFirstButtonClicked = true;
                                  });
                                },
                                child: Container(
                                  width: 90,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      color: isFirstButtonClicked
                                          ? AppColors.greyBlur2Color
                                          : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: TextWidget(
                                          color: AppColors.blackColor,
                                          text: DialerClass().getHughesNumber(
                                              widget.firstHughesNumber),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                        widget.secondHughesNumber.isEmpty
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  makeCall(DialerClass().makeCall(
                                      number: widget.secondHughesNumber
                                              .startsWith("U_")
                                          ? widget.secondHughesNumber
                                              .substring(2)
                                          : widget.secondHughesNumber,
                                      context: context));
                                  setState(() {
                                    isSecondButtonClicked = true;
                                  });
                                },
                                child: Container(
                                  width: 90,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      color: isSecondButtonClicked
                                          ? AppColors.greyBlur2Color
                                          : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: TextWidget(
                                          color: AppColors.blackColor,
                                          text: widget.secondHughesNumber,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                        widget.thirdHughesNumber.isEmpty
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  makeCall(DialerClass().makeCall(
                                      number: widget.thirdHughesNumber
                                              .startsWith("U_")
                                          ? widget.thirdHughesNumber
                                              .substring(2)
                                          : widget.thirdHughesNumber,
                                      context: context));
                                  setState(() {
                                    isThirdButtonClicked = true;
                                  });
                                },
                                child: Container(
                                  width: 90,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      color: isThirdButtonClicked
                                          ? AppColors.greyBlur2Color
                                          : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: TextWidget(
                                          color: AppColors.blackColor,
                                          text: widget.thirdHughesNumber,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                        widget.fourthHughesNumber.isEmpty
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  makeCall(widget.fourthHughesNumber);
                                  setState(() {
                                    isFourthButtonClicked = true;
                                  });
                                },
                                child: Container(
                                  width: 90,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                      color: isFourthButtonClicked
                                          ? AppColors.greyBlur2Color
                                          : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: TextWidget(
                                          color: AppColors.blackColor,
                                          text: widget.fourthHughesNumber,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
