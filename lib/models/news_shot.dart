import 'package:flutter/foundation.dart';

@immutable
class NewsShot {
  const NewsShot({
    required this.author,
    required this.category,
    required this.decription,
    required this.images,
    required this.readMore,
    required this.time,
    required this.title,
  });

  final String author;
  final String category;
  final String decription;
  final String images;
  final String readMore;
  final DateTime time;
  final String title;

  factory NewsShot.fromJson(Map<String, dynamic> json) => NewsShot(
      author: json['author'].toString(),
      category: json['category'].toString(),
      decription: json['decription'].toString().trim(),
      images: json['images'].toString(),
      readMore: json['read-more'].toString(),
      time: DateTime.parse(json['time'].toString()),
      title: json['title'].toString().trim());

  Map<String, dynamic> toJson() => {
        'author': author,
        'category': category,
        'decription': decription,
        'images': images,
        'read-more': readMore,
        'time': time.toIso8601String(),
        'title': title
      };

  NewsShot clone() => NewsShot(
      author: author,
      category: category,
      decription: decription,
      images: images,
      readMore: readMore,
      time: time,
      title: title);

  NewsShot copyWith(
          {String? author,
          String? category,
          String? decription,
          String? images,
          String? readMore,
          DateTime? time,
          String? title}) =>
      NewsShot(
        author: author ?? this.author,
        category: category ?? this.category,
        decription: decription ?? this.decription,
        images: images ?? this.images,
        readMore: readMore ?? this.readMore,
        time: time ?? this.time,
        title: title ?? this.title,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsShot &&
          author == other.author &&
          category == other.category &&
          decription == other.decription &&
          images == other.images &&
          readMore == other.readMore &&
          time == other.time &&
          title == other.title;

  @override
  int get hashCode =>
      author.hashCode ^
      category.hashCode ^
      decription.hashCode ^
      images.hashCode ^
      readMore.hashCode ^
      time.hashCode ^
      title.hashCode;
}
