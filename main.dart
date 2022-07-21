import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controllers/auth_controller.dart';
import '/consts/consts.dart';
import '/views/screens/parent_screen.dart';
import '/controllers/setting_controller.dart';
import '/services/api_services.dart';
import '/services/vpn_service.dart';
import '/utils/helpers.dart';
import '/views/screens/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        primaryColor: AppColors.primaryColor,
        fontFamily: GoogleFonts.hind().fontFamily,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.primaryColor,
        ),
      ),
      title: AppTexts.appName,
      onGenerateRoute: (settings) {
        final routes = <String, WidgetBuilder>{
          // PsScheduleScreen.route: (BuildContext context) =>
          //     PsScheduleScreen(settings.arguments),
        };
        WidgetBuilder? builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder!(context));
      },
      onInit: () {
        Get.put(SettingController());
        Get.put(AuthController());
      },
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthController authController = Get.find();
  SettingController settingController = Get.find();

  var hasNotification = false;

  late Map arguments;

  @override
  void initState() {
    super.initState();
    initNotification();

    Future.delayed(2.seconds, () {
      loadData();
    });
  }

  void initNotification() async {
    if (kDebugMode) {
      print('initNotification');
      //print(await FirebaseMessaging.instance.getToken());
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var data = message.data;

      if (data['type'] == 'content') {
        arguments = {
          'title': data['title'],
          'id': data['id'],
          'coverImage': data['image'],
          'content_type': data['content_type'],
        };
        hasNotification = true;
      }

      if (data['type'] == 'url') {
        launchURL(data['action_url']);
      }

      if (data['type'] == 'inApp') {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print(message.notification?.title);
      }
    });
  }

  loadData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var vpnResult = await CheckVpnConnection.isVpnActive();
    if (connectivityResult != ConnectivityResult.none && !vpnResult) {
      try {
        var response = await ApiService.loadSettings();
        if (response.status == true) {
          settingController.store(response);

          if (authController.getToken() != '') {
            authController.loadUser();
          }
          Get.offAll(
            () => const ParentScreen(page: 0),
          );
        } else {
          showSnackBar('Server Error! Please Try again.');
        }
      } catch (e) {
        showSnackBar(e.toString());
      }
    } else {
      showSnackBar('No internet connection please try again!');
    }
  }

  // void checkVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //   var versionCode = packageInfo.buildNumber;
  //   var settings = _settingController.settings.value;

  //   var apiVersionCode;
  //   var forceUpdate;
  //   var versionName;
  //   var message;
  //   var buttomText;
  //   var actionUrl;

  //   if (Platform.isAndroid) {
  //     apiVersionCode = int.parse(settings.androidVersionCode ?? '1');
  //     forceUpdate = settings.androidForceUpdate ?? 'no';
  //     versionName = settings.androidVersionName ?? '';
  //     message = settings.androidDescription ?? '';
  //     buttomText = settings.androidButtonText ?? '';
  //     actionUrl = settings.androidAppUrl ?? '';
  //   } else {
  //     apiVersionCode = int.parse(settings.iosVersionCode ?? '1');
  //     forceUpdate = settings.iosForceUpdate ?? 'no';
  //     versionName = settings.iosVersionName ?? '';
  //     message = settings.iosDescription ?? '';
  //     buttomText = settings.iosButtonText ?? '';
  //     actionUrl = settings.iosAppUrl ?? '';
  //   }

  //   if (apiVersionCode > int.parse(versionCode)) {
  //     updateDailog(
  //       context,
  //       forceUpdate: forceUpdate,
  //       versionName: versionName,
  //       message: message,
  //       buttomText: buttomText,
  //       actionUrl: actionUrl,
  //     );
  //   } else {
  //     // Get.offAll(
  //     //   () => PreParentScreen(page: 0),
  //     // );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: const SplashScreen(),
    );
  }
}
