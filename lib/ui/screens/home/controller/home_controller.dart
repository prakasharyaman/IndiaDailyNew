import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();
  AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();

  /// bottom navigation bar Index reactive
  var bottomNavigationIndex = 1.obs;

  /// Changes the value of the index of bottom navigation bar at home.
  changeBottomNavigationIndex(int index) {
    bottomNavigationIndex.value = index;
  }
}
