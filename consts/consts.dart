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

extension SpaceXY on double {
  SizedBox get spaceX => SizedBox(width: this);
  SizedBox get spaceY => SizedBox(height: this);
}

extension EdgeInsetsTBXY on double {
  EdgeInsets get edgeT => EdgeInsets.only(top: this);
  EdgeInsets get edgeB => EdgeInsets.only(bottom: this);
  EdgeInsets get edgeX => EdgeInsets.symmetric(horizontal: this);
  EdgeInsets get edgeY => EdgeInsets.symmetric(vertical: this);
}
