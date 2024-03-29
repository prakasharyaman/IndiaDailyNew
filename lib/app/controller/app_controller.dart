import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/repositories/user_repository.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/feed/controller.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:indiadaily/ui/screens/settings/page/settings_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  showIntro,
  loading,
  error,
  showTopicPreferences,
}

class AppController extends GetxController {
  /// app status
  Rx<AppStatus> appStatus = AppStatus.loading.obs;

  /// analytics instance
  final FirebaseAnalytics firebaseAnalytics;

  /// auth instance
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // user repository
  UserRepository userRepository = UserRepository();
  // user obs
  Rxn<User> user = Rxn<User>();
  // userModel
  var userModel = UserModel().obs;
  // userTopicPreferences
  List<String> userTopicPreferences = [];

  AppController(this.firebaseAnalytics);
  // user stream
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
      // subscribe
      subscribeToTopic();
      // analytics
      await firebaseAnalytics.setUserId(id: firebaseUser.uid);
      // runs the main app logic
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
    // else go home after putting controllers
    if (!await getValue(of: 'introShown')) {
      // shows intro at root
      appStatus.value = AppStatus.showIntro;
    } else if (!await getValue(of: 'shownTopicPreferences')) {
      // shows topic preferences
      appStatus.value = AppStatus.showTopicPreferences;
    } else {
      // update activity
      userRepository.updateLastActive(userId: userModel.value.id!);
      // go straight to home
      Get.put<HomeController>(HomeController(), permanent: true);
      Get.put<FeedController>(FeedController(), permanent: true);

      appStatus.value = AppStatus.authenticated;
      checkForUpdates();
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

  ///subscribe to messaging topics
  subscribeToTopic() async {
    // subscribe to debug if in debug
    if (kDebugMode) {
      debugPrint('app is in debug');
      await FirebaseMessaging.instance.subscribeToTopic('debug');
    }

    await FirebaseMessaging.instance.subscribeToTopic('newsShots');
  }

  /// checks for update on firestore
  checkForUpdates() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await FirebaseFirestore.instance
        .collection('app')
        .doc('updates')
        .get()
        .then((DocumentSnapshot doc) {
      final appData = doc.data() as Map<String, dynamic>;
      int cloudBuildNumber = appData['buildNumber'];
      if (cloudBuildNumber > int.parse(packageInfo.buildNumber)) {
        showUpdateAvailableBottomSheet();
      } else {
        debugPrint('Running On Latest Version ${packageInfo.buildNumber}');
      }
    });
  }

  /// update availbale bottom sheet
  showUpdateAvailableBottomSheet() {
    if (Get.context != null) {
      showModalBottomSheet(
        context: Get.context!,
        isDismissible: false,
        builder: (context) {
          var primaryColor = Theme.of(context).primaryColor;
          return updateBottomSheetWidget(context, primaryColor);
        },
      );
    } else {
      showDailySnackBar(
          'An Update is Available for India Daily \n Please go to the Play Store to update the app');
    }
  }
}

// bottom sheet to show update
SizedBox updateBottomSheetWidget(BuildContext context, Color primaryColor) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        // text new update available
        RichText(
          text: TextSpan(
            text: "",
            style: Theme.of(context).textTheme.titleLarge,
            children: <TextSpan>[
              TextSpan(
                text: 'Update ',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Available',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ],
          ),
        ),
        const Divider(
          indent: 40,
          endIndent: 40,
        ),
        // description why to updtae
        Text(
          'Please update your app to keep enjoying latest features.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),

        // an animate icon to update
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            FontAwesomeIcons.googlePlay,
            color: kPrimaryRed,
            size: 100,
          ),
        )),
        // row with later and update button and fires function to open play store
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Later',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                launchAppUrl(
                    url:
                        'https://play.google.com/store/apps/details?id=app.indiadaily.android',
                    openExternal: true);
              },
              style: ElevatedButton.styleFrom(elevation: 10),
              child: Text(
                'Update',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ]),
    ),
  );
}
