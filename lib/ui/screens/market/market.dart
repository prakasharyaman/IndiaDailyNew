import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/screens/loading/loading.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';

class Market extends GetView<MarketController> {
  const Market({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.marketStatus.value) {
        case MarketStatus.loading:
          return const Loading();
        case MarketStatus.loaded:
          return const MarketPage();
        case MarketStatus.error:
          //TODO: add error page
          return const Center(
            child: Text('erroe'),
          );
      }
    });
  }
}

class MarketPage extends GetView<MarketController> {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: title(context, 'Market')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 1, bottom: 8),
            child: SizedBox(
              height: Get.height * 0.1,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.indexes.length,
                  itemBuilder: (context, index) {
                    var indexData = controller.indexes[index]['data'];
                    return TopIndexCard(
                        name: indexData['company'],
                        pChange: indexData['PERCCHANGE'].toString(),
                        currentPrice: indexData['pricecurrent']);
                  }),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ElevatedButton(
            child: Text('go'),
            onPressed: () {
              controller.getIndexes();
            },
          ),
        )
      ],
    );
  }

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

class TopIndexCard extends StatelessWidget {
  /// creates a card to index name , pchange and current price
  const TopIndexCard(
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
