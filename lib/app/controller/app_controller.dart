import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/forYou/controller/for_you_controller.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  showIntro,
  loading,
  error,
  showTopicPreferences
}

class AppController extends GetxController {
  Rx<AppStatus> appStatus = AppStatus.loading.obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Rxn<User> user = Rxn<User>();
  var userModel = UserModel().obs;
  List<String> userTopicPreferences = [];
  Stream<User?> get userStream => firebaseAuth.authStateChanges();
  @override
  void onInit() {
    super.onInit();
    //run every time auth state changes
    ever(user, handleAuthChanged);
    //bind to user model
    user.bindStream(userStream);
  }

  /// Handles changes in auth behaviour.
  handleAuthChanged(firebaseUser) async {
    //get user data from firestore
    if (firebaseUser?.uid != null) {
      userModel.value.id = firebaseUser.uid;
      runAppLogic();
    } else if (firebaseUser == null) {
      try {
        await firebaseAuth.signInAnonymously();
      } catch (e) {
        appStatus.value = AppStatus.error;
        debugPrint(e.toString());
      }
    }
  }

  /// Decides what to show at root of the app.
  runAppLogic() async {
    // load user topic preferences first
    userTopicPreferences = await getUserTopicPrefernces();
    // if intro shown
    // if profile is not set
    // else show home and put controllers
    if (!await getValue(of: 'introShown')) {
      appStatus.value = AppStatus.showIntro;
    } else if (!await getValue(of: 'shownTopicPreferences')) {
      appStatus.value = AppStatus.showTopicPreferences;
    } else {
      Get.put<HomeController>(HomeController(), permanent: true);
      Get.put<ForYouController>(ForYouController(), permanent: true);
      appStatus.value = AppStatus.authenticated;
    }
  }

  /// Get value of a key in storage..
  Future<bool> getValue({required String of}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(of) ?? false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Save user Topic Prefernces List
  saveUserTopicPrefernces({required List<String> topics}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList('userTopicPreferences', topics);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Get user Topic Prefernces List
  Future<List<String>> getUserTopicPrefernces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('userTopicPreferences') ?? ['all'];
    } catch (e) {
      debugPrint(e.toString());
      return ['all'];
    }
  }

  /// Changes value of a key in storage
  setValue({required String of, required bool to}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(of, to);
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }
}
