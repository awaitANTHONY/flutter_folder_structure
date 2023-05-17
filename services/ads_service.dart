// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import '/controllers/setting_controller.dart';
// import '/utils/helpers.dart';
// import '/consts/consts.dart';
// import '/controllers/auth_controller.dart';

// int _numInterstitialLoadAttempts = 0;

// class AdsService {
//   static SettingController controller = Get.find<SettingController>();
//   static AuthController authController = Get.find();
//   static VoidCallback startAppCallback = () {};

//   static InterstitialAd? interstitialAd;
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );

//   static void createInterstitialAd([callback]) async {
//     if (!controller.adStatus.value || authController.isSubscribed.value) {
//       return;
//     }
//     if (controller.adsType.value == 'google') {
//       InterstitialAd.load(
//         adUnitId: controller.interstitialPlacementId.value,
//         request: request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             dd('InterstitialAd $ad loaded');

//             interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             if (callback != null) {
//               Future.delayed(2.seconds, () {
//                 callback();
//               });
//             }
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             dd('InterstitialAd failed to load: $error.');

//             _numInterstitialLoadAttempts += 1;
//             interstitialAd = null;
//             if (_numInterstitialLoadAttempts <= 3) {
//               createInterstitialAd(callback);
//             }
//           },
//         ),
//       );
//     } else if (controller.adsType.value == 'startapp') {
//       dd('startapp');
//     } else if (controller.adsType.value == 'facebook') {}
//   }

//   static void showInterstitialAd(callback,
//       {adControl = true, onlyOn = ''}) async {
//     if (!controller.adStatus.value || authController.isSubscribed.value) {
//       callback();

//       return;
//     }
//     if (!controller.showAd() && adControl) {
//       callback();

//       return;
//     }

//     if (controller.adsType.value == 'google' &&
//         (onlyOn == '' || onlyOn == 'google')) {
//       dd('InterstitialAd');
//       if (interstitialAd == null) {
//         dd('Warning: attempt to show interstitial before loaded.');

//         callback();

//         return;
//       }
//       interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
//         onAdShowedFullScreenContent: (InterstitialAd ad) =>
//             dd('ad onAdShowedFullScreenContent.'),
//         onAdDismissedFullScreenContent: (InterstitialAd ad) {
//           dd('$ad onAdDismissedFullScreenContent.');
//           ad.dispose();
//           interstitialAd = null;
//           createInterstitialAd();
//           callback();
//         },
//         onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//           dd('$ad onAdFailedToShowFullScreenContent: $error');
//           ad.dispose();
//           interstitialAd = null;
//           callback();
//           createInterstitialAd();
//         },
//       );
//       interstitialAd?.show();
//       interstitialAd = null;
//     } else if (controller.adsType.value == 'startapp' &&
//         (onlyOn == '' || onlyOn == 'startapp')) {
//       dd('startapp');
//     } else if (controller.adsType.value == 'facebook' &&
//         (onlyOn == '' || onlyOn == 'facebook')) {}
//   }
// }

// class BannerAds extends StatelessWidget {
//   BannerAds({Key? key}) : super(key: key);
//   final SettingController settingController = Get.find();
//   final AuthController authController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     dd('');
//     return Obx(() {
//       if (!settingController.adStatus.value ||
//           authController.isSubscribed.value) {
//         return const SizedBox();
//       } else if (settingController.adsType.value == 'google') {
//         return const GoogleBannerAds();
//       } else if (settingController.adsType.value == 'startapp') {}

//       return const SizedBox();
//     });
//   }
// }

// class GoogleBannerAds extends StatefulWidget {
//   const GoogleBannerAds({Key? key}) : super(key: key);

//   @override
//   GoogleBannerAdsState createState() => GoogleBannerAdsState();
// }

// class GoogleBannerAdsState extends State<GoogleBannerAds> {
//   SettingController settingController = Get.find();
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );
//   BannerAd? _anchoredBanner;
//   bool _loadingAnchoredBanner = false;
//   Future<void> _createAnchoredBanner(BuildContext context) async {
//     final AnchoredAdaptiveBannerAdSize? size =
//         await AdSize.getAnchoredAdaptiveBannerAdSize(
//       Orientation.portrait,
//       MediaQuery.of(context).size.width.truncate(),
//     );

//     if (size == null) {
//       dd('Unable to get height of anchored banner.');
//       return;
//     }

//     final BannerAd banner = BannerAd(
//       size: size,
//       request: request,
//       adUnitId: settingController.bannerPlacementId.value,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           dd('$BannerAd loaded.');
//           setState(() {
//             _anchoredBanner = ad as BannerAd?;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           dd('$BannerAd failedToLoad: $error');
//           ad.dispose();
//         },
//         onAdOpened: (Ad ad) => dd('$BannerAd onAdOpened.'),
//         onAdClosed: (Ad ad) => dd('$BannerAd onAdClosed.'),
//       ),
//     );
//     return banner.load();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (!_loadingAnchoredBanner && settingController.adStatus.value) {
//       _loadingAnchoredBanner = true;
//       _createAnchoredBanner(context);
//     }
//   }

//   @override
//   void dispose() {
//     _anchoredBanner?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _anchoredBanner != null
//         ? Container(
//             color: Colors.transparent,
//             width: _anchoredBanner!.size.width.toDouble(),
//             height: _anchoredBanner!.size.height.toDouble(),
//             child: AdWidget(ad: _anchoredBanner!),
//           )
//         : const SizedBox();
//   }
// }

// class InlineAds extends StatefulWidget {
//   const InlineAds({Key? key}) : super(key: key);

//   @override
//   State<InlineAds> createState() => _InlineAdsState();
// }

// class _InlineAdsState extends State<InlineAds> {
//   final SettingController settingController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     if (!settingController.adStatus.value) {
//       return const SizedBox();
//     } else if (settingController.adsType.value == 'google') {
//       return const GoogleInlineAds();
//     } else if (settingController.adsType.value == 'startapp') {
//       return const SizedBox();
//     }

//     return const SizedBox();
//   }
// }

// class GoogleInlineAds extends StatefulWidget {
//   const GoogleInlineAds({Key? key}) : super(key: key);

//   @override
//   GoogleInlineAdsState createState() => GoogleInlineAdsState();
// }

// class GoogleInlineAdsState extends State<GoogleInlineAds> {
//   SettingController settingController = Get.find();
//   BannerAd? _bannerAd;
//   bool _bannerAdIsLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     final BannerAd? bannerAd = _bannerAd;
//     if (_bannerAdIsLoaded && bannerAd != null) {
//       return Container(
//         margin: const EdgeInsets.only(top: 5, bottom: 5),
//         child: SizedBox(
//           height: bannerAd.size.height.toDouble(),
//           width: bannerAd.size.width.toDouble(),
//           child: AdWidget(ad: _bannerAd!),
//         ),
//       );
//     }

//     return const SizedBox();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     _bannerAd = BannerAd(
//       adUnitId: settingController.bannerPlacementId.value,
//       request: const AdRequest(),
//       size: AdSize.mediumRectangle,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           dd('$AdManagerBannerAd loaded.');
//           setState(() {
//             _bannerAdIsLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           dd('$BannerAd failedToLoad: $error');
//           ad.dispose();
//         },
//         onAdOpened: (Ad ad) => dd('$BannerAd onAdOpened.'),
//         onAdClosed: (Ad ad) => dd('$BannerAd onAdClosed.'),
//       ),
//     )..load();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _bannerAd?.dispose();
//   }
// }

// class NativeAds extends StatefulWidget {
//   const NativeAds({super.key});

//   @override
//   State<NativeAds> createState() => _NativeAdsState();
// }

// class _NativeAdsState extends State<NativeAds> {
//   final SettingController settingController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     if (!settingController.adStatus.value) {
//       return const SizedBox();
//     } else if (settingController.adsType.value == 'google') {
//       return const GoogleNativeAd();
//     } else if (settingController.adsType.value == 'startapp') {
//       return const SizedBox();
//     }

//     return const SizedBox();
//   }
// }

// class GoogleNativeAd extends StatefulWidget {
//   const GoogleNativeAd({super.key});

//   @override
//   State<GoogleNativeAd> createState() => _GoogleNativeAdState();
// }

// class _GoogleNativeAdState extends State<GoogleNativeAd> {
//   final SettingController settingController = Get.find();
//   NativeAd? _nativeAd;
//   bool _nativeAdIsLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     return (_nativeAd != null && _nativeAdIsLoaded)
//         ? Stack(
//             children: [
//               SizedBox(
//                 height: 360,
//                 child: AdWidget(ad: _nativeAd!),
//               ),
//             ],
//           )
//         : const SizedBox();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     _nativeAd = NativeAd(
//       adUnitId: settingController.nativePlacementId.value,
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (Ad ad) {
//           dd('$NativeAd loaded.');
//           setState(() {
//             _nativeAdIsLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           dd('$NativeAd failedToLoad: $error');
//           ad.dispose();
//         },
//         onAdOpened: (Ad ad) => dd('$NativeAd onAdOpened.'),
//         onAdClosed: (Ad ad) => dd('$NativeAd onAdClosed.'),
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         templateType: TemplateType.medium,
//         mainBackgroundColor: Colors.white,
//         callToActionTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.white,
//           backgroundColor: Colors.blue.shade600,
//           style: NativeTemplateFontStyle.normal,
//           size: AppSizes.size15,
//         ),
//         primaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.black,
//           backgroundColor: Colors.white,
//           style: NativeTemplateFontStyle.bold,
//           size: AppSizes.size15,
//         ),
//         secondaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.black54,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.normal,
//           size: AppSizes.size14,
//         ),
//         tertiaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.brown,
//           backgroundColor: Colors.white,
//           style: NativeTemplateFontStyle.normal,
//           size: AppSizes.size15,
//         ),
//       ),
//       nativeAdOptions: NativeAdOptions(
//         mediaAspectRatio: MediaAspectRatio.square,
//       ),
//     )..load();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _nativeAd?.dispose();
//   }
// }
