import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/repositories/data_repository.dart';
import 'package:indiadaily/repositories/market_repository.dart';
import 'package:yahoofin/yahoofin.dart';

enum MarketStatus { loading, loaded, error }

class MarketController extends GetxController {
  /// market Status reactive
  Rx<MarketStatus> marketStatus = MarketStatus.loading.obs;
  MarketRepository marketRepository = MarketRepository();
  DataRepository dataRepository = DataRepository();
  List<NewsShot> newsShots = [];
  List<StockQuote> watchList = [];
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
      await getBusinessNews();
      await getWatchlistStocksData();
      marketStatus.value = MarketStatus.loaded;
    } catch (e) {
      debugPrint(e.toString());
      marketStatus.value = MarketStatus.error;
    }
  }

  getWatchlistStocksData() async {
    for (var stockName in kDefaultWatchList) {
      try {
        var stockData =
            await marketRepository.getStockData(stockName: stockName);
        if (stockData.regularMarketChangePercent != null) {
          watchList.add(stockData);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  /// get business news shots
  getBusinessNews() async {
    newsShots = await dataRepository.getNewsShots(equals: ['business']);
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
