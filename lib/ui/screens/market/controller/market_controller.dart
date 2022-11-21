import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/repositories/data_repository.dart';
import 'package:indiadaily/repositories/market_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yahoofin/yahoofin.dart';

enum MarketStatus { loading, loaded, error }

class MarketController extends GetxController {
  /// market Status reactive
  Rx<MarketStatus> marketStatus = MarketStatus.loading.obs;
  MarketRepository marketRepository = MarketRepository();
  DataRepository dataRepository = DataRepository();

  /// list if news shots related to business to be shown
  List<NewsShot> newsShots = [];

  /// list of all stocks in watchlist
  List<String> watchListStocks = [];

  /// stock quotes of all the stocks in watchlist
  List<StockQuote> watchList = [];

  /// data of top indexes
  List<Map<String, dynamic>> indexes = [];

  ///init
  @override
  onInit() {
    super.onInit();
    loadMarketPage();
  }

  /// starts loading market data , watchlist , news and indexes
  loadMarketPage() async {
    try {
      marketStatus.value = MarketStatus.loading;
      // load index data
      await getIndexes();
      // get business news
      await getBusinessNews();
      // get watchlist stocks
      await getWatchListStocks();
      // get data of stocks inside watchlist
      await getWatchlistStocksData();
      // load market page
      marketStatus.value = MarketStatus.loaded;
    } catch (e) {
      debugPrint(e.toString());
      marketStatus.value = MarketStatus.error;
    }
  }

  /// gets watchlist stock data
  getWatchlistStocksData() async {
    watchList.clear();
    for (var stockName in watchListStocks) {
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

  /// gets all stocks in watchlist in storage
  getWatchListStocks() async {
    var prefs = await SharedPreferences.getInstance();
    watchListStocks = prefs.getStringList('watchList') ?? kDefaultWatchList;
    // print(watchListStocks);
  }

  /// get business news shots
  getBusinessNews() async {
    newsShots = await dataRepository
        .getNewsShots(equals: ["business"], loadFromCache: false);
  }

  /// gets Index Data
  getIndexes() async {
    indexes.clear();
    for (String indexName in kIndexes) {
      Map<String, dynamic>? indexData =
          await marketRepository.getIndexData(indexName: indexName);
      if (indexData != null) {
        indexes.add(indexData);
      }
    }
    debugPrint('got indexes data');
  }

  deleteWatchList() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('watchList');
  }

  /// saves a stock to watchlist
  saveToWatchList({required String stockName}) async {
    var prefs = await SharedPreferences.getInstance();
    var stockInWatchList =
        prefs.getStringList('watchList') ?? kDefaultWatchList;
    if (!stockInWatchList.contains(stockName)) {
      stockInWatchList.add(stockName);
    }
    await prefs.setStringList('watchList', stockInWatchList);
  }

  /// remove From StockList
  removeFromWatchList({required String stockName}) async {
    var prefs = await SharedPreferences.getInstance();
    var stockInWatchList =
        prefs.getStringList('watchList') ?? kDefaultWatchList;
    if (stockInWatchList.contains(stockName)) {
      stockInWatchList.remove(stockName);
    }
    await prefs.setStringList('watchList', stockInWatchList);
  }
}
