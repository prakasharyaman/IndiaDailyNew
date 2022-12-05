import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'services/index.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    // ignore: unused_local_variable
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // firebase initialize
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // foreground message handler
    FirebaseMessaging.onMessage.listen(firebaseMessagingBackgroundHandler);
    // firebase crash analytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // flutter local notifications
    initializeFlutterLocalNotificationPlugins();
    // register storage service
    getIt.registerSingleton<StorageServices>(StorageServices());

    // initialize storage services
    getIt<StorageServices>().initialize();
    // Setup preferred orientations,
    // and then run app.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((value) => runApp(const App()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

/// handles all incoming message from fcm and creates a local notification
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ignore: avoid_print
  print('A Background message just showed up :  ${message.messageId}');
  // show a local notification , also saves to storage
  await showANotification(message: message);
}
