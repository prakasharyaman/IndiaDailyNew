import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/app/controller/app_bindings.dart';
import 'package:indiadaily/app/get_pages.dart';
import 'package:indiadaily/app/root.dart';
import 'package:indiadaily/ui/constants.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // firebase analytics
  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "India Daily",
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),

      /// light theme
      theme: FlexThemeData.light(
        scheme: FlexScheme.red,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        scaffoldBackground: kOffWhite,
        appBarBackground: kOffWhite,
        subThemesData: const FlexSubThemesData(
            appBarCenterTitle: true,
            fabSchemeColor: SchemeColor.primary,
            bottomNavigationBarElevation: 2,
            cardRadius: 3,
            cardElevation: 0,
            blendOnColors: false,
            blendTextTheme: false),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: 'FF Infra',
      ),

      /// dark theme
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.red,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        scaffoldBackground: kOffBlack,
        appBarBackground: kOffBlack,
        subThemesData: const FlexSubThemesData(
            appBarCenterTitle: true,
            fabSchemeColor: SchemeColor.primary,
            bottomNavigationBarElevation: 2,
            cardRadius: 3,
            cardElevation: 0,
            blendOnColors: false,
            blendTextTheme: false),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),

      /// theme mode
      themeMode: ThemeMode.system,
      initialBinding: AppBindings(firebaseAnalytics),
      getPages: getPages(),
      builder: EasyLoading.init(),
      home: const Root(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
    );
  }
}
