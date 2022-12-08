import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/ui/screens/newsShot/widgets/small_news_shot_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsHistory extends StatefulWidget {
  const NotificationsHistory({super.key});

  @override
  State<NotificationsHistory> createState() => _NotificationsHistoryState();
}

class _NotificationsHistoryState extends State<NotificationsHistory> {
  List<NewsShot> newsShots = [];
  var notificationsLoaded = false;
  @override
  initState() {
    super.initState();
    loadNotifications();
  }

  loadNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> notifications = prefs.getStringList('notifications') ?? [];
      for (var notification in notifications) {
        try {
          newsShots.add(NewsShot.fromJson(jsonDecode(notification)));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      newsShots.sort((a, b) => b.time.compareTo(a.time));
      setState(() {
        notificationsLoaded = true;
      });
    } catch (e) {
      EasyLoading.showError('Failed to load notifications.');
      debugPrint('Cannot save notification to storage');
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Notifications History',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: !notificationsLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: newsShots.length,
              itemBuilder: (_, index) {
                return SmallNewsShotCard(
                  newsShot: newsShots[index],
                );
              }),
    );
  }
}
