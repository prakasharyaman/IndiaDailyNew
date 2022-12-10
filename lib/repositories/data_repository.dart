import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/index.dart';

class DataRepository {
  FirebaseFirestore database = FirebaseFirestore.instance;

  /// Get Articles From Server with optional where to customize it.
  /// Also has functionality to load cache from server or cache
  Future<List<Article>> getNewsArticles(
      {String? where,
      List<String>? equals,
      bool loadFromCache = false,
      int limit = 80}) async {
    List<Article> articles = [];
    await database
        .collection('news')
        .doc('articles')
        .collection('articles')
        .where(where ?? "category", whereIn: equals ?? kArticlesCategories)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get(GetOptions(
            source: loadFromCache ? Source.cache : Source.serverAndCache))
        .then((event) {
      for (var doc in event.docs) {
        articles.add(Article.fromJson(doc.data()));
      }
    });
    // sort articles by published date
    articles.sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
    articles.removeWhere((element) =>
        element.source.name == "123telugu.com" ||
        element.source.name == "Tellybest.com");
    return articles;
  }

  /// Get Videos From Server.
  /// Also has functionality to load cache from server or cache
  Future<List<Video>> getVideos({bool loadFromCache = false}) async {
    List<Video> videos = [];
    try {
      await database
          .collection('news')
          .doc('videos')
          .collection('videos')
          .get(GetOptions(
              source: loadFromCache ? Source.cache : Source.serverAndCache))
          .then((event) {
        for (var doc in event.docs) {
          videos.add(Video.fromJson(doc.data()));
        }
      });
    } catch (e) {
      log(e.toString());
    }

    // sort articles by published date
    videos.sort((b, a) => a.uploaded.compareTo(b.uploaded));
    return videos;
  }

  /// Get NewsShot From Server with optional where to customize it.
  /// Also has functionality to load cache from server or cache
  Future<List<NewsShot>> getNewsShots(
      {String? where,
      List<String>? equals,
      bool loadFromCache = false,
      int limit = 60}) async {
    List<NewsShot> shots = [];
    await database
        .collection('news')
        .doc('newsShots')
        .collection("all")
        .where(where ?? "category", whereIn: equals ?? kNewsShotCategories)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get(GetOptions(
            source: loadFromCache ? Source.cache : Source.serverAndCache))
        .then((event) {
      for (var document in event.docs) {
        var doc = document.data();
        if (doc['author'] != null &&
            doc['decription'] != null &&
            doc['images'] != null &&
            doc['inshorts-link'] != null &&
            doc['read-more'] != null &&
            doc['time'] != null &&
            doc['title'] != null) {
          shots.add(NewsShot.fromJson(document.data()));
        } else {
          debugPrint('Skipping : ${document.id}');
        }
      }
    });
    // sort articles by published date
    shots.sort((b, a) => a.time.compareTo(b.time));
    return shots;
  }
}

List<String> kNewsShotCategories = [
  "automobile",
  "science",
  "entertainment",
  "startup",
  "technology",
  "politics",
  "world",
  "sports",
  "all",
  "business",
  "national"
];

List<String> kArticlesCategories = [
  "business",
  "entertainment",
  "general",
  "health",
  "science",
  "source",
  "sports",
  "technology"
];
