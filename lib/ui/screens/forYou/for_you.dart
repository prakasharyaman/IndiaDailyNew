import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/services/cache_services.dart';
import 'package:indiadaily/ui/screens/error/error_screen.dart';
import 'package:indiadaily/ui/screens/forYou/controller/for_you_controller.dart';
import 'package:indiadaily/ui/widgets/newsShot/news_shot.dart';
import 'package:indiadaily/ui/widgets/video/video_player_page.dart';
import 'widgets/for_you_main_page.dart';
import 'widgets/second_two_article_page.dart';
import 'widgets/two_article_page.dart';

class ForYou extends GetView<ForYouController> {
  const ForYou({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'forYou');
    return Obx(() {
      switch (controller.forYouStatus.value) {
        case ForYouStatus.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case ForYouStatus.loaded:
          return const ForYouPage();

        case ForYouStatus.error:
          return ErrorScreen(
            onTap: () {
              controller.loadForYouPage();
            },
          );
      }
    });
  }
}

class ForYouPage extends GetView<ForYouController> {
  /// For You page to show when all the data is loaded and no error is found
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          controller.swiperController.move(0);
          return false;
        } else {
          return true;
        }
      },
      child: GetBuilder<ForYouController>(
          id: 'forYouPage',
          assignId: true,
          autoRemove: false,
          builder: (_) {
            List<Widget> forYouWidgets = createWidgetList(
                articlePairs: _.articlePairs,
                videos: _.forYouVideos,
                newsShots: _.forYouNewsShots);
            return Scaffold(
              // appBar: forYouAppBar(context),
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.loadForYouPage();
                },
                child: Swiper(
                  onIndexChanged: ((value) {
                    currentIndex = value;
                  }),
                  controller: _.swiperController,
                  scrollDirection: Axis.vertical,
                  loop: false,
                  itemCount: (forYouWidgets.length - 1),
                  itemBuilder: ((context, index) {
                    return forYouWidgets[index];
                  }),
                ),
              ),
            );
          }),
    );
  }

  /// Creates a list of mixed widgets for for you page.
  List<Widget> createWidgetList({
    required List<List<Article>> articlePairs,
    required List<NewsShot> newsShots,
    required List<Video> videos,
  }) {
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
        forYouWidgets
            .add(ForYouMainPage(newsShot: newsShot!, articles: articlePair!));
        articlePairsIndex++;
        newsShotsIndex++;
      } else if (index % 7 == 0 && video != null) {
        forYouWidgets.add(VideoPlayerPage(video: video));
        imageUrlList.add(video.thumbnail);
        videosIndex++;
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
        forYouWidgets.add(random.nextBool()
            ? TwoArticlePage(articles: articlePair)
            : SecondTwoArticlePage(articles: articlePair));
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
            ? TwoArticlePage(articles: articlePair)
            : SecondTwoArticlePage(articles: articlePair));
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
