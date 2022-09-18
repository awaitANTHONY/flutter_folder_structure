import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '/consts/consts.dart';
import '/controllers/setting_controller.dart';
import '/views/screens/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

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
        //Get.put(AuthController());
      },
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  SettingController settingController = Get.find();

  var hasNotification = false;

  late Map arguments;

  @override
  void initState() {
    super.initState();

    settingController.loadData();
  }

  // void initNotification() async {
  //   if (kDebugMode) {
  //     print('initNotification');
  //     //print(await FirebaseMessaging.instance.getToken());
  //   }

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     var data = message.data;

  //     if (data['type'] == 'content') {
  //       arguments = {
  //         'title': data['title'],
  //         'id': data['id'],
  //         'coverImage': data['image'],
  //         'content_type': data['content_type'],
  //       };
  //       hasNotification = true;
  //     }

  //     if (data['type'] == 'url') {
  //       launchURL(data['action_url']);
  //     }

  //     if (data['type'] == 'inApp') {}
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (kDebugMode) {
  //       print(message.notification?.title);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreen(),
    );
  }
}
