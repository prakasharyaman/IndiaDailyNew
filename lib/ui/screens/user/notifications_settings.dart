import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/user/notification_settings.dart';
import 'user_topic_preferences_update.dart';

class NotificationsSettings extends StatelessWidget {
  const NotificationsSettings({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: kAppTitle(context),
          bottom: TabBar(
            indicatorColor: kPrimaryRed,
            labelColor: kPrimaryRed,
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontFamily: GoogleFonts.archivoBlack().fontFamily),
            labelStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontFamily: GoogleFonts.archivoBlack().fontFamily),
            tabs: const [
              Tab(
                text: 'Topics',
              ),
              Tab(
                text: 'Settings',
              ),
              Tab(
                text: 'History',
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          UsertopicPreferencesUpdate(),
          NotificationSettings(),
          NotificationHistory(),
        ]),
      ),
    );
  }
}

class NotificationHistory extends StatelessWidget {
  const NotificationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No old Notifications found !',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontFamily: GoogleFonts.archivoBlack().fontFamily),
      ),
    );
  }
}
