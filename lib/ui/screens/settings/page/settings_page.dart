// ignore_for_file: file_names

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/common/snackbar.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:

import '../model/menuOptions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  AppController appController = Get.find<AppController>();
  PackageInfo? packageInfo;
  int? groupValue = 0;
  final List<MenuOptionsModel> themeOptions = [
    MenuOptionsModel(
        key: "system", value: 'System'.tr, icon: Icons.brightness_4),
    MenuOptionsModel(
        key: "light", value: 'Light'.tr, icon: Icons.brightness_low),
    MenuOptionsModel(key: "dark", value: 'Dark'.tr, icon: Icons.brightness_3)
  ];

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  getPackageInfo() async {
    try {
      var pInfo = await PackageInfo.fromPlatform();
      setState(() {
        packageInfo = pInfo;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var sectionTextStyle = Theme.of(context).textTheme.bodySmall;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: packageInfo != null
            ? SettingsList(
                applicationType: ApplicationType.material,
                lightTheme: const SettingsThemeData(
                    settingsListBackground: Colors.white),
                sections: [
                  SettingsSection(
                    title: Text(
                      'Common',
                      style: sectionTextStyle,
                    ),
                    tiles: <SettingsTile>[
                      // language
                      SettingsTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Language'),
                          value: const Text('English'),
                          onPressed: (_) {
                            showDailySnackBar(
                                'We only provide the app in english as of now.');
                          }),
                      // environment
                      SettingsTile(
                          leading: const Icon(Icons.cloud_queue),
                          title: const Text('Environment'),
                          value: const Text('Production'),
                          onPressed: (_) {
                            showDailySnackBar(
                                'The app is in production environment.');
                          }),
                      // platform
                      SettingsTile(
                          leading: const Icon(Icons.devices),
                          title: const Text('Platform'),
                          value: const Text('Android'),
                          onPressed: (_) {
                            showDailySnackBar(
                                'You are using the app on an Android device.');
                          }),
                    ],
                  ),
                  SettingsSection(
                    title: Text(
                      'Account',
                      style: sectionTextStyle,
                    ),
                    tiles: <SettingsTile>[
                      //username
                      SettingsTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Username'),
                          onPressed: (_) {
                            showDailySnackBar('Name not found !');
                          }),
                      //id
                      SettingsTile(
                          leading: const Icon(Icons.key),
                          title: const Text('Id'),
                          value:
                              Text(appController.userModel.value.id.toString()),
                          onPressed: (_) {
                            showDailySnackBar(
                                'Your id is your unique identifier.');
                          }),
                      // // phone number
                      // SettingsTile(
                      //     leading: const Icon(Icons.call),
                      //     title: const Text('Phone number'),
                      //     onPressed: (_) {
                      //       showSnackBar(_, 'Your phone number is not availbale');
                      //     }),
                      // //email
                      // SettingsTile(
                      //     leading: const Icon(Icons.email),
                      //     title: const Text('Email'),
                      //     onPressed: (_) {
                      //       showSnackBar(_, 'Your email is not availbale');
                      //     }),
                      // //signout
                      SettingsTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Sign Out'),
                          onPressed: (_) {
                            Get.back();
                          }),
                    ],
                  ),
                  packageInfo == null
                      ? const SettingsSection(
                          title: Text('India Daily'), tiles: [])
                      : SettingsSection(
                          title: Text(
                            'App Info',
                            style: sectionTextStyle,
                          ),
                          tiles: [
                            //app name
                            SettingsTile(
                              leading: const Icon(Icons.android_rounded),
                              title: const Text('App Name'),
                              description: Text(packageInfo!.appName),
                              onPressed: (i) {
                                Get.snackbar('App Name ?',
                                    'name of the app is ${packageInfo!.appName}',
                                    snackPosition: SnackPosition.BOTTOM);
                              },
                            ),
                            //package  name
                            SettingsTile(
                                leading: const Icon(Icons.scatter_plot_rounded),
                                title: const Text('Package Name'),
                                description: Text(packageInfo!.packageName),
                                onPressed: (i) {
                                  Get.snackbar('Package Name ?',
                                      'name of the package is ${packageInfo!.packageName}',
                                      snackPosition: SnackPosition.BOTTOM);
                                }),
                            //Version  name
                            SettingsTile(
                              leading: const Icon(
                                  Icons.precision_manufacturing_sharp),
                              title: const Text('Version Code'),
                              description: Text(packageInfo!.version),
                              onPressed: (i) {
                                Get.snackbar('Version Code ?',
                                    'name of the Version is ${packageInfo!.version}',
                                    snackPosition: SnackPosition.BOTTOM);
                              },
                            ),
                            //Build  Number
                            SettingsTile(
                              leading: const Icon(Icons.build),
                              title: const Text('Build Number'),
                              description: Text(packageInfo!.buildNumber),
                              onPressed: (i) {
                                Get.snackbar('Build Number ?',
                                    'value of the buildNumber is ${packageInfo!.buildNumber}',
                                    snackPosition: SnackPosition.BOTTOM);
                              },
                            ),
                          ],
                        ),
                  SettingsSection(
                    title: Text(
                      'Security',
                      style: sectionTextStyle,
                    ),
                    tiles: <SettingsTile>[
                      // theme switching
                      SettingsTile.switchTile(
                          initialValue: true,
                          description: const Text(
                              "Automatically adjusts the app's theme according to yours phone's theme."),
                          onToggle: (v) {},
                          onPressed: (_) {
                            showDailySnackBar('Automatic theme switching');
                          },
                          leading: const Icon(Icons.brightness_auto),
                          title: const Text('Auto Theme')),
                      //notifictaions
                      SettingsTile.switchTile(
                          initialValue: true,
                          onToggle: (v) {},
                          onPressed: (_) {
                            showDailySnackBar(
                                'You only receive push notifications.');
                          },
                          leading: const Icon(Icons.notifications),
                          title: const Text('Receive useful notifications')),
                      SettingsTile.switchTile(
                          initialValue: false,
                          leading: const Icon(Icons.lock),
                          onToggle: (v) {},
                          title: const Text('Require password')),
                    ],
                  ),
                  SettingsSection(
                    title: Text(
                      'All',
                      style: sectionTextStyle,
                    ),
                    tiles: <SettingsTile>[
                      // about
                      SettingsTile(
                          title: const Text('About'),
                          leading: const Icon(Icons.info),
                          value: const Text(
                              'Learn more about indiadaily And OTFT'),
                          onPressed: (_) {
                            launchAppUrl(url: 'https://www.otft.in/about');
                          }),
                      // privacy policy
                      SettingsTile(
                          title: const Text('Privacy Policy'),
                          leading: const Icon(Icons.insert_drive_file),
                          value: const Text(
                              'Learn more about indiadaily\'s privacy policy'),
                          onPressed: (_) {
                            launchAppUrl(
                                url:
                                    'https://www.otft.in/india-daily-privacy-policy');
                          }),
                      // t and c
                      SettingsTile(
                          title: const Text('Terms And Conditions'),
                          leading: const Icon(Icons.gavel),
                          value: const Text(
                              'Learn more about indiadaily\'s terms and conditions'),
                          onPressed: (_) {
                            launchAppUrl(
                                url: 'https://www.otft.in/india-daily-t-c');
                          }),
                      // licenses
                      SettingsTile(
                          title: const Text('Licenses'),
                          leading: const Icon(Icons.description),
                          value: const Text(
                              'View additional ceritificates and licenses'),
                          onPressed: (_) {
                            showLicensePage(
                                context: context,
                                applicationIcon:
                                    Center(child: kAppTitle(context)));
                          }),
                      //feedback
                      SettingsTile(
                          title: const Text('Feedback'),
                          leading: const Icon(Icons.feedback),
                          value:
                              const Text('Leave a feedback to the developer'),
                          onPressed: (_) {
                            launchAppUrl(
                                url:
                                    'mailto:info@otft.in?subject=Feedback for India Daily');
                          }),
                    ],
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
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
