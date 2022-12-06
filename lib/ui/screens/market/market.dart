import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/error/error_screen.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';

import '../loading/loading.dart';
import 'market_page.dart';

class Market extends GetView<MarketController> {
  const Market({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.marketStatus.value) {
        case MarketStatus.loading:
          return const Loading();
        case MarketStatus.loaded:
          return const MarketPage();
        case MarketStatus.error:
          return ErrorScreen(onTap: () {
            controller.loadMarketPage();
          });
      }
    });
  }
}
