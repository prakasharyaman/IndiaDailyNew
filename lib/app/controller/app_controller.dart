import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/forYou/controller/for_you_controller.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:indiadaily/ui/screens/notification/notification_news_shot_page.dart';
import 'package:indiadaily/ui/screens/settings/page/settings_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/index.dart';
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
    // // remove the splash screen
    // FlutterNativeSplash.remove();
    //run every time auth state changes
    ever(user, handleAuthChanged);
    //bind to user model
    user.bindStream(userStream);
    // subscribe
    subscribeToTopic();
    //notification handler
    setupInteractedMessage();
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
  subscribeToTopic() {
    FirebaseMessaging.instance.subscribeToTopic('newsShots');
  }

  /// setup interacted with a message like click
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('handling a message');
    if (message.notification?.android?.channelId == 'news') {
      var newsShotJson = message.data;
      NewsShot newsShot = NewsShot.fromJson(newsShotJson);
      showNotificationPage(newsShot: newsShot);
    } else {
      debugPrint('Couldn\'t figure out channel id');
    }
  }

  /// naviagets to notification page
  showNotificationPage({required NewsShot newsShot}) {
    // show news Shot
    try {
      if (Get.currentRoute == '/NotificationNewsShotPage' ||
          Get.currentRoute == '/notificationNewsShotPage') {
        Get.back();
      }
      Get.to(NotificationNewsShotPage(
        newsShot: newsShot,
      ));
    } catch (e) {
      debugPrint('Failed to show notification page');
      debugPrint(e.toString());
    }
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
        debugPrint('Running On Latest Version $packageInfo.buildNumber');
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
          });
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
            style: Theme.of(context).textTheme.headline6,
            children: <TextSpan>[
              TextSpan(
                text: 'Update ',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Available',
                style: Theme.of(context).textTheme.headline3?.copyWith(
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
        // row wit later and update button
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
