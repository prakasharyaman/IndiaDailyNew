import 'package:flutter/material.dart';
import 'package:get/get.dart';

showDailySnackBar(String message) {
  if (Get.context != null) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } else {
    Get.snackbar('Alert !', message,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.star),
        shouldIconPulse: true);
  }
}
