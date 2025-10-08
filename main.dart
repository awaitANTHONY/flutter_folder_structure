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

  runApp(
    GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: const Main(),
    ),
  );
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
              backgroundColor: AppColors.primary,
              surfaceTintColor: AppColors.primary,
              elevation: 1,
              iconTheme: IconThemeData(size: 20.sp, color: AppColors.white),
              actionsIconTheme: IconThemeData(
                size: 20.sp,
                color: AppColors.white,
              ),
              shadowColor: Colors.black.withValues(alpha: .2),
            ),
            navigationBarTheme: NavigationBarThemeData(
              elevation: 1,
              backgroundColor: AppColors.background,
              indicatorColor: AppColors.primary.withValues(alpha: 0.8),
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(color: AppColors.blackLess),
              ),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(color: Colors.white, size: 22.sp);
                }
                return IconThemeData(color: AppColors.blackLess, size: 22.sp);
              }),
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.background,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.blackLess,
              selectedLabelStyle: AppStyles.semiBold.copyWith(fontSize: 12.sp),
              unselectedLabelStyle: AppStyles.medium.copyWith(fontSize: 12.sp),
              type: BottomNavigationBarType.fixed,
              selectedIconTheme: IconThemeData(
                size: 22.sp,
                color: AppColors.primary,
              ),
              unselectedIconTheme: IconThemeData(
                size: 20.sp,
                color: AppColors.blackLess,
              ),
            ),

            fontFamily: GoogleFonts.inter().fontFamily,
            textTheme: TextTheme(
              titleMedium: AppStyles.semiBold,
              titleLarge: AppStyles.bold,
              bodySmall: AppStyles.small,
              bodyMedium: AppStyles.medium,
              bodyLarge: AppStyles.large,

              displaySmall: AppStyles.small.copyWith(
                color: AppColors.whiteLess,
              ),
              displayMedium: AppStyles.medium.copyWith(
                color: AppColors.whiteLess,
              ),
              displayLarge: AppStyles.large.copyWith(color: AppColors.white),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            iconTheme: IconThemeData(size: 20.sp, color: AppColors.white),
          ),
          themeMode: ThemeMode.light,
          onInit: () {
            Get.put(SettingController(), permanent: true);
          },
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
