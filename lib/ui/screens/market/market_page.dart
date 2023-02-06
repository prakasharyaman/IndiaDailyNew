import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/models/stock_model.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:indiadaily/ui/screens/market/widgets/search_stock_widget.dart';
import 'package:indiadaily/ui/screens/newsShot/widgets/small_news_shot_card.dart';
import 'package:indiadaily/ui/widgets/bottom_sheet_tile.dart';
import 'package:search_page/search_page.dart';
import 'package:yahoofin/yahoofin.dart';
import 'k/list_of_stocks.dart';
import 'pages/edit_watch_list.dart';
import 'pages/full_stock_info.dart';
import 'widgets/watch_list_stock.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  MarketController controller = Get.find<MarketController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.homeController.changeBottomNavigationIndex(1);
        return false;
      },
      child: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // sized box for a bit of extra spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            //market heading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Market',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.archivoBlack().fontFamily),
                ),
              ),
            ),

            // today's date
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  formatDate(DateTime.now(), [d, ' ', MM]),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.archivoBlack().fontFamily,
                      color: Theme.of(context).textTheme.headlineMedium?.color),
                ),
              ),
            ),

            // search field
            SearchStockWidget(
              onTap: () {
                showStockSearch();
              },
            ),

            // my stocks heading

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      'My Stocks',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: GoogleFonts.archivoBlack().fontFamily,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          showWatchListBottomSheet();
                        },
                        icon: const Icon(FontAwesomeIcons.ellipsis)),
                  ],
                ),
              ),
            ),

            // my stocks cards
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                StockQuote stockData = controller.watchList[index];
                return WatchListStock(stockData: stockData);
              }, childCount: controller.watchList.length),
            ),

            // business news
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Business News',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.archivoBlack().fontFamily),
                ),
              ),
            ),

            // business news list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // NewsShotRow
                  return SmallNewsShotCard(
                    newsShot: controller.newsShots[index],
                    showCategory: false,
                  );
                },
                childCount: controller.newsShots.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// shows watch list bottom sheet with its option
  showStockSearch() {
    showSearch(
        context: context,
        delegate: SearchPage<StockModel>(
            searchStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'FF Infra Bold',
                ),
            showItemsOnEmpty: true,
            searchLabel: 'Search Stocks',
            builder: (stock) {
              return GestureDetector(
                onTap: () {
                  showFullStockInfo(context: context, stockName: stock.symbol);
                },
                child: Card(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stock.symbol,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontFamily: 'FF Infra Bold')),
                        Text(stock.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontFamily: 'FF Infra')),
                        const Divider(),
                      ],
                    )),
              );
            },
            filter: (stock) => [stock.symbol, stock.fullName],
            items: nseStocks));
  }

  // show watchlist bottom sheet
  showWatchListBottomSheet() {
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
                      Get.back();
                      showStockSearch();
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
}
//TODO: configure my stock search