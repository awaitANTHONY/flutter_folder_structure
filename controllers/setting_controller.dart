import 'dart:io';
import '/services/api_services.dart';
import '/services/vpn_service.dart';
import '/utils/helpers.dart';
import '/views/screens/parent_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '/models/setting.dart';

class SettingController extends GetxController {
  var isLoading = true.obs;
  var settings = Settings().obs;
  var adCount = 0.obs;
  var bannerPlacementId = ''.obs;
  var interstitialPlacementId = ''.obs;
  var promotionSliderIndex = 0.obs;
  var showRating = true.obs;
  var appPublishingControl = true.obs;
  var isDontShow = false.obs;
  RxBool notification = true.obs;
  RxInt sliderIndex = 0.obs;

  loadData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var vpnResult = await CheckVpnConnection.isVpnActive();
    if (connectivityResult != ConnectivityResult.none && !vpnResult) {
      try {
        var response = await ApiService.loadSettings();
        if (response.status == true) {
          store(response);

          // if (authController.getToken() != '') {
          //   authController.loadUser();
          // }
          Get.offAll(
            () => const ParentScreen(page: 0),
          );
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

    var quickSetting = setting.settings;

    settings.value = setting.settings!;
    bannerPlacementId.value = Platform.isAndroid
        ? quickSetting?.androidBannerAddCode ?? ''
        : quickSetting?.iosBannerAddCode ?? '';
    interstitialPlacementId.value = Platform.isAndroid
        ? quickSetting?.androidInterstitialAddCode ?? ''
        : quickSetting?.iosInterstitialAddCode ?? '';

    if (Platform.isAndroid) {
      appPublishingControl.value =
          (quickSetting?.androidLiveControl) == 'off' ? false : true;
    } else {
      appPublishingControl.value =
          (quickSetting?.iosLiveControl) == 'off' ? false : true;
    }

    debugPrint(bannerPlacementId.value.toString());
    debugPrint(interstitialPlacementId.value.toString());
    debugPrint(appPublishingControl.value.toString());
    debugPrint(packageInfo.buildNumber.toString());
  }

  bool showAd() {
    var setting = settings.value;

    if (Platform.isAndroid) {
      if (setting.androidAdsStatus != 'off') {
        adCount.value = adCount.value + 1;
        if (adCount.value == int.parse(setting.androidAdsControl ?? '5')) {
          adCount.value = 0;
          return true;
        }
      }
    } else {
      if (setting.iosAdsStatus != 'off') {
        adCount.value = adCount.value + 1;
        if (adCount.value == int.parse(setting.iosAdsControl ?? '5')) {
          adCount.value = 0;
          return true;
        } else {}
      }
    }
    return false;
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

  changeNotificationStatus() async {
    var box = GetStorage();
    box.write('notification', !notification.value);
    notification.value = !notification.value;
  }
}
