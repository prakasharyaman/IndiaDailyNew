import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/ui/screens/error/error_screen.dart';
import 'package:indiadaily/ui/screens/home/home.dart';
import 'package:indiadaily/ui/screens/intro/introduction.dart';
import 'package:indiadaily/ui/screens/intro/widgets/topic_preferences.dart';
import 'package:indiadaily/ui/screens/loading/loading.dart';
import 'package:indiadaily/ui/screens/unauthenticaated/unauthenticated.dart';

class Root extends GetView<AppController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.appStatus.value) {
        case AppStatus.authenticated:
          return Home();
        case AppStatus.unauthenticated:
          return const Unauthenticated();
        case AppStatus.showIntro:
          return const Introduction();
        case AppStatus.loading:
          return const Loading();
        case AppStatus.error:
          return ErrorScreen(onTap: () {
            Get.forceAppUpdate();
          });
        case AppStatus.showTopicPreferences:
          return const TopicPreferences();
      }
    });
  }
}
