import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/app_colors.dart';
import 'Utils/app_string.dart';
import 'Utils/common_widgets.dart';
import 'Utils/utils.dart';
import 'provider/category_provider.dart';
import 'search_details/search_imports.dart';
import 'widgets/profile_widget.dart';
import 'widgets/text_widget.dart';
import 'widgets/category_whatsapp_button.dart';

class SearchScreen extends StatefulWidget {
  final bool isShowProductCategory;

  const SearchScreen({super.key, required this.isShowProductCategory});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isCardVisible = false;
  bool isCardVisible1 = false;
  bool is2CardVisible = false;
  bool is3CardVisible = false;
  bool is4CardVisible = false;
  bool is5CardVisible = false;
  bool is6CardVisible = false;
  bool is7CardVisible = false;
  bool isSecondCardVisible = false;
  bool isThirdCardVisible = false;
  bool isFourthCardVisible = false;
  bool isFifthCardVisible = false;
  bool isSixCardVisible = false;
  bool isSevenCardVisible = false;

  bool isLoading = false;
  StreamSubscription<DatabaseEvent>? _usersSubscription;
  TextEditingController searchController = TextEditingController();
  List<Map<dynamic, dynamic>> data = [];
  List<String> temporaryCompanyNames = [];

  final ScrollController _scrollController = ScrollController();
  final SuggestionsController<String> _suggestionsController =
      SuggestionsController();

  @override
  void dispose() {
    unawaited(_usersSubscription?.cancel());
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkDataExist();
  }

  Future checkDataExist() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('selectedProductCategory');
    if (!mounted) return;
    if (storedData != null) {
      setState(() {
        data = List<Map<dynamic, dynamic>>.from(json.decode(storedData));
        temporaryCompanyNames = data
            .where((entry) =>
                entry["companyName"] != null &&
                entry["companyName"].toString().isNotEmpty)
            .map<String>((entry) => entry["companyName"].toString())
            .toList();
      });
    }
    await fetchDataFromFirebase();
  }

  Future fetchDataFromFirebase() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    await _usersSubscription?.cancel();
    if (!mounted) return;
    final usersRef = FirebaseDatabase.instance.ref().child("Users");
    _usersSubscription = usersRef.onValue.listen((event) async {
      try {
        final value = event.snapshot.value;
        final tempData = <Map<dynamic, dynamic>>[];
        if (value is Map) {
          for (final user in value.values) {
            if (user is! Map) continue;
            tempData.add({
              "categorySelected": user["categorySelected"],
              "companyName": user["companyName"],
              "companyDetails": user["companyDetails"],
              "phoneNumber": user["phoneNumber"],
              "phoneNumber1": user["phoneNumber1"],
              "phoneNumber2": user["phoneNumber2"],
              "productKeyword": user["productKeyword"],
              "hughesNumber": user["hughes1"],
              "hughes2": user["hughes2"],
              "hughes3": user["hughes3"],
              "hughes4": user["hughes4"],
              "name": user["name"],
              "name1": user["name1"],
              "url": user["url"],
              "profileImageUrl": user["profileImageUrl"],
            });
          }
        }

        await _storeDataInSharedPreferences(tempData);
        if (!mounted) return;
        setState(() {
          data = tempData;
          temporaryCompanyNames = data
              .where((entry) =>
                  entry["companyName"] != null &&
                  entry["companyName"].toString().isNotEmpty)
              .map<String>((entry) => entry["companyName"].toString())
              .toList();
          isLoading = false;
        });
      } catch (error) {
        debugPrint("Error updating company search data: $error");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Utils.flushBarInfoMessage(
              "Unable to refresh company data: $error", context);
        }
      }
    }, onError: (Object error) {
      debugPrint("Error loading company search data: $error");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        Utils.flushBarInfoMessage(
            "Unable to refresh company data: $error", context);
      }
    });
  }

  // ---------------------------- Load Data From Database Section End------------------------------------
  Future _storeDataInSharedPreferences(List<Map<dynamic, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = json.encode(data);
    await prefs.setString('selectedProductCategory', dataJson);
  }

  Future<List<Map<dynamic, dynamic>>> fetchDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDataJson = prefs.getString('selectedProductCategory');
    if (storedDataJson != null) {
      return List<Map<dynamic, dynamic>>.from(json.decode(storedDataJson));
    } else {
      return [];
    }
  }

  Future navigateToProfileWidget(String companyName) async {
    final item = data.firstWhere(
      (entry) => entry["companyName"] == companyName,
    );

    _openProfile(item);
  }

  void _openProfile(Map<dynamic, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileWidget(
          appBarTitle: item["companyName"] ?? "",
          companyAddress: item["companyDetails"] ?? "",
          companyName: item["companyName"] ?? "",
          firstPhoneNumber: item["phoneNumber"] ?? "",
          secondPhoneNumber: item["phoneNumber1"] ?? "",
          selectedCategory: item["categorySelected"] ?? "",
          websiteUrl: item["url"] ?? "",
          firstHughesNumber: item["hughesNumber"] ?? "",
          secondHughesNumber: item["hughes2"] ?? "",
          thirdHughesNumber: item["hughes3"] ?? "",
          fourthHughesNumber: item["hughes4"] ?? "",
          productKeyword: item["productKeyword"] ?? "",
          name1: item["name"] ?? "",
          name2: item["name1"] ?? "",
          profileImageUrl: item["profileImageUrl"] ?? "",
          // Add other fields as needed
        ),
      ),
    );
  }

  Future<List<String>> fetchCompanySuggestions(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    return temporaryCompanyNames
        .where(
            (company) => company.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  bool isSearch = false;

  Widget _categoryTile({
    required String title,
    required String categoryName,
  }) {
    return _categoryAction(
      categoryName: categoryName,
      child: listTileContainer(title: title),
    );
  }

  Widget _categoryAction({
    required String categoryName,
    required Widget child,
  }) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(child: child),
          if (!widget.isShowProductCategory)
            CategoryWhatsappButton(
              categoryName: categoryName,
              showButton: true,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        searchController.clear();
        _suggestionsController.close();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteBlur1Color,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: Row(
            children: [
              isSearch
                  ? Container()
                  : const Text("C4Dialer",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w900,
                          color: AppColors.blackColor)),
              isSearch
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(AppString.appTitleLogo, width: 100)),
              isSearch
                  ? SizedBox(
                      width: screenWidth * 0.9,
                      child: TypeAheadField<String>(
                        suggestionsCallback: (pattern) async =>
                            await fetchCompanySuggestions(pattern),
                        itemBuilder: (context, companyName) {
                          var entry = data.firstWhere(
                              (entry) => entry["companyName"] == companyName);
                          var hughesNumber = entry["hughesNumber"];
                          String number = hughesNumber!.startsWith("U_")
                              ? hughesNumber!.substring(2)
                              : hughesNumber ?? "";
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.4)))),
                            child: ListTile(
                              onTap: () async {
                                await navigateToProfileWidget(companyName);
                              },
                              title: textWidget(
                                  companyName,
                                  screenWidth * 0.035,
                                  AppColors.blackColor,
                                  FontWeight.normal),
                              trailing: GestureDetector(
                                  onTap: () {
                                    phoneNumberToCall(number: number);
                                  },
                                  child: textWidget(number, screenWidth * 0.035,
                                      AppColors.blackColor, FontWeight.normal)),
                            ),
                          );
                        },
                        onSelected: (suggestion) async {
                          if (suggestion.isNotEmpty) {
                            searchController.text =
                                suggestion; // Directly update the controller without setState
                          }
                        },
                        scrollController: _scrollController,
                        hideKeyboardOnDrag: false,
                        hideOnUnfocus: false,
                        hideWithKeyboard: false,
                        autoFlipDirection: false,
                        suggestionsController: _suggestionsController,
                        builder: (context, controller, focusNode) {
                          searchController = controller;
                          return TextFormField(
                            showCursor: true,
                            autofocus: true,
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(fontSize: screenWidth * 0.035),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              hintText:
                                  "Enter 1 Character & wait for suggestions",
                              labelStyle:
                                  TextStyle(fontSize: screenWidth * 0.035),
                              hintStyle:
                                  TextStyle(fontSize: screenWidth * 0.035),
                              contentPadding: const EdgeInsets.only(
                                  right: 0, left: 10, top: 15, bottom: 8),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.clear();

                                    setState(() {
                                      isSearch = false;
                                    });
                                  },
                                  icon: Icon(Icons.cancel,
                                      color: AppColors.greyColor
                                          .withValues(alpha: 0.4))),
                            ),
                          );
                        },
                        loadingBuilder: (context) => Center(
                            child: textWidget("loading", screenWidth * 0.035,
                                AppColors.blackColor, FontWeight.normal)),
                        errorBuilder: (context, error) => Center(
                            child: textWidget(
                                "Error: $error",
                                screenWidth * 0.035,
                                AppColors.redColor,
                                FontWeight.normal)),
                        decorationBuilder: (context, child) {
                          if (searchController.text.isEmpty) {
                            return Container();
                          } else {
                            return Material(
                              type: MaterialType.card,
                              elevation: 4,
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: child,
                            );
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
          actions: [
            widget.isShowProductCategory
                ? Container()
                : !isSearch
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isSearch = !isSearch;
                          });
                        },
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: AppColors.greyBlur2Color))
                            : const FaIcon(
                                FontAwesomeIcons.search,
                                color: AppColors.blackColor,
                                size: 18,
                              ))
                    : Container()
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(
              const Duration(seconds: 2),
              () async {
                await fetchDataFromFirebase();
                if (context.mounted) {
                  Utils.flushBarInfoMessage(
                      "Details Has Been Updated Successfully", context);
                }
              },
            );
          },
          child: Center(
            child: SizedBox(
              width: isTablet(context) ? screenWidth * 0.6 : null,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      // SizedBox(height: screenWidth * 0.05),
                      // widget.isShowProductCategory ? Container():
                      // isLoading ? const ContainerShimmerWidget(height: 50) : Container(),
                      // const SizedBox(height: 10,),
                      SizedBox(height: screenWidth * 0.015),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isCardVisible = !isCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenWidth * 0.05,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "STAINLESS STEEL",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                //   color: AppColors.blueColor,
                                color: AppColors.whiteBlur3Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isCardVisible,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(
                                        color: AppColors.whiteBlur3Color),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isCardVisible1 = !isCardVisible1;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.015),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            isCardVisible1
                                                ? Transform.rotate(
                                                    angle: 90 *
                                                        (3.1415926535 / 180),
                                                    child: const Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 15),
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 15,
                                                  ),
                                            const SizedBox(width: 8),
                                            TextWidget(
                                              color: AppColors.blackColor,
                                              text: "SHEET-PLATES-COILS",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isCardVisible1,
                                      child: Container(
                                        color: AppColors.greyBlur3Color,
                                        // color:AppColors.greyBlur3Color,
                                        child: Column(
                                          children: [
                                            Container(
                                                color:
                                                    AppColors.whiteBlur3Color,
                                                child: const Divider(
                                                    color: AppColors
                                                        .hintLabel3TextColor)),
                                            Container(
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .greyBlur3Color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: InkWell(
                                                    onTap: () {
                                                      widget.isShowProductCategory
                                                          ? context
                                                              .read<
                                                                  CategoryProviderViewModel>()
                                                              .setSelectedCategory(
                                                                  "S.S.SHEET-PLATES-COILS 304Q316Q",
                                                                  context)
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SSSheetPlatesCoilsScreen1()));
                                                    },
                                                    child: _categoryTile(
                                                        title: "304Q316Q",
                                                        categoryName:
                                                            "S.S.SHEET-PLATES-COILS 304Q316Q"))),
                                            Container(
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .greyBlur3Color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: InkWell(
                                                    onTap: () {
                                                      widget.isShowProductCategory
                                                          ? context
                                                              .read<
                                                                  CategoryProviderViewModel>()
                                                              .setSelectedCategory(
                                                                  "SHEET-PLATES-COILS 201,202 Q",
                                                                  context)
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SSSheetPlatesCoilsScreen2()));
                                                    },
                                                    child: _categoryTile(
                                                        title: "201,202 Q",
                                                        categoryName:
                                                            "SHEET-PLATES-COILS 201,202 Q"))),
                                            Container(
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .greyBlur3Color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: InkWell(
                                                    onTap: () {
                                                      widget.isShowProductCategory
                                                          ? context
                                                              .read<
                                                                  CategoryProviderViewModel>()
                                                              .setSelectedCategory(
                                                                  "SHEET-PLATES-COILS 409,410,430Q",
                                                                  context)
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SSSheetPlatesCoilsScreen3()));
                                                    },
                                                    child: _categoryTile(
                                                        title: "409,410,430Q",
                                                        categoryName:
                                                            "SHEET-PLATES-COILS 409,410,430Q"))),
                                            Container(
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .greyBlur3Color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: InkWell(
                                                    onTap: () {
                                                      widget.isShowProductCategory
                                                          ? context
                                                              .read<
                                                                  CategoryProviderViewModel>()
                                                              .setSelectedCategory(
                                                                  "SHEET-PLATES 309, 310",
                                                                  context)
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SSSheetPlatesCoilsScreen4()));
                                                    },
                                                    child: _categoryTile(
                                                        title: "309, 310",
                                                        categoryName:
                                                            "SHEET-PLATES 309, 310"))),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteBlur3Color,
                                          // color: AppColors.whiteBlur3Color,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Visibility(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  is2CardVisible =
                                                      !is2CardVisible;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.015),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    is2CardVisible
                                                        ? Transform.rotate(
                                                            angle: 90 *
                                                                (3.1415926535 /
                                                                    180),
                                                            child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 15,
                                                          ),
                                                    const SizedBox(width: 8),
                                                    TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Pipes and Tubes",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: is2CardVisible,
                                              child: Column(
                                                children: [
                                                  const Divider(
                                                      color: AppColors
                                                          .hintLabel3TextColor),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S WELDED PIPES & TUBES 304-316",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen1()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Welded - 304/316",
                                                              categoryName:
                                                                  "S.S WELDED PIPES & TUBES 304-316"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S  Welded Cut Length - 304/316",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen2()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Welded Cut Length - 304/316",
                                                              categoryName:
                                                                  "S.S  Welded Cut Length - 304/316"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "SEAMLESS PIPES & TUBES (304-316)",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen3()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Seamless - 304/316",
                                                              categoryName:
                                                                  "SEAMLESS PIPES & TUBES (304-316)"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S Seamless Cut Length - 304/316",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen4()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Seamless Cut Length - 304/316",
                                                              categoryName:
                                                                  "S.S Seamless Cut Length - 304/316"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S. 304-316 Tubes",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen5()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Seamless Tubes - 304/316",
                                                              categoryName:
                                                                  "S.S. 304-316 Tubes"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "Seamless Pipes - 904L",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen6()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Seamless Pipes - 904L",
                                                              categoryName:
                                                                  "Seamless Pipes - 904L"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S.310 Seamless Pipes & Tubes",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen7()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Seamless and Welded - 310",
                                                              categoryName:
                                                                  "S.S.310 Seamless Pipes & Tubes"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S Seamless  & Welded - 202",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const PipesAndTubesScreen8()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Seamless and Welded - 202",
                                                              categoryName:
                                                                  "S.S Seamless  & Welded - 202"))),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteBlur3Color,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Visibility(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  is3CardVisible =
                                                      !is3CardVisible;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.015),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    is3CardVisible
                                                        ? Transform.rotate(
                                                            angle: 90 *
                                                                (3.1415926535 /
                                                                    180),
                                                            child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 15,
                                                          ),
                                                    const SizedBox(width: 8),
                                                    TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text:
                                                          "Circle, Patta and Patti",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: is3CardVisible,
                                              child: Column(
                                                children: [
                                                  const Divider(
                                                      color: AppColors
                                                          .hintLabel3TextColor),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "8 To 100 MM CIRCLE-PATTA-PATTI",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const EightMMScreen()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "S8mm to 100mm - 304/316",
                                                              categoryName:
                                                                  "8 To 100 MM CIRCLE-PATTA-PATTI"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "0.1 TO 8 MM CIRCLE-PATTA-PATTI",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const ZeroPointMMScreen()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "0.1mm to 8mm - 304/316",
                                                              categoryName:
                                                                  "0.1 TO 8 MM CIRCLE-PATTA-PATTI"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "All Thickness - 202",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const AllThicknessScreen()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "All Thickness - 202",
                                                              categoryName:
                                                                  "All Thickness - 202"))),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteBlur3Color,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Visibility(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  is4CardVisible =
                                                      !is4CardVisible;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.015),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    is4CardVisible
                                                        ? Transform.rotate(
                                                            angle: 90 *
                                                                (3.1415926535 /
                                                                    180),
                                                            child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 15,
                                                          ),
                                                    const SizedBox(width: 8),
                                                    TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Roads and Bard",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: is4CardVisible,
                                              child: Column(
                                                children: [
                                                  const Divider(
                                                      color: AppColors
                                                          .hintLabel3TextColor),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S. ROUND BAR (304)(316) QUALITY",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const RoadsAndBardScreen1()));
                                                          },
                                                          child: _categoryTile(
                                                              title: "304/316",
                                                              categoryName:
                                                                  "S.S. ROUND BAR (304)(316) QUALITY"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "STAINLESS STEEL RODS 310-309GR.",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const RoadsAndBardScreen2()));
                                                          },
                                                          child: _categoryTile(
                                                              title: "309/310",
                                                              categoryName:
                                                                  "STAINLESS STEEL RODS 310-309GR."))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S.RODS 410,420,430,440,446",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const RoadsAndBardScreen3()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "400 Series",
                                                              categoryName:
                                                                  "S.S.RODS 410,420,430,440,446"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S. ROD 202",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const RoadsAndBardScreen4()));
                                                          },
                                                          child: _categoryTile(
                                                              title: "202",
                                                              categoryName:
                                                                  "S.S. ROD 202"))),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteBlur3Color,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Visibility(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  is5CardVisible =
                                                      !is5CardVisible;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.015),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    is5CardVisible
                                                        ? Transform.rotate(
                                                            angle: 90 *
                                                                (3.1415926535 /
                                                                    180),
                                                            child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 15,
                                                          ),
                                                    const SizedBox(width: 8),
                                                    TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Wire Rod",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: is5CardVisible,
                                              child: Column(
                                                children: [
                                                  const Divider(
                                                      color: AppColors
                                                          .hintLabel3TextColor),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "S.S. WIRE ROD 304-316",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const WireRodScreen()));
                                                          },
                                                          child: _categoryTile(
                                                              title: "304/316",
                                                              categoryName:
                                                                  "S.S. WIRE ROD 304-316"))),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteBlur3Color,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Visibility(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  is6CardVisible =
                                                      !is6CardVisible;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.015,
                                                    vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    is6CardVisible
                                                        ? Transform.rotate(
                                                            angle: 90 *
                                                                (3.1415926535 /
                                                                    180),
                                                            child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 15,
                                                          ),
                                                    const SizedBox(width: 8),
                                                    TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Fittings",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: is6CardVisible,
                                              child: Column(
                                                children: [
                                                  const Divider(
                                                      color: AppColors
                                                          .hintLabel3TextColor),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "WELDED B-W-ELBOW TEE-COUPLING-NIPPLE",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const FittingsScreen1()));
                                                          },
                                                          child: _categoryTile(
                                                              title: "Welded",
                                                              categoryName:
                                                                  "WELDED B-W-ELBOW TEE-COUPLING-NIPPLE"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "SEAMLESS FITTINGS-ELBOW-TEE-COUPLING",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const FittingsScreen2()));
                                                          },
                                                          child: _categoryTile(
                                                              title: "Seamless",
                                                              categoryName:
                                                                  "SEAMLESS FITTINGS-ELBOW-TEE-COUPLING"))),
                                                  Container(
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "DAIRY FITTINGS - FORGE FITTINGS",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const FittingsScreen3()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Dairy and Forge",
                                                              categoryName:
                                                                  "DAIRY FITTINGS - FORGE FITTINGS"))),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteBlur3Color,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Visibility(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  is7CardVisible =
                                                      !is7CardVisible;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.015),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    is7CardVisible
                                                        ? Transform.rotate(
                                                            angle: 90 *
                                                                (3.1415926535 /
                                                                    180),
                                                            child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 15,
                                                          ),
                                                    const SizedBox(width: 8),
                                                    TextWidget(
                                                      color:
                                                          AppColors.blackColor,
                                                      text: "Forge Items",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: is7CardVisible,
                                              child: Column(
                                                children: [
                                                  const Divider(
                                                      color: AppColors
                                                          .hintLabel3TextColor),
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greyBlur3Color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                      child: InkWell(
                                                          onTap: () {
                                                            widget.isShowProductCategory
                                                                ? context
                                                                    .read<
                                                                        CategoryProviderViewModel>()
                                                                    .setSelectedCategory(
                                                                        "FORGE ITEMS-CIRCLE-PATTA-HEX ETC",
                                                                        context)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const ForgeItemsScreen()));
                                                          },
                                                          child: _categoryTile(
                                                              title:
                                                                  "Circle, Patta, Hex, Etc",
                                                              categoryName:
                                                                  "FORGE ITEMS-CIRCLE-PATTA-HEX ETC"))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                          onTap: () {
                                            widget.isShowProductCategory
                                                ? context
                                                    .read<
                                                        CategoryProviderViewModel>()
                                                    .setSelectedCategory(
                                                        "S.S FLANGES", context)
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FlangesScreen()));
                                          },
                                          child: _categoryAction(
                                            categoryName: "S.S FLANGES",
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Flanges",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                          onTap: () {
                                            widget.isShowProductCategory
                                                ? context
                                                    .read<
                                                        CategoryProviderViewModel>()
                                                    .setSelectedCategory(
                                                        "ANGLE - CHANNEL - PATTI",
                                                        context)
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AngleScreen()));
                                          },
                                          child: _categoryAction(
                                            categoryName:
                                                "ANGLE - CHANNEL - PATTI",
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: TextWidget(
                                                color: AppColors.blackColor,
                                                text:
                                                    "Angle, Channel and Patti",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    GestureDetector(
                                      onTap: () {
                                        widget.isShowProductCategory
                                            ? context
                                                .read<
                                                    CategoryProviderViewModel>()
                                                .setSelectedCategory(
                                                    "S.S. ROLLING PATTA PATTI",
                                                    context)
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RollingScreen()));
                                      },
                                      child: Container(
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteBlur3Color,
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: _categoryAction(
                                            categoryName:
                                                "S.S. ROLLING PATTA PATTI",
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Rolling Patta and Patti",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                          onTap: () {
                                            widget.isShowProductCategory
                                                ? context
                                                    .read<
                                                        CategoryProviderViewModel>()
                                                    .setSelectedCategory(
                                                        "STAINLESS STEEL FURNITURE ITEMS",
                                                        context)
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FurnitureItemsScreen()));
                                          },
                                          child: _categoryAction(
                                            categoryName:
                                                "STAINLESS STEEL FURNITURE ITEMS",
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: TextWidget(
                                                    color: AppColors.blackColor,
                                                    text: "Furniture Items",
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                          ),
                                        )),
                                    Divider(
                                        color: AppColors.greyColor
                                            .withValues(alpha: 0.2)),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                          onTap: () {
                                            widget.isShowProductCategory
                                                ? context
                                                    .read<
                                                        CategoryProviderViewModel>()
                                                    .setSelectedCategory(
                                                        "S.S.SCRAP", context)
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ScrapScreen()));
                                          },
                                          child: _categoryAction(
                                            categoryName: "S.S.SCRAP",
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: TextWidget(
                                                color: AppColors.blackColor,
                                                text: "Scrap",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: screenWidth * 0.015,
                                    ),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.015,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSecondCardVisible = !isSecondCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isSecondCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "Copper and Brass",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: AppColors.whiteBlur3Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isSecondCardVisible,
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "COPPER / BRASS/ PIPES & TUBES",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const CopperAndBrassScreen1()));
                                            },
                                            child: _categoryTile(
                                                title: "Pipes and Tubes",
                                                categoryName:
                                                    "COPPER / BRASS/ PIPES & TUBES"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "P.B. COPPER / BRASS SHEET STRIP",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const CopperAndBrassScreen2()));
                                            },
                                            child: _categoryTile(
                                                title: "Sheet Strips",
                                                categoryName:
                                                    "P.B. COPPER / BRASS SHEET STRIP"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "COPPER/BRASS/ WIRE & S.E. WIRE",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const CopperAndBrassScreen3()));
                                            },
                                            child: _categoryTile(
                                                title: "Wire and S.E Wire",
                                                categoryName:
                                                    "COPPER/BRASS/ WIRE & S.E. WIRE"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "COPPER/BRASS/ROD/PATTA/PATTI",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const CopperAndBrassScreen4()));
                                            },
                                            child: _categoryTile(
                                                title: "Rod and Flats",
                                                categoryName:
                                                    "COPPER/BRASS/ROD/PATTA/PATTI"))),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.015,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isThirdCardVisible = !isThirdCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isThirdCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "Gun Metal and P.B",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: AppColors.whiteBlur1Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isThirdCardVisible,
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur3Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "GUN METAL P.B. BUSH ROD CASTING",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const BushRoadScreen()));
                                            },
                                            child: _categoryTile(
                                                title: "Bush Rod and Casting",
                                                categoryName:
                                                    "GUN METAL P.B. BUSH ROD CASTING"))),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.015,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isFourthCardVisible = !isFourthCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isFourthCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "Aluminium",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: AppColors.whiteBlur1Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isFourthCardVisible,
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "ALUMINIUM", context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AluminiumScreen()));
                                            },
                                            child: _categoryTile(
                                                title:
                                                    "Pipe, Plates, Sheets, Roads, Etc",
                                                categoryName: "ALUMINIUM"))),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.015,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isFifthCardVisible = !isFifthCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isFifthCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "Exotic Metals",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: AppColors.whiteBlur1Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isFifthCardVisible,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screenWidth * 0.015,
                                    ),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "17-4PH IMPORTED ROUND BAR",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ExoticMetalsScreen1()));
                                            },
                                            child: _categoryTile(
                                                title: "17-4 Round Bars",
                                                categoryName:
                                                    "17-4PH IMPORTED ROUND BAR"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "FERRO & FERRO ALLOYS PERCENTAGE",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ExoticMetalsScreen2()));
                                            },
                                            child: _categoryTile(
                                                title: "Percentage Items",
                                                categoryName:
                                                    "FERRO & FERRO ALLOYS PERCENTAGE"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "Duplex/Super Duplex Bar38",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ExoticMetalsScreen3()));
                                            },
                                            child: _categoryTile(
                                                title:
                                                    "Duplex/ Super Duplex Bar",
                                                categoryName:
                                                    "Duplex/Super Duplex Bar38"))),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.015,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSixCardVisible = !isSixCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isSixCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "SS/Ms Fasteners",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: AppColors.whiteBlur1Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isSixCardVisible,
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "S.S.-M.S.NUT BOLT-FASTENERS",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MSFastenersScreen()));
                                            },
                                            child: _categoryTile(
                                                title: "MS/Ss Fasteners",
                                                categoryName:
                                                    "S.S.-M.S.NUT BOLT-FASTENERS"))),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.015,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSevenCardVisible = !isSevenCardVisible;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    isSevenCardVisible
                                        ? Transform.rotate(
                                            angle: 90 * (3.1415926535 / 180),
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                          ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      color: AppColors.blackColor,
                                      text: "Mild Carbon Alloy Steel",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: AppColors.whiteBlur1Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Visibility(
                                visible: isSevenCardVisible,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screenWidth * 0.015,
                                    ),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "M.S. PIPE & FITTING",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MildScreen1()));
                                            },
                                            child: _categoryTile(
                                                title: "MS Fittings",
                                                categoryName:
                                                    "M.S. PIPE & FITTING"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "M.S. & EN SERIES ROUND BAR",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MildScreen2()));
                                            },
                                            child: _categoryTile(
                                                title: "MS and EN Series Bard",
                                                categoryName:
                                                    "M.S. & EN SERIES ROUND BAR"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "M.S.FLANGES",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MildScreen3()));
                                            },
                                            child: _categoryTile(
                                                title: "MS Flanges",
                                                categoryName: "M.S.FLANGES"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "CARBON STEEL SEAMLESS PIPE STOCKIST",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MildScreen4()));
                                            },
                                            child: _categoryTile(
                                                title:
                                                    "Carbon Steel Seamless Pipes",
                                                categoryName:
                                                    "CARBON STEEL SEAMLESS PIPE STOCKIST"))),
                                    Container(
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteBlur1Color,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                            onTap: () {
                                              widget.isShowProductCategory
                                                  ? context
                                                      .read<
                                                          CategoryProviderViewModel>()
                                                      .setSelectedCategory(
                                                          "ALLOY STEEL SEAMLESS PIPE STOCKIST",
                                                          context)
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MildScreen5()));
                                            },
                                            child: _categoryTile(
                                                title:
                                                    "Alloy Steel Seamless Pipes",
                                                categoryName:
                                                    "ALLOY STEEL SEAMLESS PIPE STOCKIST"))),
                                    Container(
                                      height: 6,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future phoneNumberToCall({required String number}) async {
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
    // if(numberToCall.isNotEmpty) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   int? simNumber = prefs.getInt("secondSim");
    //   final DirectCaller directCaller = DirectCaller();
    //   directCaller.makePhoneCall(numberToCall, simSlot: simNumber ?? 1);
    // }
    IosAndroidPlatformConfiguration()
        .initiatePhoneCall(numberToCall: numberToCall);
  }
}
