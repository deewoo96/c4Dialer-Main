part of 'search_imports.dart';

class BushRoadScreen extends StatefulWidget {
  const BushRoadScreen({super.key});

  @override
  State<BushRoadScreen> createState() => _BushRoadScreenState();
}

class _BushRoadScreenState extends State<BushRoadScreen> {
  late DatabaseReference selectedCategory;
  List<Map<dynamic, dynamic>> _data = [];
  List<Map<dynamic, dynamic>> get data => _data;
  set data(List<Map<dynamic, dynamic>> users) {
    _data = sortCategoryUsersAlphabetically(users);
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('bushRoadScreen');
    if (storedData == null) {
      _fetchDataFromFirebase();
    } else {
      _fetchDataFromSharedPreferences();
      _fetchDataFromFirebase();
    }
  }

  Future<void> _fetchDataFromFirebase() async {
    selectedCategory = FirebaseDatabase.instance.ref().child("Users");
    selectedCategory
        .orderByChild("categorySelected")
        .equalTo("GUN METAL P.B. BUSH ROD CASTING")
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final responseData = event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<dynamic, dynamic>> tempData = [];
        responseData.forEach((key, value) {
          tempData.add({
            "categorySelected": value["categorySelected"],
            "companyName": value["companyName"],
            "companyDetails": value["companyDetails"],
            "phoneNumber": value["phoneNumber"],
            "phoneNumber1": value["phoneNumber1"],
            "phoneNumber2": value["phoneNumber2"],
            "productKeyword": value["productKeyword"],
            "hughesNumber": value["hughes1"],
            "hughes2": value["hughes2"],
            "hughes3": value["hughes3"],
            "hughes4": value["hughes4"],
            "name": value["name"],
            "name1": value["name1"],
            "url": value["url"],
            "profileImageUrl": value["profileImageUrl"],
            "premium": value["premium"],
          });
        });
        setState(() {
          data = tempData;
          isLoading = false;
        });
        _storeDataInSharedPreferences(tempData);
      } else {
        Utils.animatedErrorSnackBarMessage(
            "No matching data found GUN METAL P.B. BUSH ROD CASTING", context);
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      Utils.animatedErrorSnackBarMessage("Error: $error", context);
    });
  }

  Future<void> _storeDataInSharedPreferences(
      List<Map<dynamic, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = json.encode(data);
    await prefs.setString('bushRoadScreen', dataJson);
  }

  Future<void> _fetchDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDataJson = prefs.getString('bushRoadScreen');
    if (storedDataJson != null) {
      final List<Map<dynamic, dynamic>> storedData =
          List<Map<dynamic, dynamic>>.from(json.decode(storedDataJson));
      setState(() {
        data = storedData;
        isLoading = false;
      });
    } else {
      Utils.animatedErrorSnackBarMessage(
          "Unable To Fetch Offline Data", context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
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
        actions: [
          CategoryWhatsappButton(
            categoryName: "GUN METAL P.B. BUSH ROD CASTING",
          ),
        ],
      ),
      body: isLoading
          ? const HorizontalVerticalShimmerWidget()
          : RefreshIndicator(
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    _fetchDataFromFirebase();
                    Utils.flushBarInfoMessage(
                        "Details Has Been Updated Successfully", context);
                  },
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                              color: AppColors.whiteBlur1Color),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileWidget(
                                            appBarTitle:
                                                item["companyName"] ?? "",
                                            companyAddress:
                                                item["companyDetails"] ?? "",
                                            companyName:
                                                item["companyName"] ?? "",
                                            firstPhoneNumber:
                                                item["phoneNumber"] ?? "",
                                            secondPhoneNumber:
                                                item["phoneNumber1"] ?? "",
                                            selectedCategory:
                                                item["categorySelected"] ?? "",
                                            websiteUrl: item["url"] ?? "",
                                            firstHughesNumber:
                                                item["hughesNumber"] ?? "",
                                            secondHughesNumber:
                                                item["hughes2"] ?? "",
                                            thirdHughesNumber:
                                                item["hughes3"] ?? "",
                                            fourthHughesNumber:
                                                item["hughes4"] ?? "",
                                            productKeyword:
                                                item["productKeyword"] ?? "",
                                            name1: item["name"] ?? "",
                                            name2: item["name1"] ?? "",
                                            profileImageUrl:
                                                item["profileImageUrl"] ?? "",
                                          )));
                            },
                            leading: const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryColor,
                              backgroundImage: AssetImage(AppString.userImg),
                            ),
                            title: TextWidget(
                              color: AppColors.blackColor,
                              text: capitalizeFirstLetterOfEachWord(
                                  item["companyName"] ?? ""),
                              premium: item["premium"],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            subtitle: TextWidget(
                              color: AppColors.blackColor,
                              text: item["categorySelected"] ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            trailing: CategoryHughesNumberButton(
                                number: item["hughesNumber"]?.toString() ?? ""),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
