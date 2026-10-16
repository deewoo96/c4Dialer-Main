part of 'home_imports.dart';

class CalciWebViewPage extends StatefulWidget {
  const CalciWebViewPage({super.key});

  @override
  State<CalciWebViewPage> createState() => _CalcihWebViewPageState();
}

class _CalcihWebViewPageState extends State<CalciWebViewPage> {
  late final WebViewController _controller;
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

Future fetchAdvertisementDataFromFirebase() async{
  late DatabaseReference notificationRef = FirebaseDatabase.instance.ref().child("advertiseSection");
  notificationRef.onValue.listen((event) async{
    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        advertiseBannerUrl = data['advertiseBannerUrl'];
        isAdvertiseBannerVisible = data['isAdvertiseBannerVisible'];
      });
    }
  });
}
@override
  void initState() {
    super.initState();
    createBannerAd();
    fetchAdvertisementDataFromFirebase();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..loadFlutterAsset('assets/webViewLinks/calc.html');



    // controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onPageStarted: (String url) {},
    //       onPageFinished: (String url) {},
    //       onWebResourceError: (WebResourceError error) {
    //         Utils.flushBarInfoMessage("WebResourceError description: ${error.description}", context);
    //       },
    //       onNavigationRequest: (NavigationRequest request) async {
    //         if (request.url.startsWith("https://chat.whatsapp.com/") || request.url.startsWith("whatsapp://")) {
    //           Utils.launchUrlUtils(request.url);
    //           return NavigationDecision.prevent;
    //         } else if (request.url.startsWith("tel:")) {
    //           Utils.launchUrlUtils(request.url);
    //           return NavigationDecision.prevent;
    //         }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..loadRequest(
    //     Uri.parse(url),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            }, child: const Icon(Icons.arrow_back_ios_outlined,color: AppColors.black,)
        ),
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
        body: Center(
          child: SizedBox(
            width: isTablet(context) ? screenWidth(context) * 0.6 : null,
            child: Column(
              children: [
                isAdvertiseBannerVisible ?
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CachedNetworkImage(
                      imageUrl: advertiseBannerUrl,
                      width: screenWidth(context),
                      height: 52,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const ContainerShimmerWidget(height: 52,),
                      errorWidget: (context, url, error) =>  const Text("")
                  ),
                ) : Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: BannerAdWidget(banner: banner),
                    // child: buildBannerWidget(banner)
                ),
                Expanded(
                  child: WebViewWidget(controller: _controller),
                )
              ],
            ),
          ),
        )
    );
  }
}







