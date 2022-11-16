import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:indiadaily/ui/screens/market/widgets/historical_chart.dart';
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
  late StockQuote? stockData;
  late String stockName;
  bool stockDataReady = false;
  bool stockHistoricalDataReady = false;
  @override
  void initState() {
    super.initState();
    // stockData = widget.stockQuote;
    // if (widget.stockQuote == null) {
    //   loadStockQuote(stockName: widget.stockName);
    // } else {
    //   stockData = widget.stockQuote;
    //   stockDataReady = true;
    //   stockName = widget.stockName;
    //   setState(() {
    //     stockDataReady;
    //   });
    // }
  }

  /// loads stock quote .. change and other stuff
  loadStockQuote({required String stockName}) async {}

  /// loads historical data
  loadStockHistoricalData() async {}

  /// build
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              //TODO
              // remove from favourite
            },
            icon: Icon(
              Icons.favorite,
              color: kPrimaryRed,
            ),
          ),
        ),
        // stock name and info with add to favourite button
        WatchListStock(
          stockData: widget.stockQuote!,
          colored: false,
        ),
        // stock Historical dats
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: LineChartSample2(),
        ),
        // // stock additional info
        SizedBox(
            height: Get.height * 0.5,
            width: Get.width,
            child: buildStockAdditionalInfo(stockQuote: widget.stockQuote!)),
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
}
