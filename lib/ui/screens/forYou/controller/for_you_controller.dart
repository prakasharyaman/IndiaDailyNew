import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/repositories/data_repository.dart';
import 'package:quiver/iterables.dart';

enum ForYouStatus { loading, loaded, error }

class ForYouController extends GetxController {
  /// Instance of App Controller
  AppController appController = Get.find<AppController>();

  /// For you Status reactive
  Rx<ForYouStatus> forYouStatus = ForYouStatus.loading.obs;

  /// Controller for Swiper on for you page
  SwiperController swiperController = SwiperController();

  /// list of videos
  List<Video> forYouVideos = [];

  /// pairs of articles
  List<List<Article>> articlePairs = [];

  /// list of cards to show
  List<Widget> forYouPages = [];

  /// key of get builder for for you page
  String forYouPageBuilderId = "forYouPage";

  /// list of articles
  List<Article> forYouArticles = [];

  /// list of news shots
  List<NewsShot> forYouNewsShots = [];

  /// object of data repository
  DataRepository dataRepository = DataRepository();

  /// list of user preferences

  List<String> selectedCategories = [];

  /// video volume controller
  bool isMute = true;
  @override
  void onInit() {
    super.onInit();
    loadForYouPage();
  }

  setMute({required bool setMute}) {
    isMute = setMute;
  }

  /// Gets for you articles and newsShots using preset profile variables
  loadForYouPage() async {
    forYouStatus.value = ForYouStatus.loading;
    // load selected categories
    selectedCategories = appController.userTopicPreferences;

    /// selected categories length some times goes above 10 limit
    if (selectedCategories.length > 9) {
      selectedCategories.shuffle();
      selectedCategories = selectedCategories.sublist(0, 8);
    }
    // load artilces data from cache
    forYouArticles = await dataRepository.getNewsArticles(
        where: "category", equals: ["source", "general"], loadFromCache: true);
    debugPrint(selectedCategories.toString());

    if (!selectedCategories.contains('all')) {
      selectedCategories.add('all');
    }
    // divide articles in pairs of two
    articlePairs = partition(forYouArticles, 2).toList();
    // lod news Shots from cache
    forYouNewsShots = await dataRepository.getNewsShots(
        equals: selectedCategories, loadFromCache: true);

    // loading from cache is done
    if (forYouArticles.length > 10 && forYouNewsShots.length > 10) {
      forYouStatus.value = ForYouStatus.loaded;
      //load the for you page
      update([forYouPageBuilderId]);
    }

    // loading data from server
    forYouArticles = await dataRepository
        .getNewsArticles(where: "category", equals: ["source", "general"]);
    forYouNewsShots =
        await dataRepository.getNewsShots(equals: selectedCategories);
    articlePairs = partition(forYouArticles, 2).toList();

    // load videos
    forYouVideos = await dataRepository.getVideos();
    // update home status
    forYouStatus.value = ForYouStatus.loaded;
    debugPrint('Updating from cloud');
    update([forYouPageBuilderId]);
  }
}
