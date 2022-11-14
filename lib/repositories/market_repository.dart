import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';
import 'package:http/http.dart' as http;

class MarketRepository {
  getData({String stockTicker = '^NSEI', int howManyDaysBefore = 7}) async {
    YahooFinanceDailyReader yahooFinanceDailyReader =
        const YahooFinanceDailyReader();
    var xDaysOldDate = DateTime.now()
            .subtract(Duration(days: howManyDaysBefore))
            .toUtc()
            .millisecondsSinceEpoch ~/
        1000;
    List<dynamic> prices = await yahooFinanceDailyReader
        .getDailyData(stockTicker, startTimestamp: xDaysOldDate);

    print(prices.length);
  }

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
