part of 'home_imports.dart';

class FirstWebViewPage extends StatefulWidget {
  final String firstImageLink;
  const FirstWebViewPage({
    super.key,
    required this.firstImageLink
  });

  @override
  State<FirstWebViewPage> createState() => _FirstWebViewPageState();
}

class _FirstWebViewPageState extends State<FirstWebViewPage> {
  late final WebViewController controller;
  bool isOnline = true;

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
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            Utils.flushBarInfoMessage("WebResourceError description: ${error.description}", context);
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith("https://chat.whatsapp.com/") || request.url.startsWith("whatsapp://")) {
              Utils.launchUrlUtils(request.url);
              return NavigationDecision.prevent;
            } else if (request.url.startsWith("tel:")) {
              Utils.launchUrlUtils(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.firstImageLink),
      );
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
              Icons.arrow_back_ios_outlined, color: AppColors.black,)),
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
            Container(padding: const EdgeInsets.only(left: 10),
                child: Image.asset(AppString.appTitleLogo, width: 100)),
          ],
        ),
      ),
      body: Column(
        children: [
          isAdvertiseBannerVisible ?
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: CachedNetworkImage(
                imageUrl: advertiseBannerUrl,
                width: screenWidth(context),
                height: 52,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                const ContainerShimmerWidget(height: 52,),
                errorWidget: (context, url, error) => const Text("")
            ),
          ) : BannerAdWidget(banner: banner),
          const SizedBox(height: 5),
          Expanded(
            child: WebViewWidget(
                controller: controller
            ),
          ),
        ],
      ),
    );
  }
}
