// import 'package:genx_translator/consts/consts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import '/utils/helpers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// int _numInterstitialLoadAttempts = 0;
// int _numRewardedInterstitialLoadAttempts = 0;

// class AdsService {
//   static InterstitialAd? interstitialAd;
//   static RewardedInterstitialAd? rewardedInterstitialAd;

//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );

//   static init() async {
//     if (!settingController.adsStatus.value ||
//         settingController.isSubscribed.value) return;
//     if (settingController.adsType.value == 'google') {
//       await MobileAds.instance.updateRequestConfiguration(
//         RequestConfiguration(
//           tagForChildDirectedTreatment:
//               TagForChildDirectedTreatment.unspecified,
//           testDeviceIds: [
//             "8FECD77B9178A2514A9BFB8F6DB2C99F",
//             "AD9B79EB2D405F358FB2BDA489041B7B",
//             "407A8A93820C155D8AF1CA6F0B746E28",
//           ],
//         ),
//       );
//        
//        await Future.delayed(2.seconds);
//        requestConsent();
//     } else if (settingController.adsType.value == 'facebook') {
//       await Future.delayed(1.seconds);
//       //
//     }
//   }

//   static Future<ConsentStatus> getConsentStatus() async {
//     var status = await ConsentInformation.instance.getConsentStatus();
//     return status;
//   }

//   static void requestConsent() async {
//     ConsentDebugSettings debugSettings = ConsentDebugSettings(
//       debugGeography: DebugGeography.debugGeographyEea,
//       testIdentifiers: [
//         'TEST-DEVICE-HASHED-ID',
//       ],
//     );

//     ConsentRequestParameters params =
//         ConsentRequestParameters(consentDebugSettings: debugSettings);

//     ConsentInformation.instance.requestConsentInfoUpdate(
//       params,
//       () async {
//         if (await ConsentInformation.instance.isConsentFormAvailable()) {
//           requestConsentForm();
//         }
//       },
//       (FormError error) {
//         dd(error.message);
//       },
//     );
//   }

//   static void resetConsent() {
//     ConsentInformation.instance.reset();
//   }

//   static void requestConsentForm() {
//     ConsentForm.loadConsentForm(
//       (ConsentForm consentForm) async {
//         var status = await getConsentStatus();
//         if (status == ConsentStatus.required) {
//           consentForm.show(
//             (FormError? formError) {
//               dd(formError?.message);
//               requestConsentForm();
//             },
//           );
//         }
//       },
//       (formError) {
//         dd(formError.message);
//       },
//     );
//   }

//   static void createInterstitialAd([callback]) async {
//     if (!settingController.adsStatus.value) {
//       return;
//     }
//     if (settingController.adsType.value == 'google') {
//       InterstitialAd.load(
//         adUnitId: settingController.interstitialPlacementId.value,
//         request: request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             if (kDebugMode) {
//               dd('$ad loaded');
//             }
//             interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             if (callback != null) {
//               Future.delayed(2.seconds, () {
//                 callback();
//               });
//             }
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             if (kDebugMode) {
//               dd('InterstitialAd failed to load: $error.');
//             }
//             _numInterstitialLoadAttempts += 1;
//             interstitialAd = null;
//             if (_numInterstitialLoadAttempts <= 3) {
//               createInterstitialAd(callback);
//             }
//           },
//         ),
//       );
//     } else if (settingController.adsType.value == 'startapp') {
//       dd('startapp');
//     } else if (settingController.adsType.value == 'facebook') {}
//   }

//   static void showInterstitialAd(callback,
//       {adControl = true, onlyOn = ''}) async {
//     if (!settingController.adsStatus.value) {
//       callback();
//       return;
//     }
//     if (!settingController.showAd() && adControl) {
//       callback();
//       return;
//     }

//     if (settingController.adsType.value == 'google' &&
//         (onlyOn == '' || onlyOn == 'google')) {
//       if (interstitialAd == null) {
//         if (kDebugMode) {
//           dd('Warning: attempt to show interstitial before loaded.');
//         }

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
//     } else if (settingController.adsType.value == 'startapp' &&
//         (onlyOn == '' || onlyOn == 'startapp')) {
//       dd('startapp');
//     } else if (settingController.adsType.value == 'facebook' &&
//         (onlyOn == '' || onlyOn == 'facebook')) {}
//   }

//   static void createRewardedInterstitialAd() async {
//     if (!settingController.adsStatus.value) {
//       return;
//     }
//     if (settingController.adsType.value == 'google') {
//       RewardedInterstitialAd.load(
//         adUnitId: settingController.interstitialPlacementId.value,
//         request: request,
//         rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//           onAdLoaded: (RewardedInterstitialAd ad) {
//             dd('$ad loaded');

//             rewardedInterstitialAd = ad;
//             _numRewardedInterstitialLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             dd('RewardedInterstitialAd failed to load: $error.');
//             _numRewardedInterstitialLoadAttempts += 1;
//             rewardedInterstitialAd = null;
//             if (_numRewardedInterstitialLoadAttempts <= 3) {
//               createRewardedInterstitialAd();
//             }
//           },
//         ),
//       );
//     } else if (settingController.adsType.value == 'startapp') {
//       dd('startapp');
//     } else if (settingController.adsType.value == 'facebook') {}
//   }

//   static void showRewardedInterstitialAd(
//       Null Function(RewardItem? reward) callback,
//       {adControl = true,
//       onlyOn = ''}) async {
//     RewardItem? rewardItem;
//     if (!settingController.adsStatus.value) {
//       callback(rewardItem);
//       return;
//     }
//     if (!settingController.showAd() && adControl) {
//       callback(rewardItem);
//       return;
//     }

//     if (settingController.adsType.value == 'google' &&
//         (onlyOn == '' || onlyOn == 'google')) {
//       if (rewardedInterstitialAd == null) {
//         dd('Warning: attempt to show interstitial before loaded.');

//         callback(rewardItem);

//         return;
//       }
//       rewardedInterstitialAd?.fullScreenContentCallback =
//           FullScreenContentCallback(
//         onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
//             dd('ad onAdShowedFullScreenContent.'),
//         onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
//           dd('$ad onAdDismissedFullScreenContent.');
//           ad.dispose();
//           rewardedInterstitialAd = null;
//           createRewardedInterstitialAd();
//           callback(rewardItem);
//         },
//         onAdFailedToShowFullScreenContent:
//             (RewardedInterstitialAd ad, AdError error) {
//           dd('$ad onAdFailedToShowFullScreenContent: $error');
//           ad.dispose();
//           rewardedInterstitialAd = null;
//           callback(rewardItem);
//           createRewardedInterstitialAd();
//         },
//       );
//       rewardedInterstitialAd?.show(
//         onUserEarnedReward: (ad, reward) {
//           rewardItem = reward;
//           dd('$ad reward $reward');
//         },
//       );
//       rewardedInterstitialAd = null;
//     } else if (settingController.adsType.value == 'startapp' &&
//         (onlyOn == '' || onlyOn == 'startapp')) {
//       dd('startapp');
//     } else if (settingController.adsType.value == 'facebook' &&
//         (onlyOn == '' || onlyOn == 'facebook')) {}
//   }
// }

// class BannerAds extends StatelessWidget {
//   const BannerAds({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (!settingController.adsStatus.value) {
//       return const SizedBox();
//     } else if (settingController.adsType.value == 'google') {
//       return const GoogleBannerAds();
//     } else if (settingController.adsType.value == 'startapp') {
//       dd('startapp');
//     }

//     return const SizedBox();
//   }
// }

// class GoogleBannerAds extends StatefulWidget {
//   const GoogleBannerAds({Key? key}) : super(key: key);

//   @override
//   GoogleBannerAdsState createState() => GoogleBannerAdsState();
// }

// class GoogleBannerAdsState extends State<GoogleBannerAds> {
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

//     if (!_loadingAnchoredBanner && settingController.adsStatus.value) {
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
//   @override
//   Widget build(BuildContext context) {
//     if (!settingController.adsStatus.value) {
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
//   BannerAd? _bannerAd;
//   bool _bannerAdIsLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     final BannerAd? bannerAd = _bannerAd;
//     if (_bannerAdIsLoaded && bannerAd != null) {
//       return SizedBox(
//         height: bannerAd.size.height.toDouble(),
//         width: bannerAd.size.width.toDouble(),
//         child: AdWidget(ad: _bannerAd!),
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
//   @override
//   Widget build(BuildContext context) {
//     if (!settingController.adsStatus.value) {
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
//   NativeAd? _nativeAd;
//   bool _nativeAdIsLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     dd('native');
//     return (_nativeAd != null && _nativeAdIsLoaded)
//         ? Stack(
//             children: [
//               SizedBox(
//                 // width: 350,
//                 height: 350,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: AdWidget(ad: _nativeAd!),
//                 ),
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
//           backgroundColor: Colors.red,
//           style: NativeTemplateFontStyle.italic,
//           size: 16.0,
//         ),
//         primaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.white,
//           backgroundColor: Colors.blue.shade700,
//           style: NativeTemplateFontStyle.italic,
//           size: 16.0,
//         ),
//         secondaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.white,
//           backgroundColor: Colors.green.shade600,
//           style: NativeTemplateFontStyle.bold,
//           size: 16.0,
//         ),
//         tertiaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.brown,
//           backgroundColor: Colors.amber,
//           style: NativeTemplateFontStyle.normal,
//           size: 16.0,
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
