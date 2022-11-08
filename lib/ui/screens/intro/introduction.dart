import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/ui/screens/intro/widgets/hello.dart';
import 'package:indiadaily/ui/screens/intro/widgets/topic_preferences.dart';

class Introduction extends GetView<AppController> {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        children: const [
          Hello(),
          TopicPreferences(),
        ],
        onPageChanged: (val) {
          if (val == 1) {
            setIntroAsShown();
          }
        },
      ),
    );
  }

  setIntroAsShown() async {
    EasyLoading.show(status: 'Loading...');
    await controller.setValue(of: 'introShown', to: true);
    EasyLoading.dismiss();
  }
}
