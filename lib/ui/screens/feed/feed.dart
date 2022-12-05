import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/error/error_screen.dart';
import 'package:indiadaily/ui/screens/feed/feed_page.dart';
import 'package:indiadaily/ui/screens/loading/loading.dart';
import 'controller.dart';

class Feed extends GetView<FeedController> {
  const Feed({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.forYouStatus.value) {
        case FeedStatus.loading:
          return const Loading();
        case FeedStatus.loaded:
          return const FeedPage();
        case FeedStatus.error:
          return ErrorScreen(
            onTap: () {
              controller.loadFeedPage();
            },
          );
      }
    });
  }
}
