import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/app_colors.dart';
import 'Utils/app_string.dart';
import 'Utils/common_widgets.dart';
import 'Utils/utils.dart';
import 'bottom_bar/restart_widget.dart';
import 'home_imports.dart';
import 'provider/category_provider.dart';
import 'search_screen.dart';
import 'widgets/profile_shimmer_widget.dart';
import 'widgets/text_form_field_widget.dart';
import 'widgets/text_widget.dart';

class MyEditProfile extends StatefulWidget {
  final String hughesNumber;
  const MyEditProfile({super.key, required this.hughesNumber});

  @override
  State<MyEditProfile> createState() => _MyEditProfileState();
}

class _MyEditProfileState extends State<MyEditProfile> {
  bool isTablet(BuildContext context) {
    final data = MediaQuery.of(context);
    return data.size.shortestSide >= 600;
  }

  bool isDetailsSubmit = false;
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  // TextEditingController productCategoryController = TextEditingController();
  TextEditingController productKeywordController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController hughesController = TextEditingController();
  TextEditingController hughes2Controller = TextEditingController();
  TextEditingController hughes3Controller = TextEditingController();
  TextEditingController hughes4Controller = TextEditingController();
  TextEditingController phoneNumber1Controller = TextEditingController();
  TextEditingController phoneNumber2Controller = TextEditingController();
  TextEditingController phoneNumber3Controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase();
  }

  late DatabaseReference databaseReference;
  List<Map<dynamic, dynamic>> data = [];
  bool isLoading = true;

  Future<void> _fetchDataFromFirebase() async {
    final categoryProviderViewModel =
        Provider.of<CategoryProviderViewModel>(context, listen: false);
    String hugeNumber = widget.hughesNumber;
    databaseReference = FirebaseDatabase.instance.ref().child("Users");
    final List<String> hughesNumberKeys = [
      "hughes1",
      "hughes2",
      "hughes3",
      "hughes4"
    ];
    List<Map<dynamic, dynamic>> tempData = [];
    for (String hughesNumberKey in hughesNumberKeys) {
      await databaseReference
          .orderByChild(hughesNumberKey)
          .equalTo(hugeNumber)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          final responseData = event.snapshot.value as Map<dynamic, dynamic>;
          responseData.forEach((key, value) {
            tempData.add({
              "categorySelected": value["categorySelected"],
              "companyName": value["companyName"],
              "companyDetails": value["companyDetails"],
              "phoneNumber": value["phoneNumber"],
              "phoneNumber1": value["phoneNumber1"],
              "phoneNumber2": value["phoneNumber2"],
              "productKeyword": value["productKeyword"],
              "hughes1": value["hughes1"],
              "hughes2": value["hughes2"],
              "hughes3": value["hughes3"],
              "hughes4": value["hughes4"],
              "name": value["name"],
              "name1": value["name1"],
              "name2": value["name2"],
              "url": value["url"],
            });
            setState(() {
              categoryProviderViewModel.setCategory(value["categorySelected"]);
            });
          });
        }
      }).catchError((error) {
        Utils.animatedErrorSnackBarMessage("Error: $error", context);
      });
    }
    if (tempData.isNotEmpty) {
      setState(() {
        data = tempData;
        isLoading = false;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", false);
      prefs.setString("number", "");
      prefs.clear();
      RestartAppWidget.restartApp(context);
      // IMP
      // if(context.mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavBarScreen()));
      if (context.mounted)
        Utils.animatedErrorSnackBarMessage(
            "The phone number ${widget.hughesNumber} does not exist or is invalid, please try to login again",
            context);
      setState(() {
        isLoading = false;
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  String? companyName;
  String? productKeyword;
  String? companyAddress;
  String? websiteUrl;
  String? phoneNumber;
  String? name;
  String? phoneNumber1;
  String? phoneNumber2;
  String? hughesNumber;
  String? hughes2;
  String? hughes3;
  String? hughes4;
  String? name1;
  String? name2;
  @override
  Widget build(BuildContext context) {
    final categoryProviderViewModel =
        context.watch<CategoryProviderViewModel>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlur3Color,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.whiteColor,
            )),
        title: Row(
          children: [
            const Text("Edit Profile",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w900,
                    color: AppColors.whiteColor)),
            Container(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  AppString.appTitleLogo,
                  width: 100,
                  color: AppColors.whiteColor,
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlur3Color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () async {
              var connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.none) {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          content: SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                Image.asset(
                                  AppString.noNetworkConnection1Img,
                                  width: 150,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Whoops!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "No internet connection found.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
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
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    child: const Text(
                                      "Try Again",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
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
                final form = formKey.currentState!;
                final isValid = form.validate();
                if (isValid) {
                  setState(() {
                    isDetailsSubmit = true;
                  });
                  final hughesNumberw = widget.hughesNumber;
                  final databaseReference =
                      FirebaseDatabase.instance.ref().child("Users");
                  final List<String> hughesNumberKeys = [
                    "hughes1",
                    "hughes2",
                    "hughes3",
                    "hughes4"
                  ];
                  bool foundMatch = false;
                  try {
                    for (String hughesNumberKey in hughesNumberKeys) {
                      final updateDetails = await databaseReference
                          .orderByChild(hughesNumberKey)
                          .equalTo(hughesNumberw)
                          .once();
                      if (updateDetails.snapshot.value != null) {
                        if (updateDetails.snapshot.value is Map) {
                          (updateDetails.snapshot.value as Map)
                              .forEach((key, value) {
                            final userKey = key;
                            databaseReference.child(userKey).update({
                              "companyName": companyNameController.text.isEmpty
                                  ? companyName
                                  : companyNameController.text,
                              "companyDetails":
                                  companyAddressController.text.isEmpty
                                      ? companyAddress
                                      : companyAddressController.text,
                              "categorySelected":
                                  categoryProviderViewModel.selectedCategory,
                              // "categorySelected": productCategoryController.text.isEmpty ? categorySelected : productCategoryController.text,
                              "productKeyword":
                                  productKeywordController.text.isEmpty
                                      ? productKeyword
                                      : productKeywordController.text,
                              "url": websiteUrlController.text.isEmpty
                                  ? websiteUrl
                                  : websiteUrlController.text,
                              "hughes1": hughesController.text.isEmpty
                                  ? hughesNumber
                                  : hughesController.text,
                              "hughes2": hughes2Controller.text.isEmpty
                                  ? hughes2
                                  : hughes2Controller.text,
                              "hughes3": hughes3Controller.text.isEmpty
                                  ? hughes3
                                  : hughes3Controller.text,
                              "hughes4": hughes4Controller.text.isEmpty
                                  ? hughes4
                                  : hughes4Controller.text,
                              "name": nameController.text.isEmpty
                                  ? name
                                  : nameController.text,
                              "name1": name1Controller.text.isEmpty
                                  ? name1
                                  : name1Controller.text,
                              "name2": name2Controller.text.isEmpty
                                  ? name2
                                  : name2Controller.text,
                              "phoneNumber": phoneNumber1Controller.text.isEmpty
                                  ? phoneNumber
                                  : phoneNumber1Controller.text,
                              "phoneNumber1":
                                  phoneNumber2Controller.text.isEmpty
                                      ? phoneNumber1
                                      : phoneNumber2Controller.text,
                              "phoneNumber2":
                                  phoneNumber3Controller.text.isEmpty
                                      ? phoneNumber2
                                      : phoneNumber3Controller.text,
                            });
                            foundMatch = true;
                          });
                          setState(() {
                            isDetailsSubmit = false;
                          });
                          String? companyNameValue =
                              companyNameController.text.isEmpty
                                  ? companyName
                                  : companyNameController.text;
                          String? companyDetailsValue =
                              companyAddressController.text.isEmpty
                                  ? companyAddress
                                  : companyAddressController.text;
                          String? categorySelectedValue =
                              categoryProviderViewModel.selectedCategory;
                          String? productKeywordValue =
                              productKeywordController.text.isEmpty
                                  ? productKeyword
                                  : productKeywordController.text;
                          String? urlValue = websiteUrlController.text.isEmpty
                              ? websiteUrl
                              : websiteUrlController.text;
                          String? hughes1Value = hughesController.text.isEmpty
                              ? hughesNumber
                              : hughesController.text;
                          String? hughes2Value = hughes2Controller.text.isEmpty
                              ? hughes2
                              : hughes2Controller.text;
                          String? hughes3Value = hughes3Controller.text.isEmpty
                              ? hughes3
                              : hughes3Controller.text;
                          String? hughes4Value = hughes4Controller.text.isEmpty
                              ? hughes4
                              : hughes4Controller.text;
                          String? nameValue = nameController.text.isEmpty
                              ? name
                              : nameController.text;
                          String? name1Value = name1Controller.text.isEmpty
                              ? name1
                              : name1Controller.text;
                          String? name2Value = name2Controller.text.isEmpty
                              ? name2
                              : name2Controller.text;
                          String? phoneNumberValue =
                              phoneNumber1Controller.text.isEmpty
                                  ? phoneNumber
                                  : phoneNumber1Controller.text;
                          String? phoneNumber1Value =
                              phoneNumber2Controller.text.isEmpty
                                  ? phoneNumber1
                                  : phoneNumber2Controller.text;
                          String? phoneNumber2Value =
                              phoneNumber3Controller.text.isEmpty
                                  ? phoneNumber2
                                  : phoneNumber3Controller.text;
                          List<Map<dynamic, dynamic>> yourData = [
                            {"companyName": companyNameValue!},
                            {"companyDetails": companyDetailsValue!},
                            {"categorySelected": categorySelectedValue},
                            {"productKeyword": productKeywordValue!},
                            {"url": urlValue!},
                            {"number": hughes1Value!},
                            {"hughes2": hughes2Value!},
                            {"hughes3": hughes3Value!},
                            {"hughes4": hughes4Value!},
                            {"name": nameValue!},
                            {"name1": name1Value!},
                            {"name2": name2Value!},
                            {"phoneNumber": phoneNumberValue!},
                            {"phoneNumber1": phoneNumber1Value!},
                            {"phoneNumber2": phoneNumber2Value!},
                          ];
                          await DialerClass()
                              .storeDataListInSharedPreferences(yourData);

                          Navigator.pop(context);
                          Utils.flushBarInfoMessage(
                              "Your details has been updated successfully 🙂",
                              context);
                          // Utils.flushBarInfoMessage("To View Updated Details Refresh The Page", context);
                        }
                      }
                      if (foundMatch) {
                        break;
                      }
                    }
                  } catch (error) {
                    setState(() {
                      isDetailsSubmit = false;
                    });
                    Utils.animatedErrorSnackBarMessage(
                        "Error: $error", context);
                  }
                } else {
                  Utils.animatedErrorSnackBarMessage(
                      "Enter a valid 4-digits number", context);
                }
              }
            },
            child: isDetailsSubmit
                ? const CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  )
                : const Text(
                    "Submit",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold),
                  )),
      ),
      body: isLoading
          ? ProfileShimmerWidget(widthRatio: screenWidth, heightRatio: 40)
          : Center(
              child: SizedBox(
                width: isTablet(context) ? screenWidth * 0.7 : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: screenWidth,
                                    height: screenHeight * 0.28,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryBlur3Color,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 40),
                                          child: const CircleAvatar(
                                            backgroundColor:
                                                AppColors.whiteColor,
                                            radius: 50,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  AppColors.primaryBlur1Color,
                                              radius: 46,
                                              backgroundImage:
                                                  AssetImage(AppString.userImg),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  final details = data[index];
                                  phoneNumber = details["phoneNumber"];
                                  phoneNumber1 = details["phoneNumber1"];
                                  phoneNumber2 = details["phoneNumber2"];
                                  companyName = details["companyName"];
                                  productKeyword = details["productKeyword"];
                                  companyAddress = details["companyDetails"];
                                  websiteUrl = details["url"];
                                  name = details["name"];
                                  hughesNumber = details["hughes1"];
                                  hughes2 = details["hughes2"];
                                  hughes3 = details["hughes3"];
                                  hughes4 = details["hughes4"];
                                  name1 = details["name1"];
                                  name2 = details["name2"];
                                  return Container(
                                    // color: AppColors.backgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Company Name",
                                                fontSize: isTablet(context)
                                                    ? 15
                                                    : screenWidth * 0.035,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormFieldWidget(
                                            initialValue: companyName,
                                            onChanged: (String value) {
                                              companyNameController.text =
                                                  value;
                                            },
                                            onTap: () {},
                                            readOnly: false,
                                            widthRatio: double.infinity,
                                            textEditingController: null,
                                            hintText: 'Enter Company Name',
                                            labelText: 'Enter Company Name',
                                            icon: null,
                                            inputFormatters: const [],
                                            keyboardType: TextInputType.text,
                                            validator: (String? value) {
                                              return null;
                                            },
                                            maxLength: null,
                                          ),
                                          categoryProviderViewModel
                                                      .selectedCategory ==
                                                  "Supplier"
                                              ? Container()
                                              : const SizedBox(
                                                  height: 15,
                                                ),
                                          categoryProviderViewModel
                                                      .selectedCategory ==
                                                  "Supplier"
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Product Category",
                                                      fontSize:
                                                          isTablet(context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          categoryProviderViewModel
                                                      .selectedCategory ==
                                                  "Supplier"
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SearchScreen(
                                                                    isShowProductCategory:
                                                                        true)));
                                                  },
                                                  child: Container(
                                                    width: screenWidth,
                                                    // height: 40,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: AppColors
                                                                    .greyColor))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        categoryProviderViewModel
                                                                .selectedCategory
                                                                .isEmpty
                                                            ? textWidget(
                                                                "Select Product Category",
                                                                isTablet(
                                                                        context)
                                                                    ? 15
                                                                    : screenWidth *
                                                                        0.035,
                                                                AppColors
                                                                    .greyColor
                                                                    .withValues(
                                                                        alpha:
                                                                            0.5),
                                                                FontWeight
                                                                    .normal)
                                                            : Container(),
                                                        categoryProviderViewModel
                                                                .selectedCategory
                                                                .isNotEmpty
                                                            ? textWidget(
                                                                categoryProviderViewModel
                                                                    .selectedCategory,
                                                                isTablet(
                                                                        context)
                                                                    ? 15
                                                                    : screenWidth *
                                                                        0.035,
                                                                null,
                                                                FontWeight
                                                                    .normal)
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Product Keywords",
                                                fontSize: isTablet(context)
                                                    ? 15
                                                    : screenWidth * 0.035,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormFieldWidget(
                                            initialValue: productKeyword,
                                            onChanged: (String value) {
                                              productKeywordController.text =
                                                  value;
                                            },
                                            onTap: () {},
                                            readOnly: false,
                                            widthRatio: double.infinity,
                                            textEditingController: null,
                                            hintText: 'Enter Product Keywords ',
                                            labelText:
                                                'Enter Product Keywords ',
                                            icon: null,
                                            inputFormatters: const [],
                                            keyboardType: TextInputType.text,
                                            validator: (String? value) {
                                              return null;
                                            },
                                            maxLength: null,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Company Address",
                                                fontSize: isTablet(context)
                                                    ? 15
                                                    : screenWidth * 0.035,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormFieldWidget(
                                            initialValue: companyAddress,
                                            onChanged: (String value) {
                                              companyAddressController.text =
                                                  value;
                                            },
                                            onTap: () {},
                                            readOnly: false,
                                            widthRatio: double.infinity,
                                            textEditingController: null,
                                            hintText: 'Enter Company Address',
                                            labelText: 'Enter Company Address',
                                            icon: null,
                                            inputFormatters: const [],
                                            keyboardType: TextInputType.text,
                                            validator: (String? value) {
                                              return null;
                                            },
                                            maxLength: null,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Website Details",
                                                fontSize: isTablet(context)
                                                    ? 15
                                                    : screenWidth * 0.035,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormFieldWidget(
                                            initialValue: websiteUrl,
                                            onChanged: (String value) {
                                              websiteUrlController.text = value;
                                            },
                                            onTap: () {},
                                            readOnly: false,
                                            widthRatio: double.infinity,
                                            textEditingController: null,
                                            hintText:
                                                'E.g https://www.google.com',
                                            labelText: 'Enter  Website url',
                                            icon: null,
                                            inputFormatters: const [],
                                            keyboardType: TextInputType.text,
                                            validator: (String? value) {
                                              return null;
                                            },
                                            maxLength: null,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Contact Details",
                                                fontSize: isTablet(context)
                                                    ? 15
                                                    : screenWidth * 0.04,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextWidget(
                                                          color: AppColors
                                                              .blackColor,
                                                          text: "Name 1",
                                                          fontSize: isTablet(
                                                                  context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      TextFormField(
                                                        initialValue: name,
                                                        onChanged:
                                                            (String value) {
                                                          nameController.text =
                                                              value;
                                                        },
                                                        maxLength: 10,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackColor,
                                                            fontSize: isTablet(
                                                                    context)
                                                                ? 15
                                                                : screenWidth *
                                                                    0.035),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          filled: true,
                                                          fillColor: AppColors
                                                              .whiteColor,
                                                          counterText: "",
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextWidget(
                                                        color: AppColors
                                                            .blackColor,
                                                        text: "Number 1",
                                                        fontSize:
                                                            isTablet(context)
                                                                ? 15
                                                                : screenWidth *
                                                                    0.035,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    TextFormField(
                                                      initialValue: phoneNumber,
                                                      onChanged:
                                                          (String value) {
                                                        phoneNumber1Controller
                                                            .text = value;
                                                      },
                                                      maxLength: 10,
                                                      cursorColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: isTablet(
                                                                  context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        filled: true,
                                                        fillColor: AppColors
                                                            .whiteColor,
                                                        counterText: "",
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextWidget(
                                                          color: AppColors
                                                              .blackColor,
                                                          text: "Name 2",
                                                          fontSize:
                                                              isTablet(context)
                                                                  ? 15
                                                                  : 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      TextFormField(
                                                        initialValue: name1,
                                                        onChanged:
                                                            (String value) {
                                                          name1Controller.text =
                                                              value;
                                                        },
                                                        maxLength: 10,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackColor,
                                                            fontSize: isTablet(
                                                                    context)
                                                                ? 15
                                                                : screenWidth *
                                                                    0.035),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          filled: true,
                                                          fillColor: AppColors
                                                              .whiteColor,
                                                          counterText: "",
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextWidget(
                                                        color: AppColors
                                                            .blackColor,
                                                        text: "Number 2",
                                                        fontSize:
                                                            isTablet(context)
                                                                ? 15
                                                                : 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    TextFormField(
                                                      initialValue:
                                                          phoneNumber1,
                                                      onChanged:
                                                          (String value) {
                                                        phoneNumber2Controller
                                                            .text = value;
                                                      },
                                                      maxLength: 10,
                                                      cursorColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: isTablet(
                                                                  context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        filled: true,
                                                        fillColor: AppColors
                                                            .whiteColor,
                                                        counterText: "",
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextWidget(
                                                          color: AppColors
                                                              .blackColor,
                                                          text: "Name 3",
                                                          fontSize:
                                                              isTablet(context)
                                                                  ? 15
                                                                  : 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      TextFormField(
                                                        initialValue: name2,
                                                        onChanged:
                                                            (String value) {
                                                          name2Controller.text =
                                                              value;
                                                        },
                                                        maxLength: 10,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackColor,
                                                            fontSize: isTablet(
                                                                    context)
                                                                ? 15
                                                                : screenWidth *
                                                                    0.035),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          filled: true,
                                                          fillColor: AppColors
                                                              .whiteColor,
                                                          counterText: "",
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextWidget(
                                                        color: AppColors
                                                            .blackColor,
                                                        text: "Number 3",
                                                        fontSize:
                                                            isTablet(context)
                                                                ? 15
                                                                : 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    TextFormField(
                                                      initialValue:
                                                          phoneNumber2,
                                                      onChanged:
                                                          (String value) {
                                                        phoneNumber3Controller
                                                            .text = value;
                                                      },
                                                      maxLength: 10,
                                                      cursorColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: isTablet(
                                                                  context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        filled: true,
                                                        fillColor: AppColors
                                                            .whiteColor,
                                                        counterText: "",
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "4 Digits Hughes Number",
                                                fontSize: isTablet(context)
                                                    ? 15
                                                    : screenWidth * 0.035,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Wrap(
                                            spacing: 5.0,
                                            runSpacing: 5.1,
                                            children: [
                                              SizedBox(
                                                width: isTablet(context)
                                                    ? screenWidth * 0.3
                                                    : 80,
                                                child: TextFormField(
                                                  initialValue: hughesNumber!
                                                          .startsWith("U_")
                                                      ? hughesNumber!
                                                          .substring(2)
                                                      : hughesNumber,
                                                  // readOnly: hughesNumber!.startsWith("U_") ? true : false,
                                                  onChanged: (String value) {
                                                    hughesController.text =
                                                        value;
                                                  },
                                                  maxLength: 4,
                                                  textAlign: TextAlign.center,
                                                  cursorColor: Theme.of(context)
                                                      .primaryColor,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize:
                                                          isTablet(context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    filled: true,
                                                    fillColor: AppColors
                                                        .whiteBlur1Color,
                                                    counterText: "",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: isTablet(context)
                                                    ? screenWidth * 0.3
                                                    : 80,
                                                child: TextFormField(
                                                  initialValue: hughes2!
                                                          .startsWith("U_")
                                                      ? hughes2!.substring(2)
                                                      : hughes2,
                                                  readOnly: true,
                                                  onChanged: (String value) {
                                                    hughes2Controller.text =
                                                        value;
                                                  },
                                                  maxLength: 4,
                                                  textAlign: TextAlign.center,
                                                  cursorColor: Theme.of(context)
                                                      .primaryColor,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize:
                                                          isTablet(context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .whiteBlur1Color,
                                                      counterText: ""),
                                                ),
                                              ),
                                              SizedBox(
                                                width: isTablet(context)
                                                    ? screenWidth * 0.3
                                                    : 80,
                                                child: TextFormField(
                                                  initialValue: hughes3!
                                                          .startsWith("U_")
                                                      ? hughes2!.substring(2)
                                                      : hughes3,
                                                  readOnly: true,
                                                  onChanged: (String value) {
                                                    hughes3Controller.text =
                                                        value;
                                                  },
                                                  maxLength: 4,
                                                  textAlign: TextAlign.center,
                                                  cursorColor: Theme.of(context)
                                                      .primaryColor,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize:
                                                          isTablet(context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .whiteBlur1Color,
                                                      counterText: ""),
                                                ),
                                              ),
                                              SizedBox(
                                                width: isTablet(context)
                                                    ? screenWidth * 0.3
                                                    : 80,
                                                child: TextFormField(
                                                  initialValue: hughes4!
                                                          .startsWith("U_")
                                                      ? hughes2!.substring(2)
                                                      : hughes4,
                                                  readOnly: true,
                                                  onChanged: (String value) {
                                                    hughes4Controller.text =
                                                        value;
                                                  },
                                                  maxLength: 4,
                                                  textAlign: TextAlign.center,
                                                  cursorColor: Theme.of(context)
                                                      .primaryColor,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize:
                                                          isTablet(context)
                                                              ? 15
                                                              : screenWidth *
                                                                  0.035),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .whiteBlur1Color,
                                                      counterText: ""),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
    );
  }
}
