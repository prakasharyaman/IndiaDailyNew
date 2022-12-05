import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/article/two_article_page.dart';
import 'package:nested_scroll_views/nested_scroll_views.dart';
import '../../../models/index.dart';
import '../../../services/index.dart';
import '../newsShot/news_shot_page.dart';
import 'controller.dart';

class FeedPage extends GetView<FeedController> {
  const FeedPage({super.key});
  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    List<Widget> feedWidgets = createWidgetList(
        articlePairs: controller.articlePairs,
        newsShots: controller.feedNewsShots);
    controller.feedWidgets = feedWidgets;
    return WillPopScope(
      onWillPop: () async {
        if (controller.feedPageController.page != null) {
          if (controller.feedPageController.page! > 0) {
            controller.feedPageController.animateToPage(0,
                duration: const Duration(microseconds: 200),
                curve: Curves.easeIn);
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      },
      child: GetBuilder<FeedController>(
          id: 'feedPage',
          assignId: true,
          builder: (builderController) {
            debugPrint('Building feed page');
            return NestedPageView(
              wantKeepAlive: true,
              controller: builderController.feedPageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                if (index < currentIndex) {
                  controller.showBottomNavigationBar();
                } else {
                  controller.hideBottomNavigationBar();
                }
                currentIndex = index;
              },
              children: builderController.feedWidgets,
            );
          }),
    );
  }

  /// Creates a list of mixed widgets for for you page.
  List<Widget> createWidgetList({
    required List<List<Article>> articlePairs,
    required List<NewsShot> newsShots,
  }) {
    debugPrint('creating feed widgets');
    List<Widget> forYouWidgets = [];
    CacheServices cacheServices = CacheServices();
    List<String> imageUrlList = [];
    int articlePairsLength = (articlePairs.length - 1);
    int newsShotLength = (newsShots.length - 1);
    int totalPostsLength = articlePairsLength + newsShotLength;
    int articlePairsIndex = 0;
    int newsShotsIndex = 0;
    for (int index = 0; index < (totalPostsLength - 1); index++) {
      var newsShot =
          newsShotsIndex <= newsShotLength ? newsShots[newsShotsIndex] : null;
      var articlePair = articlePairsIndex <= articlePairsLength
          ? articlePairs[articlePairsIndex]
          : null;
      if (index == 0) {
        forYouWidgets.add(NewsShotPage(
          newsShot: controller.notificationNewsShot ?? newsShot!,
          showGreeting: true,
        ));
        articlePairsIndex++;
        newsShotsIndex++;
      } else if (index % 3 != 0 && newsShot != null && index != 0) {
        forYouWidgets.add(
          NewsShotPage(
            newsShot: newsShot,
          ),
        );
        // increase news shot index and add image to precache
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      } else if (index % 3 == 0 && articlePair != null && index != 0) {
        forYouWidgets.add(TwoArticlePage(articles: articlePair));
        for (var element in articlePair) {
          imageUrlList.add(element.urlToImage);
        }
        // index article pair index
        articlePairsIndex++;
      } else if (index % 3 != 0 &&
          newsShot == null &&
          index != 0 &&
          articlePair != null) {
        forYouWidgets.add(TwoArticlePage(articles: articlePair));
        for (var element in articlePair) {
          imageUrlList.add(element.urlToImage);
        }
        articlePairsIndex++;
      } else if (index % 3 == 0 &&
          articlePair == null &&
          index != 0 &&
          newsShot != null) {
        forYouWidgets.add(NewsShotPage(newsShot: newsShot));
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      }
    }
    cacheServices.cacheImages(imageUrlList: imageUrlList);
    return forYouWidgets;
  }
}
