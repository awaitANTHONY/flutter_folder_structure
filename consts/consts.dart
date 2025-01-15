export './app_colors.dart';
export './app_consts.dart';
export './app_styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/setting_controller.dart';

SettingController settingController = Get.find();

extension SpaceXY on num {
  SizedBox get spaceX => SizedBox(width: toDouble());
  SizedBox get spaceY => SizedBox(height: toDouble());
}

extension EdgeInsetsTBXY on num {
  EdgeInsets get edgeT => EdgeInsets.only(top: toDouble());
  EdgeInsets get edgeB => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get edgeL => EdgeInsets.only(left: toDouble());
  EdgeInsets get edgeR => EdgeInsets.only(right: toDouble());
  EdgeInsets get edgeX => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get edgeY => EdgeInsets.symmetric(vertical: toDouble());
}
