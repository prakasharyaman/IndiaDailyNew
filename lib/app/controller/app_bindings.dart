import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/ads_controller.dart';
import 'package:indiadaily/app/controller/app_controller.dart';

class AppBindings extends Bindings {
  final FirebaseAnalytics firebaseAnalytics;

  AppBindings(this.firebaseAnalytics);
  @override
  void dependencies() {
    Get.put<AppController>(AppController(firebaseAnalytics), permanent: true);
    Get.put<AdsController>(AdsController(), permanent: true);
  }
}
