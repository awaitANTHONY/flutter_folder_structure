import '/consts/consts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/setting_controller.dart';
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
      designSize: isTablet(context)
          ? const Size(900, 1200)
          : const Size(430, 920),
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => RebuildFactors.size(old, data),
      builder: (BuildContext context, _) {
        return GetMaterialApp(
          title: AppConsts.appName,
          debugShowCheckedModeBanner: false,
          home: const App(),
          theme: _buildAppTheme(),
          darkTheme: _buildAppTheme(brightness: Brightness.dark),
          themeMode: ThemeMode.light,
          onInit: () {
            Get.put(SettingController(), permanent: true);
          },
        );
      },
    );
  }

  ThemeData _buildAppTheme({Brightness brightness = Brightness.light}) {
    final ColorScheme scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          surface: AppColors.background,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        );

    final TextTheme baseTextTheme = brightness == Brightness.light
        ? Typography.material2021(platform: TargetPlatform.android).black
        : Typography.material2021(platform: TargetPlatform.android).white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
        elevation: 1,
        scrolledUnderElevation: 2,
        iconTheme: IconThemeData(size: 20.sp, color: AppColors.white),
        actionsIconTheme: IconThemeData(size: 20.sp, color: AppColors.white),
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
        selectedIconTheme: IconThemeData(size: 22.sp, color: AppColors.primary),
        unselectedIconTheme: IconThemeData(
          size: 20.sp,
          color: AppColors.blackLess,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      iconTheme: IconThemeData(size: 20.sp, color: AppColors.white),

      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: baseTextTheme.copyWith(
        titleMedium: AppStyles.semiBold,
        titleLarge: AppStyles.bold,
        bodySmall: AppStyles.small,
        bodyMedium: AppStyles.medium,
        bodyLarge: AppStyles.large,
        displaySmall: AppStyles.small.copyWith(color: AppColors.whiteLess),
        displayMedium: AppStyles.medium.copyWith(color: AppColors.whiteLess),
        displayLarge: AppStyles.large.copyWith(color: AppColors.white),

        labelLarge: AppStyles.semiBold.copyWith(fontSize: 14.sp),
        labelMedium: AppStyles.regular.copyWith(fontSize: 12.sp),
        labelSmall: AppStyles.small.copyWith(fontSize: 11.sp),
      ),
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
    return const SplashScreen();
  }
}
