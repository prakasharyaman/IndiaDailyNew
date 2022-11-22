import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        margin: colored ? null : const EdgeInsets.all(10),
        color: colored
            ? stockData.regularMarketChangePercent! < 0
                ? Colors.red
                : Colors.green
            : Theme.of(context).cardColor,
        shape: colored
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title(context,
                      stockData.ticker.toString().replaceAll('.NS', '')),
                  Padding(
                    padding: const EdgeInsets.only(top: 1, left: 8, right: 8),
                    child: Text(stockData.metaData!.shortName.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: GoogleFonts.archivo().fontFamily,
                            )),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title(context, stockData.currentPrice.toString()),
                  Padding(
                    padding: const EdgeInsets.only(top: 1, left: 8, right: 8),
                    child: Text(
                        '${stockData.regularMarketChangePercent!.toStringAsPrecision(2)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              // color: controller.watchList[index]
                              //             .regularMarketChangePercent! <
                              //         0
                              //     ? Colors.red
                              //     : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.archivo().fontFamily,
                            )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// title
  Padding title(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: GoogleFonts.archivoBlack().fontFamily,
              )),
    );
  }
}
