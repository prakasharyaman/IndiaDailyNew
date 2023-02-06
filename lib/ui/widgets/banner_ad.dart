import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:indiadaily/app/controller/ads_controller.dart';

class BannerAdWidget extends GetView<AdsController> {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.bannerAdReady.value
          ? AdWidget(ad: controller.bannerAd!)
          : Container();
    });
  }
}
