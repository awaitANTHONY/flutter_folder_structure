import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/consts/consts.dart';

notificationDialog() {
  return showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Notification'.tr,
        style: AppStyles.heading.copyWith(
          fontSize: AppSizes.size16,
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Enable'.tr,
                style: AppStyles.text.copyWith(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                ),
              ),
              leading: Obx(() {
                return Radio(
                  value: true,
                  groupValue: settingController.notification.value,
                  onChanged: (bool? v) {
                    Navigator.pop(context);
                    settingController.changeNotificationStatus();
                  },
                );
              }),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'Disable'.tr,
                style: AppStyles.text.copyWith(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                ),
              ),
              leading: Obx(() {
                return Radio(
                  value: false,
                  groupValue: settingController.notification.value,
                  onChanged: (bool? v) {
                    Navigator.pop(context);
                    settingController.changeNotificationStatus();
                  },
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel'.tr,
            style: AppStyles.heading.copyWith(
              fontSize: AppSizes.size13,
              color: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
        ),
      ],
    ),
  );
}
