// import 'dart:io';

// import 'package:flutter/services.dart';

// import '/consts/consts.dart';
// import '/utils/helpers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// int _numInterstitialLoadAttempts = 0;

// class AdsService {
//   static InterstitialAd? interstitialAd;
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );

//   static List<String> testDeviceIds = [
//     "e329e8b6ec873f1c51924b0e3c6687ac",
//   ];

//   // for Consent
//   static List<String> testIdentifiers = [
//     "B5A99A97671F816D64C05B7460B39A05",
//   ];
//   static const platform = MethodChannel('rootdevs.com/xml');
//   static init() async {
//     await Future.delayed(1.seconds);
//     if (!settingController.adsStatus.value) return;

//     if (Platform.isAndroid) {
//       try {
//         final String result = await platform.invokeMethod('updateAppId', {
//           'appId': settingController.settings.value.androidAd!.applicationId,
//         });
//         dd('RESULT -> $result');
//       } on PlatformException catch (e) {
//         dd(e);
//       }

//       //
//       bool newOpen = readStorage('newOpen') ?? true;
//       if (!newOpen) {
//         MobileAds.instance.updateRequestConfiguration(
//           RequestConfiguration(
//             tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
//             testDeviceIds: testDeviceIds,
//           ),
//         );
//         await Future.delayed(5.seconds);
//         requestConsent();
//       } else {
//         settingController.adsStatus.value = false;
//         writeStorage('newOpen', false);
//       }
//     } else {
//       MobileAds.instance.updateRequestConfiguration(
//         RequestConfiguration(
//           tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
//           testDeviceIds: testDeviceIds,
//         ),
//       );
//       await Future.delayed(5.seconds);
//       requestConsent();
//     }
//   }

//   //-------Consent
//   static Future<ConsentStatus> getConsentStatus() async {
//     var status = await ConsentInformation.instance.getConsentStatus();
//     return status;
//   }

//   static void requestConsent() async {
//     ConsentDebugSettings debugSettings = ConsentDebugSettings(
//       debugGeography: DebugGeography.debugGeographyEea,
//       testIdentifiers: testIdentifiers,
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
//   //-------- END

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
// }

// class BannerAds extends StatelessWidget {
//   const BannerAds({super.key});

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
//   const GoogleBannerAds({super.key});

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
//     return (_nativeAd != null && _nativeAdIsLoaded)
//         ? Stack(
//             children: [
//               SizedBox(
//                 height: 372,
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
//           style: NativeTemplateFontStyle.monospace,
//           size: 14,
//         ),
//         primaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.black,
//           backgroundColor: Colors.white,
//           style: NativeTemplateFontStyle.bold,
//           size: 14,
//         ),
//         secondaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.black54,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.italic,
//           size: 13,
//         ),
//         tertiaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.brown,
//           backgroundColor: Colors.white,
//           style: NativeTemplateFontStyle.normal,
//           size: 15,
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
