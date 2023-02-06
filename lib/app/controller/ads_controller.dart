import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:indiadaily/services/ad_services.dart';

class AdsController extends GetxController {
  Rx<bool> bannerAdReady = false.obs;
  BannerAd? bannerAd;
  @override
  void onInit() {
    super.onInit();
    loadBannerAd();
  }

  /// loads banner ad
  loadBannerAd() async {
    BannerAd(
      adUnitId: AdServices.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.fluid,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAdReady = true.obs;
          bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          bannerAdReady = false.obs;
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
}
