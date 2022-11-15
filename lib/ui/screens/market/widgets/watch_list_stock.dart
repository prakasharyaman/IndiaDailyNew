import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yahoofin/yahoofin.dart';

class WatchListStock extends StatelessWidget {
  const WatchListStock({super.key, required this.stockData});
  final StockQuote stockData;
  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          stockData.regularMarketChangePercent! < 0 ? Colors.red : Colors.green,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      elevation: 0.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(
                    context, stockData.ticker.toString().replaceAll('.NS', '')),
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
                      '${stockData.regularMarketChangePercent!.toStringAsPrecision(3)}%',
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
