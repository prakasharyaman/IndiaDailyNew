import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StockIndexCard extends StatelessWidget {
  const StockIndexCard(
      {super.key,
      required this.name,
      required this.pChange,
      required this.currentPrice});
  final String name;
  final String pChange;
  final String currentPrice;

  @override
  Widget build(BuildContext context) {
    double change = double.parse(pChange);
    return SizedBox(
        height: Get.height * 0.1,
        width: Get.width * 0.4,
        child: Card(
          elevation: 0.5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: GoogleFonts.archivoBlack().fontFamily,
                      ),
                  maxLines: 1,
                ),
                Text(currentPrice.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: GoogleFonts.archivoBlack().fontFamily,
                        color: change < 0 ? Colors.red : Colors.green),
                    maxLines: 1),
                Text(
                  '$pChange%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: GoogleFonts.archivoBlack().fontFamily,
                      color: change < 0 ? Colors.red : Colors.green),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ));
  }
}
