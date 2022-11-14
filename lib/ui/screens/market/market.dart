import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:indiadaily/ui/widgets/newsShot/news_shot_row.dart';

class Market extends GetView<MarketController> {
  const Market({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.marketStatus.value) {
        case MarketStatus.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
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
        // SliverToBoxAdapter(
        //     child: Padding(
        //   padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        //   child: SizedBox(
        //     height: Get.height * 0.05,
        //     child: ListTile(
        //       onTap: () {
        //         // showSearch(context: context, delegate: delegate)
        //       },
        //       shape: const RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(5)),
        //           side: BorderSide()),
        //       title: Text(
        //         'Search',
        //         style: Theme.of(context).textTheme.bodySmall,
        //       ),
        //       trailing: const Icon(Icons.search),
        //     ),
        //   ),
        // )),
        // SliverToBoxAdapter(
        //   child: Card(
        //     elevation: 0.2,
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(5)),
        //         side: BorderSide()),
        //     child: SizedBox(
        //       height: Get.height * 0.05,
        //       width: Get.width,
        //     ),
        //   ),
        // ),
        SliverToBoxAdapter(child: title(context, 'Watchlist')),

        // watchlist
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Card(
              color: controller.watchList[index].regularMarketChangePercent! < 0
                  ? Colors.red
                  : Colors.green,
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
                            context,
                            controller.watchList[index].ticker
                                .toString()
                                .replaceAll('.NS', '')),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 1, left: 8, right: 8),
                          child: Text(
                              controller.watchList[index].metaData!.shortName
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontFamily:
                                        GoogleFonts.archivo().fontFamily,
                                  )),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        title(
                            context,
                            controller.watchList[index].currentPrice
                                .toString()),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 1, left: 8, right: 8),
                          child: Text(
                              '${controller.watchList[index].regularMarketChangePercent!.toStringAsPrecision(3)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    // color: controller.watchList[index]
                                    //             .regularMarketChangePercent! <
                                    //         0
                                    //     ? Colors.red
                                    //     : Colors.green,
                                    fontFamily:
                                        GoogleFonts.archivo().fontFamily,
                                  )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }, childCount: controller.watchList.length),
        ),
        //news headline
        SliverToBoxAdapter(child: title(context, 'Business News')),
        // SliverToBoxAdapter(
        //   child: ElevatedButton(
        //     child: Text('reload'),
        //     onPressed: () {
        //       // controller.x();
        //     },
        //   ),
        // ),
        // news list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // NewsShotRow
              return Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 0.2,
                  child: SizedBox(
                    height: Get.height * 0.5,
                    child: NewsShotRow(
                      newsShot: controller.newsShots[index],
                    ),
                  ));
            },
            childCount: controller.newsShots.length,
          ),
        ),
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
