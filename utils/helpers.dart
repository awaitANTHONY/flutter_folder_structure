import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

import '/consts/consts.dart';

Future<void> launchURL(
  String url, {
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: mode)) {
    dd('Could not launch $uri');
  }
}

enum ToastType { success, error, warning }

void showToast(String message, {ToastType type = ToastType.success}) {
  if (message != '' && !message.contains('DioException [unknown]')) {
    BuildContext context = Get.context!;
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(milliseconds: 3000),
      autoDismiss: true,
      builder: (context) {
        Color backgroundColor = Colors.green;
        Color color = Colors.white;
        String title = 'Success';
        IconData icon = Icons.auto_awesome_sharp;

        if (type == ToastType.error) {
          backgroundColor = Colors.red.shade500;
          title = 'Error';
          icon = Icons.error;
        } else if (type == ToastType.warning) {
          backgroundColor = Colors.yellow.shade700;
          title = 'Warning';
          icon = Icons.warning;
        } else {
          backgroundColor = Colors.green;
          title = 'Success';
          icon = Icons.auto_awesome_sharp;
        }
        return ToastCard(
          color: backgroundColor,
          shadowColor: Colors.black12,
          leading: Icon(icon, size: 30, color: color),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: color,
            ),
          ),
          subtitle: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: color,
            ),
          ),
          trailing: InkWell(
            onTap: () {
              DelightToastBar.removeAll();
            },
            child: Icon(Icons.close, size: 28, color: color),
          ),
        );
      },
    ).show(context);
  }
}

void showSnackBar(String message, [callback, int duration = 5]) {
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

Future<void> datePicker({
  required DateTime initialDate,
  DateTime? firstDate,
  required Null Function(DateTime date) onChange,
  bool disablePreviousDates = false,
}) async {
  final DateTime? date = await showDatePicker(
    context: Get.context!,
    initialDate: initialDate,
    firstDate: disablePreviousDates
        ? initialDate
        : firstDate ?? DateTime.now().add(const Duration(days: -30)),
    lastDate: DateTime.now().add(const Duration(days: 30)),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: child!,
      );
    },
  );

  if (date != null) {
    onChange(date);
  }
}

Future<void> timePicker({
  required TimeOfDay initialTime,
  required Null Function(TimeOfDay time) onChange,
  bool use24HourFormat = true,
}) async {
  final TimeOfDay? time = await showTimePicker(
    context: Get.context!,
    initialTime: initialTime,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: use24HourFormat),
          child: child!,
        ),
      );
    },
  );

  if (time != null) {
    onChange(time);
  }
}

String timeFormat(String time) {
  try {
    DateTime parsedTime;

    if (time.contains(':') && time.split(':').length >= 2) {
      if (time.toUpperCase().contains('am') || time.toString().contains('pm')) {
        parsedTime = DateFormat.jm().parse(time);
      } else {
        if (time.split(':').length == 3) {
          parsedTime = DateFormat('HH:mm:ss').parse(time);
        } else {
          parsedTime = DateFormat('HH:mm').parse(time);
        }
      }
    } else {
      parsedTime = DateFormat.jm().parse(time);
    }

    final formattedTime = DateFormat('HH:mm').format(parsedTime);
    return formattedTime;
  } catch (e) {
    dd(e.toString());
    return time;
  }
}

String dateTimeFormat({dynamic dateTime, String format = 'MMM d, y hh:mm a'}) {
  try {
    if (dateTime is DateTime) {
      return DateFormat(format).format(dateTime);
    } else if (dateTime is String) {
      return DateFormat(format).format(DateTime.parse(dateTime));
    }
  } catch (e) {
    dd(e);
  }
  return dateTime;
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;

  String minutesPart = minutes > 0 ? '$minutes min' : '';
  String secondsPart = remainingSeconds > 0 ? '$remainingSeconds secs' : '';

  if (minutesPart.isNotEmpty && secondsPart.isNotEmpty) {
    return '$minutesPart $secondsPart';
  } else if (minutesPart.isNotEmpty) {
    return minutesPart;
  } else {
    return secondsPart;
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
    errorWidget:
        errorWidget ??
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
    placeholder:
        placeholder ??
        (context, url) {
          return SizedBox(
            height: height,
            width: width,
            child: Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(color: AppColors.primary),
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

void copyClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSnackBar('Copied to clipboard');
}

Future<String> getToken() {
  return Future.value('');
}

var l = [];
String lang(String text) {
  // l.add('"$text":"$text"');
  // dd(l, isShowLog: true);
  return text.tr;
}

dynamic readStorage(String key) {
  var box = GetStorage();
  return box.read(key);
}

void writeStorage(String key, dynamic value) {
  var box = GetStorage();
  box.write(key, value);
}

void dd(dynamic object, {bool isShowLog = false, bool doCopy = false}) {
  if (kDebugMode) {
    if (!isShowLog) {
      print(object);
    } else {
      log(object.toString());
    }
  }

  if (doCopy) {
    Clipboard.setData(ClipboardData(text: object.toString()));
  }
}
