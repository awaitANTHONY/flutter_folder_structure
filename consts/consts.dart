export './app_colors.dart';
export './app_consts.dart';
export './app_styles.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/setting_controller.dart';

SettingController settingController = Get.find();

bool isTablet([BuildContext? context]) {
  var shortestSide = MediaQuery.of(context ?? Get.context!).size.shortestSide;
  return shortestSide >= 600;
}
