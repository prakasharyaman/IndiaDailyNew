import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:yahoofin/yahoofin.dart';

class MarketRepository {
  YahooFin yahooFin = YahooFin();

  /// get stock  data using stock name
  Future<StockQuote> getStockData({required String stockName}) async {
    StockInfo info = yahooFin.getStockInfo(ticker: stockName);
    StockQuote stockQuote = await info.getStockData();
    return stockQuote;
  }

  /// gets index data
  Future<Map<String, dynamic>?> getIndexData(
      {required String indexName}) async {
    Map<String, dynamic>? data;
    try {
      var reponse = await http.get(Uri.parse(
          'https://priceapi.moneycontrol.com/pricefeed/notapplicable/inidicesindia/$indexName'));
      data = jsonDecode(reponse.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    return data;
  }
}

var kIndexes = [
  // sensex
  'in%3BSEN',
  // nifty 50
  'in%3BNSX',
  // nifty bank
  'in%3Bnbx',
  // nifty midcap
  'in%3Bccx',
];
var kDefaultWatchList = ['RELIANCE.NS', 'TATAMOTORS.NS', 'TCS.NS'];
