part of 'home_imports.dart';

class MyProfileScreen extends StatefulWidget {
  final String hughesNumber;
  const MyProfileScreen({super.key, required this.hughesNumber});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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

  late List<Map<dynamic, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBannerAd();
    fetchAdvertisementDataFromFirebase();
    // initCall();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCall();
    });
  }

  Future initCall() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.fetchAdvertisementDataFromFirebase();
  }

  Future fetchDataFromFirebase() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? huge = prefs.getString("U_0006");
      String? huge = prefs.getString("number");
      debugPrint("HUIIIII:$huge");
      final databaseReference = FirebaseDatabase.instance.ref().child("Users");
      DatabaseEvent databaseEvent = await databaseReference.once();
      if (databaseEvent.snapshot.value != null) {
        final responseData =
            databaseEvent.snapshot.value as Map<dynamic, dynamic>;
        List<Map<dynamic, dynamic>> tempData = [];
        responseData.forEach((key, value) {
          if (key == huge) {
            tempData.add({
              "categorySelected": value["categorySelected"],
              "companyName": value["companyName"],
              "companyDetails": value["companyDetails"],
              "phoneNumber": value["phoneNumber"],
              "phoneNumber1": value["phoneNumber1"],
              "phoneNumber2": value["phoneNumber2"],
              "productKeyword": value["productKeyword"],
              "number": value["hughes1"],
              "hughes2": value["hughes2"],
              "hughes3": value["hughes3"],
              "hughes4": value["hughes4"],
              "name": value["name"],
              "name1": value["name1"],
              "name2": value["name2"],
              "url": value["url"],
              "profileImageUrl": value["profileImageUrl"],
            });
            debugPrint("HHHHHH:$categorySelected");
          }
        });
        await DialerClass().storeDataListInSharedPreferences(tempData);
        setState(() {
          data = tempData;
          isLoading = false;
        });
      } else {
        Utils.animatedErrorSnackBarMessage("No details found", context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Utils.animatedErrorSnackBarMessage("Error: $e", context);
    }
  }

  // bool isRefreshing = false;
  String? companyName;
  String? productKeyword;
  String? companyAddress;
  String? websiteUrl;
  String? categorySelected;
  String? phoneNumber;
  String name = "";
  String? phoneNumber1;
  String? phoneNumber2;
  String? hughesNumber;
  String? hughes2;
  String? hughes3;
  String? hughes4;
  String? name1;
  String? name2;
  String profileImageUrl = "";

  String advertiseBannerUrl = "";
  bool isAdvertiseBannerVisible = true;
  BannerAd? banner;
  createBannerAd() {
    banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  Future fetchAdvertisementDataFromFirebase() async {
    late DatabaseReference notificationRef =
        FirebaseDatabase.instance.ref().child("advertiseSection");
    notificationRef.onValue.listen((event) async {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          advertiseBannerUrl = data['advertiseBannerUrl'];
          isAdvertiseBannerVisible = data['isAdvertiseBannerVisible'];
        });
      }
    });
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

  bool is3PhoneTextClicked = false;
  bool is3PhoneTapClicked = false;
  bool is3PhoneWhatsAppTapClicked = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            const Text("My Profile",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w900,
                    color: AppColors.blackColor)),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                AppString.appTitleLogo,
                width: 100,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                fetchDataFromFirebase();
              },
              icon: const Icon(Icons.refresh, color: AppColors.blackColor))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: isTablet(context) ? screenWidth * 0.7 : null,
          child: Column(
            children: [
              // isAdvertiseBannerVisible ?
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 5),
              //   child: CachedNetworkImage(
              //       imageUrl: advertiseBannerUrl,
              //       width: screenWidth,
              //       height: 52,
              //       fit: BoxFit.fill,
              //       placeholder: (context, url) => const ContainerShimmerWidget(height: 52,),
              //       errorWidget: (context, url, error) =>  const Text("")
              //   ),
              // ) : buildBannerWidget(banner),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<List<Map<dynamic, dynamic>>>(
                        future:
                            DialerClass().fetchDataListFromSharedPreferences(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<Map<dynamic, dynamic>> data = snapshot.data!;
                            if (data.isEmpty) {
                              fetchDataFromFirebase();
                            } else {
                              if (data.isNotEmpty) {
                                debugPrint("Data: $data");
                                var details = data[0];
                                profileImageUrl =
                                    details["profileImageUrl"] ?? "";
                                debugPrint("profileImageUrl: $profileImageUrl");
                              }
                              return Column(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    // height: screenHeight * 0.28,
                                    decoration: const BoxDecoration(
                                        // color: AppColors.blueColor,
                                        borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    )),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Container(
                                          // margin: const EdgeInsets.only(top: 20),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                AppColors.primaryBlur3Color,
                                            radius: 50,
                                            child: Container(
                                              child: profileImageUrl.isNotEmpty
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          AppColors.blueColor,
                                                      radius: 50,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              profileImageUrl),
                                                    )
                                                  : const CircleAvatar(
                                                      radius: 50,
                                                      child: FaIcon(
                                                        FontAwesomeIcons.user,
                                                        size: 30,
                                                      )
                                                      // child: Image.asset(AppString.userImg)
                                                      ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   margin: const EdgeInsets.only(top: 5),
                                        //   child: TextWidget(
                                        //     color: AppColors.whiteColor, text: name, fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      var details = data[index];
                                      categorySelected =
                                          details["categorySelected"] ?? "";
                                      phoneNumber =
                                          details["phoneNumber"] ?? "";
                                      phoneNumber1 =
                                          details["phoneNumber1"] ?? "";
                                      phoneNumber2 =
                                          details["phoneNumber2"] ?? "";
                                      companyName =
                                          details["companyName"] ?? "";
                                      productKeyword =
                                          details["productKeyword"] ?? "";
                                      companyAddress =
                                          details["companyDetails"] ?? "";
                                      websiteUrl = details["url"] ?? "";
                                      name = details["name"] ?? "";
                                      hughesNumber = details["number"] ?? "";
                                      hughes2 = details["hughes2"] ?? "";
                                      hughes3 = details["hughes3"] ?? "";
                                      hughes4 = details["hughes4"] ?? "";
                                      name1 = details["name1"] ?? "";
                                      name2 = details["name2"] ?? "";

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                                // color: AppColors.backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          companyName!.isEmpty
                                                              ? Container()
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .whiteColor,
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .buildingCircleArrowRight,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              AppColors.primaryBlur3Color,
                                                                        )),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextWidget(
                                                                            color: AppColors
                                                                                .blackBlurColor,
                                                                            text:
                                                                                "$companyName",
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        const SizedBox(
                                                                            height:
                                                                                3),
                                                                        TextWidget(
                                                                            color: AppColors
                                                                                .blackColor,
                                                                            text:
                                                                                "$categorySelected",
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                          companyName!.isEmpty
                                                              ? Container()
                                                              : const Divider(
                                                                  color: AppColors
                                                                      .hintLabel3TextColor),
                                                          productKeyword!
                                                                  .isEmpty
                                                              ? Container()
                                                              : const SizedBox(
                                                                  height: 5),
                                                          productKeyword!
                                                                  .isEmpty
                                                              ? Container()
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .whiteColor,
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .globe,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              AppColors.primaryBlur3Color,
                                                                        )),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    productKeyword ==
                                                                            ""
                                                                        ? Container()
                                                                        : Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              TextWidget(color: AppColors.blackBlurColor, text: "Product Keywords", fontSize: 13, fontWeight: FontWeight.w500),
                                                                              const SizedBox(
                                                                                height: 3,
                                                                              ),
                                                                              SizedBox(
                                                                                width: isTablet(context) ? screenWidth * 0.5 : screenWidth * 0.75,
                                                                                child: ReadMoreText(
                                                                                  "$productKeyword",
                                                                                  trimLines: 5,
                                                                                  colorClickableText: Colors.blue,
                                                                                  trimMode: TrimMode.Line,
                                                                                  trimCollapsedText: '...Read More',
                                                                                  trimExpandedText: ' less ',
                                                                                  style: const TextStyle(
                                                                                    color: AppColors.blackColor,
                                                                                    fontSize: 12,
                                                                                    fontFamily: "Poppins",
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                  ],
                                                                ),
                                                          productKeyword!
                                                                      .isEmpty ||
                                                                  companyAddress!
                                                                      .isEmpty
                                                              ? Container()
                                                              : const Divider(
                                                                  color: AppColors
                                                                      .hintLabel3TextColor),
                                                          productKeyword!
                                                                      .isEmpty ||
                                                                  companyAddress!
                                                                      .isEmpty
                                                              ? const SizedBox(
                                                                  height: 5)
                                                              : Container(),
                                                          companyAddress!
                                                                  .isEmpty
                                                              ? Container()
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .whiteColor,
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .locationDot,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              AppColors.primaryBlur3Color,
                                                                        )),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextWidget(
                                                                            color: AppColors
                                                                                .blackBlurColor,
                                                                            text:
                                                                                "Address",
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        const SizedBox(
                                                                          height:
                                                                              3,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Utils.openGoogleMap(
                                                                                address: companyAddress!,
                                                                                context: context);
                                                                          },
                                                                          child:
                                                                              SizedBox(
                                                                            width: isTablet(context)
                                                                                ? screenWidth * 0.5
                                                                                : screenWidth * 0.75,
                                                                            child:
                                                                                ReadMoreText(
                                                                              "$companyAddress",
                                                                              trimLines: 5,
                                                                              colorClickableText: Colors.blue,
                                                                              trimMode: TrimMode.Line,
                                                                              trimCollapsedText: '...Read More',
                                                                              trimExpandedText: ' less ',
                                                                              style: const TextStyle(color: AppColors.blackColor, fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                          websiteUrl!.isEmpty ||
                                                                  companyAddress!
                                                                      .isEmpty
                                                              ? Container()
                                                              : const Divider(
                                                                  color: AppColors
                                                                      .hintLabel3TextColor),
                                                          const SizedBox(
                                                              height: 5),
                                                          websiteUrl!.isEmpty
                                                              ? Container()
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    Utils.launchUrlUtils(
                                                                        websiteUrl!);
                                                                    setState(
                                                                        () {
                                                                      isLinkClicked =
                                                                          true;
                                                                    });
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const CircleAvatar(
                                                                          radius:
                                                                              20,
                                                                          backgroundColor: AppColors
                                                                              .whiteColor,
                                                                          child:
                                                                              Icon(
                                                                            Icons.web,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                AppColors.primaryBlur3Color,
                                                                          )),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          TextWidget(
                                                                              color: AppColors.blackBlurColor,
                                                                              text: "Website",
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500),
                                                                          const SizedBox(
                                                                            height:
                                                                                3,
                                                                          ),
                                                                          Container(
                                                                            width: isTablet(context)
                                                                                ? screenWidth * 0.5
                                                                                : screenWidth * 0.75,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: isLinkClicked ? AppColors.greyBlur2Color.withValues(alpha: 0.5) : AppColors.whiteColor,
                                                                            ),
                                                                            child:
                                                                                ReadMoreText(
                                                                              "$websiteUrl",
                                                                              trimLines: 5,
                                                                              colorClickableText: AppColors.blueColor,
                                                                              trimMode: TrimMode.Line,
                                                                              trimCollapsedText: '...Read More',
                                                                              trimExpandedText: ' less ',
                                                                              style: const TextStyle(color: AppColors.blueColor, fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                          websiteUrl!.isEmpty
                                                              ? Container()
                                                              : const Divider(
                                                                  color: AppColors
                                                                      .hintLabel3TextColor),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                phoneNumber!.isEmpty ||
                                                        phoneNumber1!.isEmpty ||
                                                        phoneNumber2!.isEmpty
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          TextWidget(
                                                              color: AppColors
                                                                  .blackColor,
                                                              text:
                                                                  "Contact Details",
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.038,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          const SizedBox(
                                                              height: 4),
                                                        ],
                                                      ),
                                                phoneNumber!.isEmpty &&
                                                        name.isEmpty
                                                    ? Container()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .whiteColor,
                                                              child: Icon(
                                                                Icons
                                                                    .phone_iphone_outlined,
                                                                size: 18,
                                                                color: AppColors
                                                                    .primaryBlur3Color,
                                                              )),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                is1PhoneTextClicked =
                                                                    true;
                                                              });
                                                              Utils.makingDirectPhoneCall(
                                                                  phoneNumber!);
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextWidget(
                                                                    color: AppColors
                                                                        .blackBlurColor,
                                                                    text: name,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                TextWidget(
                                                                    color: is1PhoneTextClicked
                                                                        ? AppColors
                                                                            .blueColor
                                                                        : AppColors
                                                                            .blackColor,
                                                                    text:
                                                                        "$phoneNumber",
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      if (phoneNumber!
                                                                          .isEmpty) {
                                                                        if (context
                                                                            .mounted)
                                                                          Utils.animatedErrorSnackBarMessage(
                                                                              "Invalid Phone Number",
                                                                              context);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          is1PhoneTapClicked =
                                                                              true;
                                                                        });
                                                                        Utils.makingDirectPhoneCall(
                                                                            "$phoneNumber");
                                                                      }
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .squarePhone,
                                                                      color: is1PhoneTapClicked
                                                                          ? AppColors
                                                                              .purpleDark
                                                                          : AppColors
                                                                              .blueColor,
                                                                      size: 30,
                                                                    )),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                InkWell(
                                                                    onTap: () {
                                                                      if (phoneNumber!
                                                                          .isEmpty) {
                                                                        if (context
                                                                            .mounted)
                                                                          Utils.animatedErrorSnackBarMessage(
                                                                              "Invalid Phone Number",
                                                                              context);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          is1PhoneWhatsAppTapClicked =
                                                                              true;
                                                                        });
                                                                        Utils.openWhatsApp(
                                                                            "$phoneNumber",
                                                                            "Hi $name",
                                                                            context);
                                                                      }
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .squareWhatsapp,
                                                                      size: 30,
                                                                      color: is1PhoneWhatsAppTapClicked
                                                                          ? AppColors
                                                                              .purpleDark
                                                                          : AppColors
                                                                              .greenColor,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                phoneNumber1!.isEmpty &&
                                                        name1!.isEmpty
                                                    ? Container()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .whiteColor,
                                                              child: Icon(
                                                                Icons
                                                                    .phone_iphone_outlined,
                                                                size: 18,
                                                                color: AppColors
                                                                    .primaryBlur3Color,
                                                              )),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                is2PhoneTextClicked =
                                                                    true;
                                                              });
                                                              Utils.makingDirectPhoneCall(
                                                                  phoneNumber1!);
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextWidget(
                                                                    color: AppColors
                                                                        .blackBlurColor,
                                                                    text:
                                                                        "$name1",
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                TextWidget(
                                                                    color: is2PhoneTextClicked
                                                                        ? AppColors
                                                                            .blueColor
                                                                        : AppColors
                                                                            .blackColor,
                                                                    text:
                                                                        "$phoneNumber1",
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      if (phoneNumber1!
                                                                          .isEmpty) {
                                                                        if (context
                                                                            .mounted)
                                                                          Utils.animatedErrorSnackBarMessage(
                                                                              "Invalid Phone Number",
                                                                              context);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          is2PhoneTapClicked =
                                                                              true;
                                                                        });
                                                                        Utils.makingDirectPhoneCall(
                                                                            "$phoneNumber1");
                                                                      }
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .squarePhone,
                                                                      color: is2PhoneTapClicked
                                                                          ? AppColors
                                                                              .purpleDark
                                                                          : AppColors
                                                                              .blueColor,
                                                                      size: 30,
                                                                    )),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                InkWell(
                                                                    onTap: () {
                                                                      if (phoneNumber1!
                                                                          .isEmpty) {
                                                                        if (context
                                                                            .mounted)
                                                                          Utils.animatedErrorSnackBarMessage(
                                                                              "Invalid Phone Number",
                                                                              context);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          is2PhoneWhatsAppTapClicked =
                                                                              true;
                                                                        });
                                                                        Utils.openWhatsApp(
                                                                            "$phoneNumber1",
                                                                            "Hi $name1",
                                                                            context);
                                                                      }
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .squareWhatsapp,
                                                                      size: 30,
                                                                      color: is2PhoneWhatsAppTapClicked
                                                                          ? AppColors
                                                                              .purpleDark
                                                                          : AppColors
                                                                              .greenColor,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                phoneNumber2!.isEmpty &&
                                                        name2!.isEmpty
                                                    ? Container()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .whiteColor,
                                                              child: Icon(
                                                                Icons
                                                                    .phone_iphone_outlined,
                                                                size: 18,
                                                                color: AppColors
                                                                    .primaryBlur3Color,
                                                              )),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                is3PhoneTextClicked =
                                                                    true;
                                                              });
                                                              Utils.makingDirectPhoneCall(
                                                                  phoneNumber2!);
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextWidget(
                                                                    color: AppColors
                                                                        .blackBlurColor,
                                                                    text:
                                                                        "$name2",
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                TextWidget(
                                                                    color: is3PhoneTextClicked
                                                                        ? AppColors
                                                                            .blueColor
                                                                        : AppColors
                                                                            .blackColor,
                                                                    text:
                                                                        "$phoneNumber2",
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      if (phoneNumber2!
                                                                          .isEmpty) {
                                                                        if (context
                                                                            .mounted)
                                                                          Utils.animatedErrorSnackBarMessage(
                                                                              "Invalid Phone Number",
                                                                              context);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          is3PhoneTapClicked =
                                                                              true;
                                                                        });
                                                                        Utils.makingDirectPhoneCall(
                                                                            "$phoneNumber2");
                                                                      }
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .squarePhone,
                                                                      color: is3PhoneTapClicked
                                                                          ? AppColors
                                                                              .purpleDark
                                                                          : AppColors
                                                                              .blueColor,
                                                                      size: 30,
                                                                    )),
                                                                const SizedBox(
                                                                    width: 15),
                                                                InkWell(
                                                                    onTap: () {
                                                                      if (phoneNumber2!
                                                                          .isEmpty) {
                                                                        if (context
                                                                            .mounted)
                                                                          Utils.animatedErrorSnackBarMessage(
                                                                              "Invalid Phone Number",
                                                                              context);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          is3PhoneWhatsAppTapClicked =
                                                                              true;
                                                                        });
                                                                        Utils.openWhatsApp(
                                                                            "$phoneNumber2",
                                                                            "Hi $name2",
                                                                            context);
                                                                      }
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .squareWhatsapp,
                                                                      size: 30,
                                                                      color: is3PhoneWhatsAppTapClicked
                                                                          ? AppColors
                                                                              .purpleDark
                                                                          : AppColors
                                                                              .greenColor,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 15),
                                                  TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Hughes Number",
                                                      fontSize:
                                                          isTablet(context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.038,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Wrap(
                                                    spacing: 5.0,
                                                    runSpacing: 5.1,
                                                    children: [
                                                      hughesNumber == ""
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                makeCall(DialerClass().makeCall(
                                                                    number: hughesNumber!.startsWith(
                                                                            "U_")
                                                                        ? hughesNumber!
                                                                            .substring(
                                                                                2)
                                                                        : hughesNumber!,
                                                                    context:
                                                                        context));
                                                                setState(() {
                                                                  isFirstButtonClicked =
                                                                      true;
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 80,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            7),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    color: isFirstButtonClicked
                                                                        ? AppColors.blueColor.withValues(
                                                                            alpha:
                                                                                0.1)
                                                                        : AppColors
                                                                            .greyBlur2Color
                                                                            .withValues(alpha: 0.5)),
                                                                child: Center(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .phone,
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      size: 13,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    TextWidget(
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      text: DialerClass()
                                                                          .getHughesNumber(
                                                                              hughesNumber!),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ],
                                                                )),
                                                              ),
                                                            ),
                                                      hughes2 == ""
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                makeCall(DialerClass().makeCall(
                                                                    number: hughes2!.startsWith(
                                                                            "U_")
                                                                        ? hughes2!
                                                                            .substring(
                                                                                2)
                                                                        : hughes2!,
                                                                    context:
                                                                        context));
                                                                setState(() {
                                                                  isSecondButtonClicked =
                                                                      true;
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 80,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            7),
                                                                decoration: BoxDecoration(
                                                                    color: isSecondButtonClicked
                                                                        ? AppColors.blueColor.withValues(
                                                                            alpha:
                                                                                0.1)
                                                                        : AppColors.greyBlur2Color.withValues(
                                                                            alpha:
                                                                                0.5),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: Center(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .phone,
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      size: 13,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    TextWidget(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        text: DialerClass().getHughesNumber(
                                                                            hughes2!),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600)
                                                                  ],
                                                                )),
                                                              ),
                                                            ),
                                                      hughes3 == ""
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                makeCall(DialerClass().makeCall(
                                                                    number: hughes3!.startsWith(
                                                                            "U_")
                                                                        ? hughes3!
                                                                            .substring(
                                                                                2)
                                                                        : hughes3!,
                                                                    context:
                                                                        context));
                                                                setState(() {
                                                                  isThirdButtonClicked =
                                                                      true;
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 80,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            7),
                                                                decoration: BoxDecoration(
                                                                    color: isThirdButtonClicked
                                                                        ? AppColors.blueColor.withValues(
                                                                            alpha:
                                                                                0.1)
                                                                        : AppColors.greyBlur2Color.withValues(
                                                                            alpha:
                                                                                0.5),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: Center(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .phone,
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      size: 13,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    TextWidget(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        text: DialerClass().getHughesNumber(
                                                                            hughes3!),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600)
                                                                  ],
                                                                )),
                                                              ),
                                                            ),
                                                      hughes4 == ""
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                makeCall(DialerClass().makeCall(
                                                                    number: hughes4!.startsWith(
                                                                            "U_")
                                                                        ? hughes4!
                                                                            .substring(
                                                                                2)
                                                                        : hughes4!,
                                                                    context:
                                                                        context));
                                                                setState(() {
                                                                  isFourthButtonClicked =
                                                                      true;
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 80,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            7),
                                                                decoration: BoxDecoration(
                                                                    color: isFourthButtonClicked
                                                                        ? AppColors.blueColor.withValues(
                                                                            alpha:
                                                                                0.1)
                                                                        : AppColors.greyBlur2Color.withValues(
                                                                            alpha:
                                                                                0.5),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: Center(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .phone,
                                                                      color: AppColors
                                                                          .blackColor,
                                                                      size: 13,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    TextWidget(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        text: DialerClass().getHughesNumber(
                                                                            hughes4!),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600)
                                                                  ],
                                                                )),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return const Text(
                              "",
                              style: TextStyle(color: Colors.blue),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : authProvider.isEditProfileButtonVisible
                      ? Container(
                          width: double.infinity,
                          height: 45,
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.1,
                              right: 10,
                              left: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlur3Color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: () async {
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            content: SizedBox(
                                              height: 300,
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    AppString
                                                        .noNetworkConnection1Img,
                                                    width: 150,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    "Whoops!",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    "No internet connection found.",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const Text(
                                                    "Check your connection and try again.",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 45,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .primaryColor,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50))),
                                                      child: const Text(
                                                        "Try Again",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyEditProfile(
                                                hughesNumber:
                                                    widget.hughesNumber,
                                              ))).then((value) {
                                    fetchDataFromFirebase();
                                  });
                                }
                              },
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold),
                              )),
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
