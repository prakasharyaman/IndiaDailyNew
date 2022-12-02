import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';

class HomeController extends GetxController {
  GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();
  AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();

  /// checks if bottom bar is visible or not
  Rx<bool> isBottombarVisible = true.obs;

  /// bottom navigation bar Index reactive
  var bottomNavigationIndex = 1.obs;

  /// Changes the value of the index of bottom navigation bar at home.
  changeBottomNavigationIndex(int index) async {
    if (index == 2) {
      // ignore: await_only_futures
      await Get.put<MarketController>(MarketController(), permanent: true);
    }
    bottomNavigationIndex.value = index;
  }
}
