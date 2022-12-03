import 'dart:math';

import 'package:get/get.dart';

/// Returns a list of sentences seperated at "." intervals from a [paragraph]
List<String> getBulletPoints({required String paragraph}) {
  List<String> bulletPoints = paragraph.split(". ");
  List<String> tempBulp = [];
  for (var element in bulletPoints) {
    if (!(element.length < 5)) {
      tempBulp.add("$element.");
    }
  }
  bulletPoints = tempBulp;

  return bulletPoints;
}

/// Gives an alternate category tag if category is in nonocategroy otherwise returns the same.
String getCategory({required String category}) {
  return '${(nonoCategory.contains(category) ? Random().nextBool() ? 'Latest' : 'Trending' : category).toUpperCase()}  ';
}

/// gives the name of domain , from  a url string by wiping out the www and other stuff
String getDomain({required String url}) {
  return Uri.parse(url)
      .host
      .replaceAll("www.", "")
      .replaceAll(".in", "")
      .replaceAll(".com", "")
      .replaceAll('news.', "")
      .replaceAll(".co", "")
      .replaceAll(".uk", "")
      .replaceAll("amp.", "")
      .capitalizeFirst
      .toString();
}

/// Gives the greeting based on the local time like morning and afternoon.
/// Join good in front before using
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

List<String> nonoCategory = ['general', 'sources', 'all', 'source'];
