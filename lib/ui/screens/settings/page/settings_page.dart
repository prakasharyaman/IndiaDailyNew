import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/ui/screens/user/user_topic_preferences_update.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../user/notification_settings.dart';
import '../../user/notifications_history.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Settings',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SettingsList(
        lightTheme: const SettingsThemeData(
          settingsListBackground: Colors.white,
        ),
        applicationType: ApplicationType.material,
        sections: [
          // user card

          // feed settings
          SettingsSection(
            title: const Text(
              'Feed',
            ),
            tiles: [
              // topic preferences
              settingsTile(
                  title: 'Topics Preferences',
                  onTap: () {
                    Get.to(const UsertopicPreferencesUpdate(),
                        transition: Transition.rightToLeft);
                  }),
              // horoscope
              settingsTile(
                  title: 'Horoscope',
                  onTap: () {
                    EasyLoading.showToast(
                        'Horoscope isn\'t available for your region.');
                  }),
            ],
          ),
          // notifications settings
          SettingsSection(
            title: const Text(
              'Notifications',
            ),
            tiles: [
              settingsTile(
                  title: 'My subscriptions',
                  onTap: () {
                    Get.to(const NotificationSettings(),
                        transition: Transition.rightToLeft);
                  }),
              settingsTile(
                  title: 'Notification History',
                  onTap: () {
                    Get.to(const NotificationsHistory(),
                        transition: Transition.rightToLeft);
                  }),
            ],
          ),
          // theme
          SettingsSection(
            title: const Text(
              'Theme',
            ),
            tiles: [
              settingsTile(
                  title: 'Change Theme',
                  onTap: () {
                    EasyLoading.showToast(
                        'Theme automatically adopts to your phones theme.');
                  }),
            ],
          ),
          // feed back
          SettingsSection(
            title: const Text(
              'Feedback',
            ),
            tiles: [
              settingsTile(
                  title: 'Send Feedback',
                  onTap: () {
                    launchAppUrl(
                        url:
                            'mailto:info@otft.in?subject=Feedback for India Daily');
                  }),
            ],
          ),
          // all
          SettingsSection(
            title: const Text(
              'All',
            ),
            tiles: [
              settingsTile(
                  title: 'Licenses',
                  onTap: () {
                    showLicensePage(
                        context: context,
                        applicationName: "",
                        applicationIcon: Center(child: kAppTitle(context)));
                  }),
              settingsTile(
                  title: 'About us',
                  onTap: () {
                    launchAppUrl(url: 'https://www.otft.in/about');
                  }),
              settingsTile(
                  title: 'Privacy Policy',
                  onTap: () {
                    launchAppUrl(
                        url: 'https://www.otft.in/india-daily-privacy-policy');
                  }),
              settingsTile(
                  title: 'Terms And Conditions',
                  onTap: () {
                    launchAppUrl(url: 'https://www.otft.in/india-daily-t-c');
                  }),
            ],
          ),
        ],
      ),
    );
  }

  settingsTile({required String title, required Function onTap}) {
    return SettingsTile(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        FontAwesomeIcons.angleRight,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.2),
      ),
      // value: const Divider(),
      onPressed: (context) {
        onTap();
      },
    );
  }
}

Future launchAppUrl({required String url, bool? openExternal}) async {
  Uri uri = Uri.parse(url);
  LaunchMode launchMode = openExternal == true
      ? LaunchMode.externalApplication
      : LaunchMode.platformDefault;
  if (!await launchUrl(uri, mode: launchMode)) {
    showDailySnackBar('Could not show $url');
  }
}
