import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/user/notification_settings.dart';
import 'package:indiadaily/ui/widgets/custom/multi_select_widget.dart';
import '../../common/topic_preferences_list.dart';
import 'user_topic_preferences_update.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
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
