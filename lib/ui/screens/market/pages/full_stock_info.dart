import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:indiadaily/ui/screens/market/widgets/watch_list_stock.dart';
import 'package:yahoofin/yahoofin.dart';

showFullStockInfo(
    {required BuildContext context,
    required String stockName,
    StockQuote? stockQuote}) {
  showModalBottomSheet(
      elevation: 5,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

  /// build
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // add remove from watchlist
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            tooltip: !isInWatchList
                ? 'Add stock in watchlist'
                : 'Remove stock from Watchlist',
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
              isInWatchList ? Icons.favorite : Icons.favorite_border,
              color: isInWatchList ? kPrimaryRed : Colors.grey,
            ),
          ),
        ),
        // stock name and info with add to favourite button
        stockQuoteMode == 1
            ? WatchListStock(
                stockData: stockQuote!,
                colored: false,
              )
            : SizedBox(
                height: Get.height * 0.2,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        // stock Historical dats
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: stockHistoricalDataMode == 1
        //       ? StockHistoricalChart(
        //           stockChart: stockChart!,
        //         )
        //       : const LinearProgressIndicator(),
        // ),
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
    );
  }

  buildStockAdditionalInfo({required StockQuote stockQuote}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // hish , low , volume
        tripleInfoRow(
            h1: 'Day High',
            t1: stockQuote.dayHigh.toString(),
            h2: 'Day Low',
            t2: stockQuote.dayLow.toString(),
            h3: 'Day Vol.',
            t3: stockQuote.regularMarketVolume.toString()),
        const Divider(),
        // 50d change , 52 w high%, 52w low %
        tripleInfoRow(
            h1: '50d Change',
            t1: stockQuote.fiftyDayAverageChangePercent!.toStringAsPrecision(2),
            h2: '52w high',
            t2: stockQuote.fiftyTwoWeekHighChangePercent!
                .toStringAsPrecision(2),
            h3: '52w Low',
            t3: stockQuote.fiftyTwoWeekLowChangePercent!
                .toStringAsPrecision(2)),
        const Divider(),
      ],
    );
  }

  /// three columns with information
  tripleInfoRow(
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
          style: Theme.of(context).textTheme.titleSmall,
        )
      ],
    );
  }

  showErrorScreen() {}
}
