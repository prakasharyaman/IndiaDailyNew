import 'package:get/get.dart';
import 'package:indiadaily/app/app.dart';
import 'package:indiadaily/ui/screens/home/home.dart';
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
  ];
}
