import 'package:flutter/material.dart';
import 'package:get/get.dart';

Orientation currentOrientation = MediaQuery.of(Get.context!).orientation;

var screenSize =
    currentOrientation == Orientation.portrait ? Get.height : Get.width;

class AppSizes {
  static final double size12 = 1.5 * screenSize / 100;
  static final double size13 = 1.6 * screenSize / 100;
  static final double size14 = 1.8 * screenSize / 100;
  static final double size15 = 1.9 * screenSize / 100;
  static final double size16 = 2.0 * screenSize / 100;
  static final double size18 = 2.3 * screenSize / 100;
  static final double size20 = 2.5 * screenSize / 100;
  static final double size22 = 2.8 * screenSize / 100;
  static final double size24 = 3.1 * screenSize / 100;
  static final double size26 = 3.4 * screenSize / 100;
  static final double size28 = 3.7 * screenSize / 100;
  static final double size30 = 4.0 * screenSize / 100;

  static double newSize(percentage) {
    return percentage * screenSize / 100;
  }
}
