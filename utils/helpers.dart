import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import '/consts/consts.dart';

getHeight(context, percentage) {
  double height = MediaQuery.of(context).size.height;
  return height * percentage / 100;
}

getWidth(context, percentage) {
  double width = MediaQuery.of(context).size.width;
  return width * percentage / 100;
}

launchURL(url) async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    dd('Could not launch $uri');
  }
}

showToast(String message, [ToastGravity gravity = ToastGravity.BOTTOM]) {
  if (message != '') {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey.shade800,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

showSnackBar(String message, [callback, int duration = 5]) {
  if (!kDebugMode && message == 'Server error! Please try again.') {
    return;
  }
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.grey[800],
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: duration),
    action: callback != null
        ? SnackBarAction(
            label: 'Refresh',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
              callback();
            },
          )
        : null,
  );

  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}

datePicker(
    {required DateTime initialDate,
    required Null Function(DateTime date) onChange}) async {
  final DateTime? date = await showDatePicker(
    context: Get.context!,
    initialDate: initialDate,
    firstDate: DateTime.now().add(const Duration(days: -30)),
    lastDate: DateTime.now().add(const Duration(days: 30)),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );

  if (date != null) {
    onChange(date);
  }
}

Widget cachedNetworkImage(
  String imageUrl, {
  double? height = double.infinity,
  double? width = double.infinity,
  BoxFit fit = BoxFit.fill,
  Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
  Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder,
  Widget Function(BuildContext, String, dynamic)? errorWidget,
  Widget Function(BuildContext, String)? placeholder,
  bool hide = true,
}) {
  // return Image.asset(
  //   'assets/images/default-team.png',
  //   height: height,
  //   width: width,
  //   fit: fit,
  // );

  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: height,
    width: width,
    fit: fit,
    imageBuilder: imageBuilder,
    errorWidget: errorWidget ??
        (context, url, error) {
          return Center(
            child: Image.asset(
              'assets/images/default.png',
              height: height,
              width: width,
              fit: fit,
            ),
          );
        },
    // progressIndicatorBuilder: progressIndicatorBuilder ?? null,
    placeholder: placeholder ??
        (context, url) {
          return SizedBox(
            height: height,
            width: width,
            child: Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        },
  );
}

// initNotification({required Null Function(RemoteMessage message) onOpen}) async {
//   dd('initNotification');

//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );

//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     dd('User granted permission');
//   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//     dd('User granted provisional permission');
//   } else {
//     dd('User declined or has not accepted permission');
//   }

//   //dd(await FirebaseMessaging.instance.getToken());
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     onOpen(message);
//   });

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     dd(message.notification?.title);
//   });
// }

Future<String> getToken() {
  return Future.value('');
}

readStorage(key) {
  var box = GetStorage();
  return box.read(key);
}

writeStorage(key, value) {
  var box = GetStorage();
  box.write(key, value);
}

dd(object, {isShowLog = false}) {
  if (kDebugMode) {
    if (!isShowLog) {
      print(object);
    } else {
      log(object.toString());
    }
  }
}
