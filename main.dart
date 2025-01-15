import 'package:findatable/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    //set app context
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 920),
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (BuildContext context, __) {
        return GetMaterialApp(
          title: AppConsts.appName,
          debugShowCheckedModeBanner: false,
          home: const App(),
          theme: ThemeData(
            colorScheme: const ColorScheme.light().copyWith(
              surface: AppColors.background,
              primary: AppColors.primary,
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.transparent,
            cardColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.background,
              surfaceTintColor: AppColors.background,
              elevation: 1,
              shadowColor: Colors.black.withOpacity(.2),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.background,
              selectedItemColor: AppColors.primary,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: AppColors.background,
              indicatorColor: AppColors.primary.withOpacity(0.8),
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(
                  color: AppColors.whiteLess,
                ),
              ),
              iconTheme: WidgetStatePropertyAll(
                IconThemeData(
                  color: AppColors.whiteLess,
                  size: 18.sp,
                ),
              ),
            ),
            fontFamily: GoogleFonts.inter().fontFamily,
            textTheme: TextTheme(
              titleMedium: AppStyles.semiBold,
              titleLarge: AppStyles.bold,
              bodySmall: AppStyles.small,
              bodyMedium: AppStyles.medium,
              bodyLarge: AppStyles.large,
              displaySmall:
                  AppStyles.small.copyWith(color: AppColors.whiteLess),
              displayMedium:
                  AppStyles.medium.copyWith(color: AppColors.whiteLess),
              displayLarge: AppStyles.large.copyWith(color: AppColors.white),
            ),
            iconTheme: IconThemeData(
              size: 20.sp,
              color: AppColors.white,
            ),
          ),
          themeMode: ThemeMode.light,
          onInit: () {},
        );
      },
    );
  }
}

//
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
