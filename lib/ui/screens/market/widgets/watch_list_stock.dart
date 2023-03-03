import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/market/pages/full_stock_info.dart';
import 'package:yahoofin/yahoofin.dart';

import '../pages/edit_watch_list.dart';

class WatchListStock extends StatelessWidget {
  const WatchListStock(
      {super.key, required this.stockData, this.colored = true});
  final StockQuote stockData;
  final bool colored;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // long press detector to remove from watchlist
      onLongPress: () {
        if (colored) {
          Get.defaultDialog(
              title: 'Remove from watchlist?',
              middleText:
                  'Doing this will remove this stock from watchlist, you can still view and add this stock back to watchlist using search.',
              onConfirm: () {
                Get.back();
                Get.to(const EditWatchList(),
                    transition: Transition.rightToLeft);
              },
              textCancel: 'Close',
              textConfirm: 'Remove!');
        }
      },
      // tap detector to open full info
      onTap: () {
        if (colored) {
          showFullStockInfo(
              context: context,
              stockName: stockData.ticker.toString().replaceAll('.NS', ''),
              stockQuote: stockData);
        }
      },
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title(
                    context,
                    stockData.ticker.toString().replaceAll('.NS', ''),
                  ),
                  title(
                    context,
                    stockData.currentPrice!.toStringAsFixed(2),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      stockData.metaData!.shortName.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'FF Infra',
                          ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: stockData.regularMarketChangePercent! < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                          '${stockData.regularMarketChangePercent!.toStringAsFixed(2)}%',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontFamily: 'FF Infra', color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  /// title
  title(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontFamily: 'FF Infra Bold'),
    );
  }
}
