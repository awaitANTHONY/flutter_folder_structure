export './app_assets.dart';
export './app_colors.dart';
export './app_consts.dart';
export './app_sizes.dart';
export './app_styles.dart';
export './app_texts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/setting_controller.dart';

SettingController settingController = Get.find();

extension EdgeInsetsTBXY on num {
  EdgeInsets get edgeT => EdgeInsets.only(top: toDouble());
  EdgeInsets get edgeB => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get edgeL => EdgeInsets.only(top: toDouble());
  EdgeInsets get edgeR => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get edgeX => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get edgeY => EdgeInsets.symmetric(vertical: toDouble());
}
