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

List<String> nonoCategory = ['general', 'sources', 'all'];
