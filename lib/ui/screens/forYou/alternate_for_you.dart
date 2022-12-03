import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/services/cache_services.dart';
import 'package:indiadaily/ui/screens/forYou/controller/for_you_controller.dart';
import 'package:indiadaily/ui/screens/forYou/widgets/my_home_page.dart';
import 'package:indiadaily/ui/screens/forYou/widgets/nested_two_article_page.dart';
import 'package:indiadaily/ui/widgets/newsShot/list_news_shot.dart';
import 'package:indiadaily/ui/widgets/video/video_player_page.dart';
import 'package:nested_scroll_views/nested_scroll_views.dart';
import 'widgets/for_you_main_page.dart';
import 'widgets/second_two_article_page.dart';
import 'widgets/two_article_page.dart';

class AlternateForYou extends GetView<ForYouController> {
  /// For You page to show when all the data is loaded and no error is found
  const AlternateForYou({super.key});

  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    NestedPageController nestedPageController = NestedPageController();
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          nestedPageController.jumpTo(0);
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: GetBuilder<ForYouController>(
            id: 'forYouPage',
            assignId: true,
            autoRemove: false,
            builder: (_) {
              List<Widget> forYouWidgets = createWidgetList(
                  articlePairs: _.articlePairs,
                  videos: _.forYouVideos,
                  newsShots: _.forYouNewsShots);

              return NestedPageView(
                wantKeepAlive: true,
                controller: nestedPageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  if (index < currentIndex) {
                    controller.showBottomNavigationBar();
                  } else {
                    controller.hideBottomNavigationBar();
                  }
                  currentIndex = index;
                },
                children: forYouWidgets,
              );
            }),
      ),
    );
  }

  /// Creates a list of mixed widgets for for you page.
  List<Widget> createWidgetList({
    required List<List<Article>> articlePairs,
    required List<NewsShot> newsShots,
    required List<Video> videos,
  }) {
    videos.clear();

    /// to generate randomness
    Random random = Random();
    List<Widget> forYouWidgets = [];
    CacheServices cacheServices = CacheServices();
    List<String> imageUrlList = [];
    int articlePairsLength = (articlePairs.length - 1);
    int newsShotLength = (newsShots.length - 1);
    int videosLength = (videos.length - 1);
    int totalPostsLength = articlePairsLength + newsShotLength + videosLength;
    int articlePairsIndex = 0;
    int newsShotsIndex = 0;
    int videosIndex = 0;
    for (int index = 0; index < (totalPostsLength - 1); index++) {
      var newsShot =
          newsShotsIndex <= newsShotLength ? newsShots[newsShotsIndex] : null;
      var video = videosIndex <= videosLength ? videos[videosIndex] : null;
      var articlePair = articlePairsIndex <= articlePairsLength
          ? articlePairs[articlePairsIndex]
          : null;
      if (index == 0) {
        forYouWidgets.add(ListNewsShot(
          newsShot: newsShot!,
          showGreeting: true,
        ));
        articlePairsIndex++;
        newsShotsIndex++;
      } else if (index % 7 == 0 && video != null) {
        forYouWidgets.add(VideoPlayerPage(video: video));
        imageUrlList.add(video.thumbnail);
        videosIndex++;
      } else if (index % 3 != 0 && newsShot != null && index != 0) {
        forYouWidgets.add(
          ListNewsShot(
            newsShot: newsShot,
          ),
        );
        // increase news shot index and add image to precache
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      } else if (index % 3 == 0 && articlePair != null && index != 0) {
        forYouWidgets.add(random.nextBool()
            ? NestedTwoArticlePage(articles: articlePair)
            : NestedTwoArticlePage(articles: articlePair));
        for (var element in articlePair) {
          imageUrlList.add(element.urlToImage);
        }
        // index article pair index
        articlePairsIndex++;
      } else if (index % 3 != 0 &&
          newsShot == null &&
          index != 0 &&
          articlePair != null) {
        forYouWidgets.add(random.nextBool()
            ? NestedTwoArticlePage(articles: articlePair)
            : NestedTwoArticlePage(articles: articlePair));
        for (var element in articlePair) {
          imageUrlList.add(element.urlToImage);
        }
        articlePairsIndex++;
      } else if (index % 3 == 0 &&
          articlePair == null &&
          index != 0 &&
          newsShot != null) {
        forYouWidgets.add(ListNewsShot(newsShot: newsShot));
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      }
    }
    cacheServices.cacheImages(imageUrlList: imageUrlList);
    return forYouWidgets;
  }
}
