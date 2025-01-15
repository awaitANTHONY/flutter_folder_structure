import 'package:findatable/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

permissionDialog({
  required Permission permission,
  required Null Function() callback,
}) {
  String name = (permission.toString().replaceAll('Permission.', ''));
  Alert(
    //closeIcon: const Text(''),
    style: AlertStyle(
      backgroundColor: AppColors.white,
      overlayColor: Colors.black26,
      animationType: AnimationType.grow,
      descStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.center,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      alertAlignment: Alignment.center,
    ),
    context: Get.context!,
    desc: "Please enable ${name.toUpperCase()} permission!",
    image: Padding(
      padding: EdgeInsets.all(20.sp),
      child: Image.asset(
        'assets/images/permission.png',
        height: 100.sp,
        width: 100.sp,
      ),
    ),
    buttons: [
      DialogButton(
        color: AppColors.transparent,
        splashColor: Colors.transparent,
        onPressed: () => Get.back(),
        border: Border.all(
          color: AppColors.primary,
          width: 1.2,
        ),
        radius: BorderRadius.circular(20.sp),
        child: Text(
          "Cancel".tr,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ),
      DialogButton(
        color: AppColors.primary,
        splashColor: Colors.transparent,
        onPressed: () async {
          callback();
        },
        radius: BorderRadius.circular(20.sp),
        child: Text(
          "Enable",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ).show();
}
