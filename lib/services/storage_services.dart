import 'dart:convert';
import 'package:indiadaily/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  List<NewsShot> savedNewsShots = [];
  List<Article> savedArticles = [];
  List<String> savedPosts = [];

  /// initializes the storage services
  initialize() async {
    await getStoredPosts();
  }

  /// gets all the posts in storage and adds to class variables
  getStoredPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPosts = prefs.getStringList('savedPosts') ?? [];
    if (savedPosts.isNotEmpty) {
      for (var post in savedPosts) {
        var jsonPost = jsonDecode(post);
        if (jsonPost['type'] == 'article') {
          savedArticles.add(Article.fromJson(jsonPost));
        } else if (jsonPost['type'] == 'newsShot') {
          savedNewsShots.add(NewsShot.fromJson(jsonPost));
        }
      }
    }
  }

  ///saves news shot to storage
  saveNewsShot({required NewsShot newsShot}) async {
    savedNewsShots.add(newsShot);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPosts = prefs.getStringList('savedPosts') ?? [];
    if (savedPosts.length > 50) {
      savedPosts =
          savedPosts.sublist((savedPosts.length - 49), (savedPosts.length - 1));
    }
    var mapPost = newsShot.toJson();
    mapPost['type'] = 'newsShot';
    savedPosts.add(jsonEncode(mapPost));
    await prefs.setStringList('savedPosts', savedPosts);
  }

  /// removes news shot from storage
  removeNewsShot({required NewsShot newsShot}) async {
    savedNewsShots.remove(newsShot);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPosts = prefs.getStringList('savedPosts') ?? [];
    if (savedPosts.length > 50) {
      savedPosts =
          savedPosts.sublist((savedPosts.length - 49), (savedPosts.length - 1));
    }
    var mapPost = newsShot.toJson();
    mapPost['type'] = 'newsShot';
    if (savedPosts.contains(jsonEncode(mapPost))) {
      savedPosts.remove(jsonEncode(mapPost));
    }
    await prefs.setStringList('savedPosts', savedPosts);
  }

  /// saves article to storage
  saveArticle({required Article article}) async {
    savedArticles.add(article);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPosts = prefs.getStringList('savedPosts') ?? [];
    if (savedPosts.length > 50) {
      savedPosts =
          savedPosts.sublist((savedPosts.length - 49), (savedPosts.length - 1));
    }
    var mapPost = article.toJson();
    mapPost['type'] = 'article';
    savedPosts.add(jsonEncode(mapPost));
    await prefs.setStringList('savedPosts', savedPosts);
  }

  /// removes article from storage
  removeArticle({required Article article}) async {
    savedArticles.remove(article);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPosts = prefs.getStringList('savedPosts') ?? [];
    if (savedPosts.length > 50) {
      savedPosts =
          savedPosts.sublist((savedPosts.length - 49), (savedPosts.length - 1));
    }
    var mapPost = article.toJson();
    mapPost['type'] = 'article';
    if (savedPosts.contains(jsonEncode(mapPost))) {
      savedPosts.remove(jsonEncode(mapPost));
    }
    await prefs.setStringList('savedPosts', savedPosts);
  }
}
