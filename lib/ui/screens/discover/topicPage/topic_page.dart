import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/services/cache_services.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/screens/article/widget/row_article.dart';
import 'package:indiadaily/ui/screens/discover/topicPage/controller/topic_controller.dart';
import 'package:indiadaily/ui/screens/error/error_screen.dart';
import 'package:indiadaily/ui/screens/loading/loading.dart';
import '../../newsShot/widgets/small_news_shot_card.dart';

class TopicPage extends GetView<TopicController> {
  const TopicPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.topicStatus.value) {
        case TopicStatus.loading:
          return const Loading(
            centerTitle: false,
          );
        case TopicStatus.loaded:
          return const TopicPageBuilder();
        case TopicStatus.error:
          return ErrorScreen(
            onTap: () {
              controller.loadTopicPage();
            },
          );
      }
    });
  }
}

class TopicPageBuilder extends GetView<TopicController> {
  const TopicPageBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    var listWidgets = createWidgetsList(
        articles: controller.articles, newsShots: controller.newsShots);

    return Scaffold(
        appBar: AppBar(
          title: kDifferentAppTitle(context, controller.topic.capitalizeFirst),
          centerTitle: false,
        ),
        body: ListView(
          children: listWidgets,
        ));
  }

  List<Widget> createWidgetsList({
    required List<Article> articles,
    required List<NewsShot> newsShots,
  }) {
    List<Widget> widgets = [];
    int articleLength = (articles.length - 1);
    int newsShotLength = (newsShots.length - 1);
    int articleIndex = 0;
    int newsShotsIndex = 0;
    CacheServices cacheServices = CacheServices();
    List<String> imageUrlList = [];
    int totalPostsLength = articleLength + newsShotLength;
    for (int index = 0; index < (totalPostsLength - 1); index++) {
      var newsShot =
          newsShotsIndex <= newsShotLength ? newsShots[newsShotsIndex] : null;
      var article =
          articleIndex <= articleLength ? articles[articleIndex] : null;
      if (index == 0 && newsShot != null) {
        widgets.add(SmallNewsShotCard(
          newsShot: newsShot,
          showCategory: false,
        ));
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      } else if (index != 0 && index % 2 == 0 && article != null) {
        widgets.add(RowArticle(
          article: article,
          showCategory: false,
        ));
        imageUrlList.add(article.urlToImage);
        articleIndex++;
      } else if (index != 0 && index % 2 != 0 && newsShot != null) {
        widgets.add(SmallNewsShotCard(
          newsShot: newsShot,
          showCategory: false,
        ));
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      } else if (newsShot == null && article != null) {
        widgets.add(RowArticle(
          article: article,
          showCategory: false,
        ));
        imageUrlList.add(article.urlToImage);
        articleIndex++;
      } else if (newsShot != null && article == null) {
        widgets.add(SmallNewsShotCard(
          newsShot: newsShot,
          showCategory: false,
        ));
        imageUrlList.add(newsShot.images);
        newsShotsIndex++;
      }
    }
    cacheServices.cacheImages(imageUrlList: imageUrlList);
    return widgets;
  }
}
