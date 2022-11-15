import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/screens/market/controller/market_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../repositories/market_repository.dart';

class EditWatchList extends StatefulWidget {
  const EditWatchList({super.key});

  @override
  State<EditWatchList> createState() => _EditWatchListState();
}

class _EditWatchListState extends State<EditWatchList> {
  MarketController marketController = Get.find<MarketController>();
  List<String> watchListStocks = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      watchListStocks = marketController.watchListStocks;
    });
  }

  /// removes a stock from the watchlist
  removeStockFromWatchList({required String stockName}) async {
    try {
      EasyLoading.show();
      var prefs = await SharedPreferences.getInstance();
      watchListStocks = prefs.getStringList('watchList') ?? kDefaultWatchList;
      if (watchListStocks.contains(stockName)) {
        watchListStocks.remove(stockName);
      }
      await prefs.setStringList('watchList', watchListStocks);
      setState(() {
        watchListStocks;
      });
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Removed');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // marketController.loadMarketPage();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: kDifferentAppTitle(context, "Edit Watchlist"),
            centerTitle: false,
          ),
          body: watchListStocks.isEmpty
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: kDifferentAppTitle(
                      context, 'You don\'t have any stock in your watchlist.'),
                ))
              : ListView.builder(
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return title(context, 'Watchlist');
                    }
                    return Card(
                      elevation: 1,
                      shape: const RoundedRectangleBorder(),
                      child: ListTile(
                        title: title(context,
                            watchListStocks[index - 1].replaceAll('.NS', "")),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            removeStockFromWatchList(
                                stockName: watchListStocks[index - 1]);
                          },
                        ),
                      ),
                    );
                  },
                  itemCount: watchListStocks.length + 1,
                )),
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
