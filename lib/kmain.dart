import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'services/index.dart';
import 'package:http/http.dart' as http;

/// flutter local notifications global identifier
@pragma('vm:entry-point')
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// stream of payload that contains payload of notifications that were received when the app was in background or foreground.
@pragma('vm:entry-point')
final StreamController<String?> backgroundOrForegroundNotificationStream =
    StreamController<String?>.broadcast();

/// stream of payload that contains payload of notifications that were received when the app was terminated.
@pragma('vm:entry-point')
final StreamController<String?> terminatedNotificationStream =
    StreamController<String?>.broadcast();

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
    await initializeFlutterLocalNotificationPlugins();
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

/// initializes flutter local notification
@pragma('vm:entry-point')
initializeFlutterLocalNotificationPlugins() async {
  // check if notification launched the app or not
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    terminatedNotificationStream
        .add(notificationAppLaunchDetails!.notificationResponse?.payload);
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_notification');

  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          backgroundOrForegroundNotificationStream
              .add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          backgroundOrForegroundNotificationStream
              .add(notificationResponse.payload);
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

/// Converts given url image to base64 encoded image string.
@pragma('vm:entry-point')
Future<String> base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}

/// notifies when the user engages with a notification
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} ');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

/// handles all incoming message from fcm and creates a local notification
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ignore: avoid_print
  print('A Background message just showed up :  ${message.messageId}');
  // String type = message.data['type'];
  Map<String, dynamic> messageData = message.data;
  // notification payload
  String payload = jsonEncode(message.data);
  // notification title
  String notificationTitle = Random().nextBool() ? 'Latest' : 'Trending';
  // notification body
  String notificationBody = messageData['title'];
  // big text notification
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    // ignore: prefer_interpolation_to_compose_strings
    '<b>' + notificationBody + '</b>',
    htmlFormatBigText: true,
    contentTitle: notificationTitle,
    htmlFormatContentTitle: true,
    htmlFormatSummaryText: true,
  );
  // large icon png to base 64 string
  String largeIcon = await base64encodedImage(messageData['images']);
  // android notification details
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('alert', 'News Alerts',
          channelDescription: 'Latest and trending news alerts',
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
          icon: 'ic_stat_notification',
          styleInformation: bigTextStyleInformation);
  // full notifications details
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  // flutter local notification
  await flutterLocalNotificationsPlugin.show(message.hashCode + 1,
      notificationTitle, notificationBody, notificationDetails,
      payload: payload);
}
