import 'dart:io';
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

  changeNotificationStatus() async {
    var box = GetStorage();
    box.write('notification', !notification.value);
    notification.value = !notification.value;
  }
}
