import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/models/stock_model.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:indiadaily/ui/screens/market/k/list_of_stocks.dart';
import 'package:indiadaily/ui/screens/market/pages/edit_watch_list.dart';
import 'package:indiadaily/ui/screens/market/pages/full_stock_info.dart';
import 'package:indiadaily/ui/screens/market/widgets/stock_index_card.dart';
import 'package:indiadaily/ui/screens/market/widgets/watch_list_stock.dart';
import 'package:indiadaily/ui/widgets/bottom_sheet_tile.dart';
import 'package:indiadaily/ui/widgets/newsShot/news_shot_row.dart';
import 'package:search_page/search_page.dart';
import 'package:yahoofin/yahoofin.dart';

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
          //TODO: add error pag
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //market heading
          SliverToBoxAdapter(child: title(context, 'Market')),
          // indexes cards
          buildStockIndexCards(),
          //watchlist heading
          SliverToBoxAdapter(
              child: Row(
            children: [
              title(context, 'Watchlist'),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    showWatchListBottomSheet(context);
                  },
                  icon: const Icon(FontAwesomeIcons.ellipsis)),
            ],
          )),

          // watchlist
          buildWatchList(),
          // business news headline
          SliverToBoxAdapter(child: title(context, 'Business News')),

          // news list
          buildNewsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showFullStockInfo(context: context, stockName: 'RELIANCE');
          // controller.deleteWatchList();
          showStockSearch(context);
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  /// list of news shot widgets
  SliverList buildNewsList() {
    return SliverList(
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
    );
  }

  /// watch list widgets
  SliverList buildWatchList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        StockQuote stockData = controller.watchList[index];
        return WatchListStock(stockData: stockData);
      }, childCount: controller.watchList.length),
    );
  }

  /// top stock index cards
  SliverToBoxAdapter buildStockIndexCards() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 1, bottom: 8),
        child: SizedBox(
          height: Get.height * 0.1,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.indexes.length,
              itemBuilder: (context, index) {
                var indexData = controller.indexes[index]['data'];
                return StockIndexCard(
                    name: indexData['company'],
                    pChange: indexData['PERCCHANGE'].toString(),
                    currentPrice: indexData['pricecurrent']);
              }),
        ),
      ),
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

  /// shows watch list bottom sheet with its option
  showWatchListBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        isScrollControlled: true,
        builder: (_) {
          return Container(
            height: Get.height * 0.3,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // heading
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: RichText(
                      text: TextSpan(
                          text: 'Configure your ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                        TextSpan(
                          text: 'Watchlist.',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ])),
                ),
                // add stocks
                BottomSheetTile(
                    title: "Add stocks",
                    icon: Icons.add,
                    onTap: () {
                      //TODO: show stocks search
                      Get.back();
                    }),
                BottomSheetTile(
                    title: "Remove stocks",
                    icon: Icons.remove,
                    onTap: () {
                      Get.back();
                      Get.to(const EditWatchList(),
                          transition: Transition.rightToLeft);
                    }),
              ],
            )),
          );
        });
  }

  showStockSearch(context) {
    showSearch(
        context: context,
        delegate: SearchPage<StockModel>(
            searchStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: GoogleFonts.archivoBlack().fontFamily,
                ),
            showItemsOnEmpty: true,
            searchLabel: 'Search Stocks',
            builder: (stock) {
              return Card(
                elevation: 0.2,
                shape: const RoundedRectangleBorder(),
                child: ListTile(
                  onTap: () {
                    // Get.back();
                    showFullStockInfo(
                        context: context, stockName: stock.symbol);
                  },
                  title: title(context, stock.symbol),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      stock.fullName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: GoogleFonts.archivoBlack().fontFamily,
                          ),
                      maxLines: 1,
                    ),
                  ),
                  trailing: const Icon(FontAwesomeIcons.arrowRight),
                ),
              );
            },
            filter: (stock) => [stock.symbol, stock.fullName],
            items: nseStocks));
  }
}
