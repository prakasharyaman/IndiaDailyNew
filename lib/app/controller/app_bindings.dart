import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController(), permanent: true);
  }
}
