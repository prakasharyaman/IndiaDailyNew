import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/repositories/data_repository.dart';

enum TopicStatus { loading, loaded, error }

class TopicController extends GetxController {
  TopicController({required this.topic});
  final String topic;
  var topicStatus = TopicStatus.loading.obs;

  /// list of news shots
  List<NewsShot> newsShots = [];
  // list of articles
  List<Article> articles = [];

  /// object of data repository
  DataRepository dataRepository = DataRepository();

  @override
  void onInit() {
    super.onInit();
    loadTopicPage();
  }

  loadTopicPage() async {
    topicStatus.value = TopicStatus.loading;
    try {
      // load newsShots
      if (kNewsShotCategories.contains(topic)) {
        newsShots = await dataRepository.getNewsShots(equals: [topic]);
      }
      // load articles
      if (kArticlesCategories.contains(topic)) {
        articles = await dataRepository.getNewsArticles(equals: [topic]);
      }
      if ((newsShots.length + articles.length) < 10) {
        throw Exception('not-enough-posts-in-$topic');
      } else {
        topicStatus.value = TopicStatus.loaded;
      }
    } catch (e) {
      debugPrint(e.toString());
      topicStatus.value = TopicStatus.error;
    }
  }
}
