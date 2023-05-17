import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '/services/api_services.dart';
import '/consts/consts.dart';
import '/services/vpn_service.dart';
import '/utils/helpers.dart';
import '/views/screens/parent_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '/models/setting.dart';

class SettingController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<SettingData> settings = SettingData().obs;
  RxInt adCount = 0.obs;
  RxString adsType = 'google'.obs;
  RxBool adsStatus = true.obs;
  RxString applicationId = ''.obs;
  RxString appopenPlacementId = ''.obs;
  RxString bannerPlacementId = ''.obs;
  RxString interstitialPlacementId = ''.obs;
  RxString nativePlacementId = ''.obs;
  RxInt sliderIndex = 0.obs;
  Rxn<PackageInfo> appInfo = Rxn<PackageInfo>().obs();

  loadData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var vpnResult = await CheckVpnConnection.isVpnActive();
    if (connectivityResult != ConnectivityResult.none && !vpnResult) {
      try {
        String url = '${AppConsts.baseUrl}${AppConsts.settings}';
        Map<String, String> headers = {
          'X-API-KEY': AppConsts.apiKey,
        };
        Map<String, dynamic> body = {};
        var response = await ApiService.post(
          url,
          headers: headers,
          body: body,
        );

        var jsonString = response.body;
        var responseModel = Setting.fromJson(jsonDecode(jsonString));

        if (responseModel.status == true) {
          store(responseModel);
          //onInitApp(responseModel.data!.androidApplicationId!);
          await Future.delayed(2.seconds);

          Get.offAll(() => const ParentScreen(page: 0));
        } else {
          showSnackBar('Server Error! Please Try again.');
        }
      } catch (e) {
        showSnackBar(e.toString());
      }
    } else {
      showSnackBar('No internet connection please try again!');
    }
  }

  void store(Setting setting) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var quickSetting = setting.data!;

    settings.value = setting.data!;

    adsStatus.value = Platform.isAndroid
        ? quickSetting.androidEnableAds != '0'
        : quickSetting.iosEnableAds != '0';
    appopenPlacementId.value = Platform.isAndroid
        ? quickSetting.androidAppopenAdCode ?? ''
        : quickSetting.iosAppShareLink ?? '';
    bannerPlacementId.value = Platform.isAndroid
        ? quickSetting.androidBannerAdCode ?? ''
        : quickSetting.iosBannerAdCode ?? '';
    interstitialPlacementId.value = Platform.isAndroid
        ? quickSetting.androidInterstitialAdCode ?? ''
        : quickSetting.iosInterstitialAdCode ?? '';
    nativePlacementId.value = Platform.isAndroid
        ? quickSetting.androidNativeAdCode ?? ''
        : quickSetting.iosNativeAdCode ?? '';

    appInfo.value = packageInfo;

    dd(appopenPlacementId.value);
    dd(bannerPlacementId.value);
    dd(interstitialPlacementId.value);
    dd(nativePlacementId.value);
    dd(appInfo.value);
  }

  bool showAd() {
    var setting = settings.value;

    if (Platform.isAndroid) {
      if (setting.androidEnableAds != '0') {
        adCount.value = adCount.value + 1;
        if (adCount.value ==
            int.parse(setting.androidInterstitialAdClick ?? '5')) {
          adCount.value = 0;
          return true;
        }
      }
    } else {
      if (setting.iosEnableAds != '0') {
        adCount.value = adCount.value + 1;
        if (adCount.value == int.parse(setting.iosInterstitialAdClick ?? '5')) {
          adCount.value = 0;
          return true;
        } else {}
      }
    }
    return false;
  }

  static const platform = MethodChannel('await/xml');
  Future<void> onInitApp(id) async {
    // if (Platform.isAndroid) {
    //   try {
    //     final String result = await platform.invokeMethod('updateAppId', {
    //       'appId': id,
    //     });
    //     dd('RESULT -> $result');
    //   } on PlatformException catch (e) {
    //     dd(e);
    //   }
    // }

    // WidgetsFlutterBinding.ensureInitialized();
    // MobileAds.instance.updateRequestConfiguration(
    //   RequestConfiguration(
    //     tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
    //     testDeviceIds: <String>[
    //       "8FECD77B9178A2514A9BFB8F6DB2C99F",
    //     ],
    //   ),
    // );
  }

  // void checkVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //   var versionCode = packageInfo.buildNumber;
  //   var settings = _settingController.settings.value;

  //   var apiVersionCode;
  //   var forceUpdate;
  //   var versionName;
  //   var message;
  //   var buttomText;
  //   var actionUrl;

  //   if (Platform.isAndroid) {
  //     apiVersionCode = int.parse(settings.androidVersionCode ?? '1');
  //     forceUpdate = settings.androidForceUpdate ?? 'no';
  //     versionName = settings.androidVersionName ?? '';
  //     message = settings.androidDescription ?? '';
  //     buttomText = settings.androidButtonText ?? '';
  //     actionUrl = settings.androidAppUrl ?? '';
  //   } else {
  //     apiVersionCode = int.parse(settings.iosVersionCode ?? '1');
  //     forceUpdate = settings.iosForceUpdate ?? 'no';
  //     versionName = settings.iosVersionName ?? '';
  //     message = settings.iosDescription ?? '';
  //     buttomText = settings.iosButtonText ?? '';
  //     actionUrl = settings.iosAppUrl ?? '';
  //   }

  //   if (apiVersionCode > int.parse(versionCode)) {
  //     updateDailog(
  //       context,
  //       forceUpdate: forceUpdate,
  //       versionName: versionName,
  //       message: message,
  //       buttomText: buttomText,
  //       actionUrl: actionUrl,
  //     );
  //   } else {
  //     // Get.offAll(
  //     //   () => PreParentScreen(page: 0),
  //     // );
  //   }
  // }

  // changeNotificationStatus() async {
  //   var box = GetStorage();
  //   box.write('notification', !notification.value);
  //   notification.value = !notification.value;
  // }

  @override
  void onInit() {
    super.onInit();

    loadData();
  }
}
