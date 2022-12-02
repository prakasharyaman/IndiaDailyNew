import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/app/controller/app_bindings.dart';
import 'package:indiadaily/app/get_pages.dart';
import 'package:indiadaily/app/root.dart';
import 'package:indiadaily/ui/constants.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "India Daily",
      theme: FlexThemeData.light(
        scheme: FlexScheme.red,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        scaffoldBackground: kOffWhite,
        appBarBackground: kOffWhite,

        subThemesData: const FlexSubThemesData(
            appBarCenterTitle: true,
            fabSchemeColor: SchemeColor.primary,
            bottomNavigationBarElevation: 2,
            cardRadius: 2,
            cardElevation: 0,
            blendOnColors: false,
            blendTextTheme: false),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.red,
        appBarElevation: 0.5,
        primary: kPrimaryRed,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        subThemesData: const FlexSubThemesData(
          blendOnColors: false,
          bottomNavigationBarElevation: 10,
          fabSchemeColor: SchemeColor.primary,
          appBarCenterTitle: true,
          blendTextTheme: false,
          cardElevation: 2,
        ),
        scaffoldBackground: kOffBlack,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.system,
      initialBinding: AppBindings(),
      getPages: getPages(),
      builder: EasyLoading.init(),
      home: const Root(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}
