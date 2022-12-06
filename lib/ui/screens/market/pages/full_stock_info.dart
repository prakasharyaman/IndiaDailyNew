import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:yahoofin/yahoofin.dart';

import '../widgets/historical_chart.dart';

showFullStockInfo(
    {required BuildContext context,
    required String stockName,
    StockQuote? stockQuote}) {
  showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
          minHeight: Get.height * 0.8, maxHeight: Get.height * 0.8),
      context: context,
      builder: (context) {
        return FullStockInfo(
          stockName: stockName,
          stockQuote: stockQuote,
        );
      });
}

class FullStockInfo extends StatefulWidget {
  const FullStockInfo({super.key, this.stockQuote, required this.stockName});
  final StockQuote? stockQuote;
  final String stockName;
  @override
  State<FullStockInfo> createState() => _FullStockInfoState();
}

class _FullStockInfoState extends State<FullStockInfo> {
  MarketController marketController = Get.find<MarketController>();
  StockChart? stockChart;
  StockQuote? stockQuote;
  bool isInWatchList = false;

  /// defines the mode of stockdata , if it's available 1 or loading 0 or not 2;
  int stockQuoteMode = 0;
  int stockHistoricalDataMode = 0;

  @override
  void initState() {
    super.initState();
    if (widget.stockQuote == null) {
      loadStockQuote(stockName: widget.stockName);
    } else {
      stockQuote = widget.stockQuote;
      stockQuoteMode = 1;
    }

    if (marketController.watchListStocks.contains(widget.stockName)) {
      setState(() {
        isInWatchList = true;
      });
    }
    loadStockHistoricalData(stockName: widget.stockName);
  }

  ///saves the stock is in watchlist
  saveToWatchList({required String stockName}) async {
    try {
      EasyLoading.show();
      await marketController.saveToWatchList(stockName: stockName);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Saved to watchlist');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Cannot save to watchlist');
    }
  }

  /// removes the stock from watchlist
  removeFromWatchList({required String stockName}) async {
    try {
      EasyLoading.show();
      await marketController.removeFromWatchList(stockName: stockName);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Removed from watchlist');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Cannot remove from watchlist');
    }
  }

  /// title
  Widget title(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(fontFamily: 'FF Infra Bold'));
  }

  /// loads stock quote .. change and other stuff
  loadStockQuote({required String stockName}) async {
    try {
      var stockqot = await marketController.marketRepository
          .getStockData(stockName: stockName);

      setState(() {
        stockQuote = stockqot;
        stockQuoteMode = 1;
      });
    } catch (e) {
      setState(() {
        stockQuoteMode = 2;
      });
      debugPrint(e.toString());
    }
  }

  /// loads historical data
  loadStockHistoricalData({required String stockName}) async {
    try {
      stockChart = await marketController.marketRepository
          .getStockHistoricalData(stockName: stockName);
      if (stockChart != null) {
        setState(() {
          stockChart;
          stockHistoricalDataMode = 1;
        });
      }
    } catch (e) {
      setState(() {
        stockHistoricalDataMode = 2;
      });
      debugPrint(e.toString());
    }
  }

  // builds stock widget with name add to watchlist and changes
  stockWidget() {
    return Stack(
      children: [
        Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(),
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              // name and full name of stock
              RichText(
                text: TextSpan(
                    text:
                        '${stockQuote!.ticker.toString().replaceAll('.NS', '')}  ',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontFamily: 'FF Infra Bold',
                        color: Theme.of(context).textTheme.headline6!.color),
                    children: [
                      TextSpan(
                          text: stockQuote!.metaData!.shortName.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'FF Infra',
                                  ))
                    ]),
              ),
              // a simple divider
              const Divider(),
              // current price and percent change
              RichText(
                text: TextSpan(
                    text: '${stockQuote!.currentPrice!.toStringAsFixed(2)}  ',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontFamily: 'FF Infra Bold'),
                    children: [
                      TextSpan(
                          text:
                              "${stockQuote!.regularMarketChangePercent!.toStringAsFixed(2)}%",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontFamily: 'FF Infra',
                                color:
                                    stockQuote!.regularMarketChangePercent! < 0
                                        ? Colors.red
                                        : Colors.green,
                              ))
                    ]),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Add or remove from watchlist',
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (isInWatchList) {
                      removeFromWatchList(stockName: widget.stockName);
                    } else {
                      saveToWatchList(stockName: widget.stockName);
                    }
                    setState(() {
                      isInWatchList = !isInWatchList;
                    });
                  },
                  icon: Icon(
                    isInWatchList
                        ? Icons.bookmark_remove
                        : Icons.bookmark_add_outlined,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),

          // stock name and info with add to favourite button
          stockQuoteMode == 1
              ? stockWidget()
              : SizedBox(
                  height: Get.height * 0.2,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

          // stock Historical dats
          SizedBox(
            height: Get.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: stockHistoricalDataMode == 1
                  ? StockHistoricalChart(
                      stockChart: stockChart!,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          // // stock additional info
          SizedBox(
            height: Get.height * 0.5,
            width: Get.width,
            child: stockQuoteMode == 1
                ? buildStockAdditionalInfo(stockQuote: stockQuote!)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }

  buildStockAdditionalInfo({required StockQuote stockQuote}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // hish , low , volume
        Card(
          margin: const EdgeInsets.all(10),
          child: tripleInfoRow(
              h1: 'Day High',
              t1: stockQuote.dayHigh!.toStringAsFixed(2),
              h2: 'Day Low',
              t2: stockQuote.dayLow!.toStringAsFixed(2),
              h3: 'Day Vol.',
              t3: stockQuote.regularMarketVolume.toString()),
        ),

        // 50d change , 52 w high%, 52w low %
        Card(
          margin: const EdgeInsets.all(10),
          child: tripleInfoRow(
              h1: '50d Change',
              t1: (stockQuote.fiftyDayAverageChangePercent! *
                      stockQuote.currentPrice!)
                  .toStringAsFixed(2),
              h2: '52w high',
              t2: '${stockQuote.fiftyTwoWeekHighChangePercent!.toStringAsFixed(2)}%',
              h3: '52w Low',
              t3: '${stockQuote.fiftyTwoWeekLowChangePercent!.toStringAsFixed(2)}%'),
        ),
      ],
    );
  }

  /// three columns with information
  Widget tripleInfoRow(
      {required String h1,
      required String t1,
      required String h2,
      required String t2,
      required String h3,
      required String t3}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: infoColumn(title: h1, text: t1),
          ),
          Expanded(
            child: infoColumn(title: h2, text: t2),
          ),
          Expanded(
            child: infoColumn(title: h3, text: t3),
          ),
        ],
      ),
    );
  }

  /// info column
  infoColumn({required String title, required String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  showErrorScreen() {}
}
