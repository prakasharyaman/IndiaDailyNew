import 'package:flutter/foundation.dart';
import 'index.dart';

@immutable
class Article {
  const Article({
    required this.source,
    this.author,
    required this.title,
    required this.description,
    required this.category,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  final ArticleSource source;
  final String? author;
  final String title;
  final String category;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: ArticleSource.fromJson(json['source'] as Map<String, dynamic>),
        author: json['author']?.toString(),
        title: json['title'].toString(),
        category: json['category'].toString(),
        description: json['description']
            .toString()
            .trim()
            .replaceAll("<ol><li>", "")
            .replaceAll("<li>", "")
            .replaceAll("</li>", "")
            .replaceAll("</ol>", "")
            .replaceAll("<ol>", "")
            .replaceAll("</li><li>", ""),
        url: json['url'].toString(),
        urlToImage: json['urlToImage'].toString(),
        publishedAt: DateTime.parse(json['publishedAt'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'source': source.toJson(),
        'author': author,
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt
      };

  Article clone() => Article(
      source: source.clone(),
      author: author,
      category: category,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt);

  Article copyWith(
          {ArticleSource? source,
          Optional<String?>? author,
          String? title,
          String? description,
          String? url,
          String? category,
          String? urlToImage,
          DateTime? publishedAt}) =>
      Article(
        source: source ?? this.source,
        author: checkOptional(author, () => this.author),
        title: title ?? this.title,
        category: category ?? this.category,
        description: description ?? this.description,
        url: url ?? this.url,
        urlToImage: urlToImage ?? this.urlToImage,
        publishedAt: publishedAt ?? this.publishedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          source == other.source &&
          author == other.author &&
          title == other.title &&
          description == other.description &&
          url == other.url &&
          urlToImage == other.urlToImage &&
          publishedAt == other.publishedAt;

  @override
  int get hashCode =>
      source.hashCode ^
      author.hashCode ^
      title.hashCode ^
      description.hashCode ^
      url.hashCode ^
      urlToImage.hashCode ^
      publishedAt.hashCode;
}

@immutable
class ArticleSource {
  const ArticleSource({
    required this.name,
  });

  final String name;

  factory ArticleSource.fromJson(Map<String, dynamic> json) =>
      ArticleSource(name: json['name'].toString());

  Map<String, dynamic> toJson() => {'name': name};

  ArticleSource clone() => ArticleSource(name: name);

  ArticleSource copyWith({String? name}) => ArticleSource(
        name: name ?? this.name,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ArticleSource && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
