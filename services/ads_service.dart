// // ignore_for_file: library_private_types_in_public_api

// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';
// import '/consts/AppAssets.dart';
// import '/consts/AppSizes.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:startapp_sdk/startapp.dart';
// import '/controllers/setting_controller.dart';
// import '/utils/helpers.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// int _numInterstitialLoadAttempts = 0;

// class AdsService {
//   static SettingController controller = Get.find<SettingController>();

//   static StartAppSdk startAppSdk = StartAppSdk();
//   static StartAppInterstitialAd? startAppInterstitialAd;
//   static VoidCallback startAppCallback = () {};

//   static InterstitialAd? interstitialAd;
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );

//   static void createInterstitialAd([callback]) async {
//     if (!controller.adsStatus.value || controller.isSubscribed.value) {
//       return;
//     }
//     if (controller.adsType.value == 'google') {
//       InterstitialAd.load(
//         adUnitId: controller.interstitialPlacementId.value,
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
//     } else if (controller.adsType.value == 'startapp') {
//       startAppSdk
//           .loadInterstitialAd(
//               onAdHidden: () {
//                 startAppCallback();
//               },
//               prefs: const StartAppAdPreferences(adTag: 'home_screen'))
//           .then((interstitialAd) {
//         startAppInterstitialAd = interstitialAd;
//       }).onError<StartAppException>((ex, stackTrace) {
//         debugPrint("Error loading Interstitial ad: ${ex.message}");
//       }).onError((error, stackTrace) {
//         debugPrint("Error loading Interstitial ad: $error");
//       });
//       dd('startapp');
//     } else if (controller.adsType.value == 'facebook') {}
//   }

//   static void showInterstitialAd(callback,
//       {adControl = true, onlyOn = ''}) async {
//     if (!controller.adsStatus.value || controller.isSubscribed.value) {
//       callback();
//       return;
//     }
//     if (!controller.showAd() && adControl) {
//       callback();
//       return;
//     }

//     if (controller.adsType.value == 'google' &&
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
//     } else if (controller.adsType.value == 'startapp' &&
//         (onlyOn == '' || onlyOn == 'startapp')) {
//       if (startAppInterstitialAd == null) {
//         dd('Warning: attempt to show interstitial before loaded.');

//         callback();

//         return;
//       }

//       startAppInterstitialAd?.show().then((shown) {
//         if (shown) {
//           startAppInterstitialAd = null;
//           createInterstitialAd(callback);
//         }
//         startAppCallback = () {
//           callback();
//         };
//         return null;
//       }).onError((error, stackTrace) {
//         debugPrint("Error showing Interstitial ad: $error");
//       });
//       dd('startapp');
//     } else if (controller.adsType.value == 'facebook' &&
//         (onlyOn == '' || onlyOn == 'facebook')) {}
//   }
// }

// class BannerAds extends StatelessWidget {
//   BannerAds({Key? key}) : super(key: key);
//   final SettingController settingController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (!settingController.adsStatus.value ||
//           settingController.isSubscribed.value) {
//         return const SizedBox();
//       } else if (settingController.adsType.value == 'google') {
//         return const GoogleBannerAds();
//       } else if (settingController.adsType.value == 'startapp') {
//         return const StartappBannerAds();
//       }

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
//   const NativeAds({Key? key}) : super(key: key);

//   @override
//   State<NativeAds> createState() => _NativeAdsState();
// }

// class _NativeAdsState extends State<NativeAds> {
//   final SettingController settingController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     if (!settingController.adsStatus.value ||
//         settingController.isSubscribed.value) {
//       return const SizedBox();
//     } else if (settingController.adsType.value == 'google') {
//       return const InlineAds();
//     } else if (settingController.adsType.value == 'startapp') {
//       return const StartappNativeAds();
//     }

//     return const SizedBox();
//   }
// }

// class InlineAds extends StatefulWidget {
//   const InlineAds({Key? key}) : super(key: key);

//   @override
//   InlineAdsState createState() => InlineAdsState();
// }

// class InlineAdsState extends State<InlineAds> {
//   SettingController settingController = Get.find();
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

// class StartappBannerAds extends StatefulWidget {
//   const StartappBannerAds({Key? key}) : super(key: key);

//   @override
//   StartappBannerAdsState createState() => StartappBannerAdsState();
// }

// class StartappBannerAdsState extends State<StartappBannerAds> {
//   StartAppBannerAd? bannerAd;
//   StartAppSdk startAppSdk = StartAppSdk();
//   static SettingController controller = Get.find<SettingController>();
//   @override
//   void initState() {
//     super.initState();

//     if (Platform.isAndroid) {
//       if (controller.settings.value.androidClickControl != 'off') {
//         startAppSdk
//             .loadBannerAd(StartAppBannerType.BANNER,
//                 prefs: const StartAppAdPreferences(adTag: 'primary'))
//             .then((bannerAd) {
//           setState(() {
//             this.bannerAd = bannerAd;
//           });
//         }).onError<StartAppException>((ex, stackTrace) {
//           debugPrint("Error loading Banner ad: ${ex.message}");
//         }).onError((error, stackTrace) {
//           debugPrint("Error loading Banner ad: $error");
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: bannerAd != null ? StartAppBanner(bannerAd!) : const SizedBox(),
//     );
//   }
// }

// class StartappNativeAds extends StatefulWidget {
//   const StartappNativeAds({Key? key}) : super(key: key);

//   @override
//   _StartappNativeAdsState createState() => _StartappNativeAdsState();
// }

// class _StartappNativeAdsState extends State<StartappNativeAds> {
//   StartAppNativeAd? nativeAd;
//   static StartAppSdk startAppSdk = StartAppSdk();
//   static SettingController controller = Get.find<SettingController>();

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       if (controller.settings.value.androidClickControl != 'off') {
//         startAppSdk
//             .loadNativeAd(
//                 prefs: const StartAppAdPreferences(adTag: 'game_over'))
//             .then((nativeAd) {
//           setState(() {
//             this.nativeAd = nativeAd;
//           });
//         }).onError<StartAppException>((ex, stackTrace) {
//           debugPrint("Error loading Native ad: ${ex.message}");
//         }).onError((error, stackTrace) {
//           debugPrint("Error loading Native ad: $error");
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return nativeAd != null
//         ? Container(
//             margin: const EdgeInsets.only(left: 8, right: 8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: StartAppNative(
//               nativeAd!,
//               (context, setState, nativeAd) {
//                 return startAppStartappNativeAdsWidget(nativeAd);
//               },
//               height: 160,
//             ),
//           )
//         : const SizedBox();
//   }

//   Widget startAppStartappNativeAdsWidget(StartAppNativeAd nativeAd) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CachedNetworkImage(
//                 imageUrl: nativeAd.imageUrl ?? '',
//                 height: 100,
//                 width: 100,
//                 errorWidget: (context, url, error) {
//                   return Image.asset(AppAssets.loader);
//                 },
//                 placeholder: (context, url) => Container(
//                   alignment: Alignment.center,
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: SizedBox(
//                     height: 2 * screenSize / 100,
//                     width: 2 * screenSize / 100,
//                     child: Image.asset(AppAssets.loader),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         nativeAd.title ?? '',
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontSize: AppSizes.font13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       Text(
//                         '${cutString(nativeAd.description, 50)}',
//                         maxLines: 2,
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       RatingStars(
//                         value: nativeAd.rating!,
//                         starBuilder: (index, color) => Icon(
//                           Icons.star,
//                           color: color,
//                         ),
//                         starCount: 5,
//                         starSize: 20,
//                         valueLabelColor: const Color(0xff9b9b9b),
//                         valueLabelTextStyle: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 12.0),
//                         valueLabelRadius: 10,
//                         maxValue: 5,
//                         starSpacing: 2,
//                         maxValueVisibility: true,
//                         valueLabelVisibility: false,
//                         animationDuration: const Duration(milliseconds: 1000),
//                         valueLabelPadding: const EdgeInsets.symmetric(
//                             vertical: 1, horizontal: 8),
//                         valueLabelMargin: const EdgeInsets.only(right: 8),
//                         starOffColor: const Color(0xffe7e8ea),
//                         starColor: HexColor('#FECC09'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//           margin: const EdgeInsets.symmetric(horizontal: 8),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(0),
//             color: HexColor('#D9E5F9'),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 0.1,
//                 spreadRadius: 0.0,
//                 offset: Offset(0, 0),
//               )
//             ],
//           ),
//           child: Text(
//             nativeAd.callToAction ?? ''.toUpperCase(),
//             style: TextStyle(
//               fontSize: 16,
//               color: HexColor('#0550E5'),
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }

//   String? cutString(String? input, int length) {
//     if (input != null && input.length > length) {
//       return '${input.substring(0, length)}...';
//     }
//     return input;
//   }
// }
