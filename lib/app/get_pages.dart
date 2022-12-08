import 'package:get/get.dart';
import 'package:indiadaily/app/app.dart';
import 'package:indiadaily/ui/screens/home/home.dart';
import 'package:indiadaily/ui/screens/settings/page/settings_page.dart';
import 'package:indiadaily/ui/screens/user/notifications_history.dart';
import 'package:indiadaily/ui/screens/user/notifications_settings.dart';
import 'package:indiadaily/ui/screens/webView/news_web_view.dart';

List<GetPage> getPages() {
  return [
    GetPage(
      name: '/app',
      page: () => const App(),
    ),
    GetPage(name: '/home', title: 'Home', page: () => Home()),
    GetPage(
      name: '/newsWebView',
      title: 'News Web View',
      page: () => NewsWebView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/settings',
      title: 'Settings',
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/notificationsHistory',
      title: 'NotificationsHistory',
      page: () => const NotificationsHistory(),
      transition: Transition.rightToLeft,
    ),
  ];
}
