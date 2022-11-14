import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/repositories/market_repository.dart';

enum MarketStatus { loading, loaded, error }

class MarketController extends GetxController {
  /// market Status reactive
  Rx<MarketStatus> marketStatus = MarketStatus.loading.obs;
  MarketRepository marketRepository = MarketRepository();
  List<Map<String, dynamic>> indexes = [];
  @override
  onInit() {
    super.onInit();
    loadMarketPage();
  }

  loadMarketPage() async {
    try {
      marketStatus.value = MarketStatus.loading;
      await getIndexes();
      marketStatus.value = MarketStatus.loaded;
    } catch (e) {
      debugPrint(e.toString());
      marketStatus.value = MarketStatus.error;
    }
  }

  /// gets Index Data
  getIndexes() async {
    for (String indexName in kIndexes) {
      Map<String, dynamic>? indexData =
          await marketRepository.getIndexData(indexName: indexName);
      if (indexData != null) {
        indexes.add(indexData);
      }
    }
    debugPrint('got indexes data');
  }
}
