import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/repositories/data_repository.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:quiver/iterables.dart';
import '../../../models/index.dart';

enum FeedStatus { loading, loaded, error }

class FeedController extends GetxController {
  /// Instance of App Controller
  AppController appController = Get.find<AppController>();

  /// Instance of home controller
  HomeController homeController = Get.find<HomeController>();

  /// For you Status reactive
  Rx<FeedStatus> forYouStatus = FeedStatus.loading.obs;

  /// pairs of articles
  List<List<Article>> articlePairs = [];

  /// key of get builder for for you page
  String feedPageId = "feedPage";

  /// list of articles
  List<Article> feedArticles = [];

  /// list of news shots
  List<NewsShot> feedNewsShots = [];

  /// object of data repository
  DataRepository dataRepository = DataRepository();

  /// list of user preferences

  List<String> selectedCategories = [];

  /// video volume controller
  bool isMute = true;
  @override
  void onInit() {
    super.onInit();
    loadFeedPage();
  }

  setMute({required bool setMute}) {
    isMute = setMute;
  }

  /// Gets for you articles and newsShots using preset profile variables
  loadFeedPage() async {
    forYouStatus.value = FeedStatus.loading;
    // load selected categories
    selectedCategories = appController.userTopicPreferences;

    /// selected categories length some times goes above 10 limit
    if (selectedCategories.length > 9) {
      selectedCategories.shuffle();
      selectedCategories = selectedCategories.sublist(0, 8);
    }
    // load artilces data from cache
    feedArticles = await dataRepository.getNewsArticles(
        where: "category", equals: ["source", "general"], loadFromCache: true);
    // debugPrint(selectedCategories.toString());

    if (!selectedCategories.contains('all')) {
      selectedCategories.add('all');
    }
    // divide articles in pairs of two
    articlePairs = partition(feedArticles, 2).toList();
    // lod news Shots from cache
    feedNewsShots = await dataRepository.getNewsShots(
        equals: selectedCategories, loadFromCache: true);

    // loading from cache is done
    if (feedArticles.length > 10 && feedNewsShots.length > 10) {
      forYouStatus.value = FeedStatus.loaded;
      //load the for you page
      update([feedPageId]);
    }

    // loading data from server
    feedArticles = await dataRepository
        .getNewsArticles(where: "category", equals: ["source", "general"]);
    feedNewsShots =
        await dataRepository.getNewsShots(equals: selectedCategories);
    articlePairs = partition(feedArticles, 2).toList();

    // update home status
    forYouStatus.value = FeedStatus.loaded;
    debugPrint('Updated from cloud');
    update([feedPageId]);
  }

  /// hides bottom bar
  hideBottomNavigationBar() {
    homeController.isBottombarVisible.value = false;
  }

  /// shows bottom nav bar
  showBottomNavigationBar() {
    homeController.isBottombarVisible.value = true;
  }
}
