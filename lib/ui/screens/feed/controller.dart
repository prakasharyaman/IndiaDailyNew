import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/main.dart';
import 'package:indiadaily/repositories/data_repository.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:quiver/iterables.dart';
import '../../../models/index.dart';
import '../newsShot/news_shot_page.dart';

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

  /// notification news shot
  NewsShot? notificationNewsShot;
  // reactive in order to show terminated clicked notification
  Rx<bool> notificationOpenedApp = false.obs;

  /// video volume controller
  bool isMute = true;
  @override
  void onInit() {
    super.onInit();
    loadFeedPage();
    // lister of notification when app is terminated
    listenToTerminatedStateNotificationStream();
    // lister of notification when app is in background or foreground
    listenToBackgroundOrForegroundStateNotificationStream();
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
    // // load artilces data from cache
    // feedArticles = await dataRepository.getNewsArticles(
    //     where: "category", equals: ["source", "general"], loadFromCache: true);
    // // debugPrint(selectedCategories.toString());

    // if (!selectedCategories.contains('all')) {
    //   selectedCategories.add('all');
    // }
    // // divide articles in pairs of two
    // articlePairs = partition(feedArticles, 2).toList();
    // // lod news Shots from cache
    // feedNewsShots = await dataRepository.getNewsShots(
    //     equals: selectedCategories, loadFromCache: true);

    // // loading from cache is done
    // if (feedArticles.length > 10 && feedNewsShots.length > 10) {
    //   forYouStatus.value = FeedStatus.loaded;
    //   //load the for you page
    //   update([feedPageId]);
    // }

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

  /// listener for notification tap when the app was in terminated state to show notification
  listenToTerminatedStateNotificationStream() {
    debugPrint('started listening to terminated payload stream');
    terminatedNotificationStream.stream.listen((payload) {
      if (payload != null) {
        debugPrint(
            'received a notification payload and app was initially terminated');
        NewsShot? receivedNewsShot;
        // try creating a notification from given payload
        try {
          NewsShot payloadNewsShot = NewsShot.fromJson(jsonDecode(payload));
          receivedNewsShot = payloadNewsShot;
        } catch (e) {
          debugPrint(e.toString());
        }
        if (receivedNewsShot != null) {
          // firstNewsShot = receivedNewsShot.obs;
        } else {
          debugPrint('received news was null');
        }
      }
    });
  }

  /// listener for notification tap when the app was in background or foreground state to show notification
  listenToBackgroundOrForegroundStateNotificationStream() {
    debugPrint(
        'listening To Background Or ForegroundState Notification Stream ');
    backgroundOrForegroundNotificationStream.stream.listen((payload) async {
      debugPrint('background payload stream received');
      if (payload != null) {
        debugPrint(
            'received a notification payload and app was initially terminated');
        NewsShot? receivedNewsShot;
        // try creating a notification from given payload
        try {
          NewsShot payloadNewsShot = NewsShot.fromJson(jsonDecode(payload));
          receivedNewsShot = payloadNewsShot;
        } catch (e) {
          debugPrint(e.toString());
        }
        if (receivedNewsShot != null) {
          notificationOpenedApp.value = true;
          notificationNewsShot = receivedNewsShot;
        } else {
          debugPrint('received news was null');
        }
        if (receivedNewsShot != null) {
          if (Get.context != null) {
            showFullNewsShotAsBottomSheet(Get.context!, receivedNewsShot);
          } else {
            debugPrint('get context was null');
          }
        }
      }
    });
  }
}
