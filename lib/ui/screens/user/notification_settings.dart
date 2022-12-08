import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  initState() {
    super.initState();
    loaduserSettings();
  }

  Map<String, bool> userSettings = {
    "business": false,
    "entertainment": false,
    "science": false,
    "health": false,
    "sports": false,
    "technology": false,
    "breaking": true,
  };

  /// loading user setting
  loaduserSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var updatedUserSettings = userSettings;
    userSettings.forEach((key, value) async {
      bool setting = prefs.getBool(key) ?? value;
      updatedUserSettings[key] = setting;
    });
    setState(() {
      userSettings = updatedUserSettings;
    });
  }

  ///changes user notification setting
  changeUserSetting({required String of, required bool to}) async {
    try {
      EasyLoading.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(of, to);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Updated');
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
      EasyLoading.showError('Couldn\'t save');
    }
    setState(() {
      userSettings[of] = to;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'My Subscriptions',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          // notifications
          ListTile(
            leading: const Icon(FontAwesomeIcons.bell),
            title: title(context, 'Notifications'),
          ),
          // alerts
          SwitchListTile(
              title: settingTitle(context, "Alerts"),
              value: true,
              onChanged: (_) {
                EasyLoading.showToast('Cannot change alerts');
              }),
          //breaking
          SwitchListTile(
              title: settingTitle(context, "Breaking News"),
              subtitle: settingDescription(context, '~ 1 per day'),
              value: userSettings['breaking'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'breaking', to: _);
              }),
          //business
          SwitchListTile(
              title: settingTitle(context, "Business"),
              subtitle: settingDescription(context, '~ 2 per day'),
              value: userSettings['business'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'business', to: _);
              }),
          //science
          SwitchListTile(
              title: settingTitle(context, "Science"),
              subtitle: settingDescription(context, '~ 3 per week'),
              value: userSettings['science'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'science', to: _);
              }),
          //entertainment
          SwitchListTile(
              title: settingTitle(context, "Bollywood"),
              subtitle: settingDescription(context, '~ 1 per day'),
              value: userSettings['entertainment'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'entertainment', to: _);
              }),
          //health
          SwitchListTile(
              title: settingTitle(context, "Health"),
              subtitle: settingDescription(context, '~ 1 per day'),
              value: userSettings['health'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'health', to: _);
              }),
          //sports
          SwitchListTile(
              title: settingTitle(context, "Sports"),
              subtitle: settingDescription(context, '~ 5 per week'),
              value: userSettings['sports'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'sports', to: _);
              }),
          //technology
          SwitchListTile(
              title: settingTitle(context, "Technology"),
              subtitle: settingDescription(context, '~ 4 per week'),
              value: userSettings['technology'] ?? false,
              onChanged: (_) {
                changeUserSetting(of: 'technology', to: _);
              }),
        ],
      ),
    );
  }

  Text settingDescription(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith());
  }

  Text settingTitle(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith());
  }

  Text title(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontFamily: GoogleFonts.archivoBlack().fontFamily,
            ));
  }
}
