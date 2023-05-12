import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// flutter local notifications global identifier
@pragma('vm:entry-point')
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// only contains value of a notification from which was app was launched from a dead state
@pragma('vm:entry-point')
String? appTerminatedNotificationPayload;

/// stream of payload that contains payload of notifications that were received when the app was in background or foreground.
@pragma('vm:entry-point')
final StreamController<String?> backgroundOrForegroundNotificationStream =
    StreamController<String?>.broadcast();

/// initializes flutter local notification pliugin
@pragma('vm:entry-point')
initializeFlutterLocalNotificationPlugins() async {
  // check if notification launched the app or not
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    appTerminatedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
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

/// shows a flutter local notification using firebase remote [message]
@pragma('vm:entry-point')
showANotification({required RemoteMessage message}) async {
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
    notificationBody,
    // '<b>' + notificationBody + '</b>',
    htmlFormatBigText: true,
    contentTitle: notificationTitle,
    htmlFormatContentTitle: true,
    htmlFormatSummaryText: true,
  );
  // large icon png to base 64 string
  ByteArrayAndroidBitmap largeIcon =
      ByteArrayAndroidBitmap(await getByteArrayFromUrl(messageData['images']));
  // android notification details
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('alert', 'News Alerts',
          channelDescription: 'Latest and trending news alerts',
          largeIcon: largeIcon,
          icon: 'ic_stat_notification',
          styleInformation: bigTextStyleInformation);
  // full notifications details
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  // flutter local notification
  await flutterLocalNotificationsPlugin.show(message.hashCode + 1,
      notificationTitle, notificationBody, notificationDetails,
      payload: payload);
  // save to storage
  await saveNotificationToStorage(notification: payload);
}

/// saves the notification that was shown to storage
@pragma('vm:entry-point')
saveNotificationToStorage({required String notification}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    if (notifications.length > 50) {
      notifications = notifications.sublist(
          (notifications.length - 49), (notifications.length - 1));
      debugPrint("notifcatiosn shortening");
    }
    notifications.add(notification);
    await prefs.setStringList('notifications', notifications);
  } catch (e) {
    debugPrint('Cannot save notification to storage');
    debugPrint(e.toString());
  }
}

/// Converts given url image to base64 encoded image.
@pragma('vm:entry-point')
Future<String> base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}

/// Converts given url image to [Uint8List] encoded image string.
@pragma('vm:entry-point')
Future<Uint8List> getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
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
