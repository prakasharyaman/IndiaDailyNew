import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/repositories/data_repository.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:nested_scroll_views/nested_scroll_views.dart';
import 'package:quiver/iterables.dart';
import '../../../models/index.dart';
import '../../../services/notification_services.dart';
import '../newsShot/news_shot_page.dart';

enum FeedStatus { loading, loaded, error }

class FeedController extends GetxController {
  /// Instance of App Controller
  AppController appController = Get.find<AppController>();

  /// controller for feed page nested page views
  NestedPageController feedPageController = NestedPageController();

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
  // // reactive in order to show terminated clicked notification
  // Rx<bool> notificationOpenedApp = false.obs;
  List<Widget> feedWidgets = [];

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
    // loading data from server
    feedArticles = await dataRepository
        .getNewsArticles(where: "category", equals: ["source", "general"]);
    feedNewsShots =
        await dataRepository.getNewsShots(equals: selectedCategories);
    //divide articles in a partition
    articlePairs = partition(feedArticles, 2).toList();

    // remove notification news shot from list if it exists in list of cloud news Shots
    if (notificationNewsShot != null) {
      feedNewsShots.removeWhere(
          (element) => element.title == notificationNewsShot!.title);
    }

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
    if (appTerminatedNotificationPayload != null) {
      debugPrint(
          'The app was opened from a notification, showing that on the front page');
      NewsShot? receivedNewsShot;
      // try creating a notification from given payload
      try {
        NewsShot payloadNewsShot = NewsShot.fromJson(
            jsonDecode(appTerminatedNotificationPayload.toString()));
        receivedNewsShot = payloadNewsShot;
      } catch (e) {
        debugPrint(e.toString());
      }
      if (receivedNewsShot != null) {
        // notificationOpenedApp.value = true;
        notificationNewsShot = receivedNewsShot;
      } else {
        debugPrint('received news was null');
      }
    }
  }

  /// listener for notification tap when the app was in background or foreground state to show notification as bottom sheet
  listenToBackgroundOrForegroundStateNotificationStream() {
    debugPrint(
        'listening To Background Or ForegroundState Notification Stream ');
    backgroundOrForegroundNotificationStream.stream.listen((payload) async {
      debugPrint('background payload stream received');
      if (payload != null) {
        NewsShot? receivedNewsShot;
        // try creating a notification from given payload
        try {
          NewsShot payloadNewsShot = NewsShot.fromJson(jsonDecode(payload));
          receivedNewsShot = payloadNewsShot;
        } catch (e) {
          debugPrint(e.toString());
        }
        if (receivedNewsShot != null) {
          if (feedPageController.page != null) {
            debugPrint('inserting new element at :${feedPageController.page}');
            feedWidgets.insert(feedPageController.page!.toInt() + 1,
                NewsShotPage(newsShot: receivedNewsShot));
            update([feedPageId]);
            Future.delayed(const Duration(milliseconds: 100), () {
              feedPageController
                  .jumpToPage(feedPageController.page!.toInt() + 1);
            });
          } else {
            debugPrint('Feed page controller couldn\'t locate current page');
          }
        }
      }
    });
  }
}
