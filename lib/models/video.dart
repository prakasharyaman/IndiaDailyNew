import 'package:flutter/foundation.dart';

@immutable
class Video {
  const Video({
    required this.channelAvatar,
    required this.url,
    required this.title,
    required this.thumbnail,
    required this.uploaderName,
    required this.uploaderUrl,
    required this.duration,
    required this.views,
    required this.uploaded,
  });

  final String channelAvatar;
  final String url;
  final String title;
  final String thumbnail;
  final String uploaderName;
  final String uploaderUrl;
  final int duration;
  final int views;
  final DateTime uploaded;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
      channelAvatar: json['channelAvatar'].toString(),
      url: json['url'].toString(),
      title: json['title'].toString(),
      thumbnail: json['thumbnail'].toString(),
      uploaderName: json['uploaderName'].toString(),
      uploaderUrl: json['uploaderUrl'].toString(),
      duration: json['duration'] as int,
      views: json['views'] as int,
      uploaded: DateTime.fromMillisecondsSinceEpoch(json['uploaded'] as int));

  Map<String, dynamic> toJson() => {
        'channelAvatar': channelAvatar,
        'url': url,
        'title': title,
        'thumbnail': thumbnail,
        'uploaderName': uploaderName,
        'uploaderUrl': uploaderUrl,
        'duration': duration,
        'views': views,
        'uploaded': uploaded
      };

  Video clone() => Video(
      channelAvatar: channelAvatar,
      url: url,
      title: title,
      thumbnail: thumbnail,
      uploaderName: uploaderName,
      uploaderUrl: uploaderUrl,
      duration: duration,
      views: views,
      uploaded: uploaded);

  Video copyWith(
          {String? channelAvatar,
          String? url,
          String? title,
          String? thumbnail,
          String? uploaderName,
          String? uploaderUrl,
          int? duration,
          int? views,
          DateTime? uploaded}) =>
      Video(
        channelAvatar: channelAvatar ?? this.channelAvatar,
        url: url ?? this.url,
        title: title ?? this.title,
        thumbnail: thumbnail ?? this.thumbnail,
        uploaderName: uploaderName ?? this.uploaderName,
        uploaderUrl: uploaderUrl ?? this.uploaderUrl,
        duration: duration ?? this.duration,
        views: views ?? this.views,
        uploaded: uploaded ?? this.uploaded,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Video &&
          channelAvatar == other.channelAvatar &&
          url == other.url &&
          title == other.title &&
          thumbnail == other.thumbnail &&
          uploaderName == other.uploaderName &&
          uploaderUrl == other.uploaderUrl &&
          duration == other.duration &&
          views == other.views &&
          uploaded == other.uploaded;

  @override
  int get hashCode =>
      channelAvatar.hashCode ^
      url.hashCode ^
      title.hashCode ^
      thumbnail.hashCode ^
      uploaderName.hashCode ^
      uploaderUrl.hashCode ^
      duration.hashCode ^
      views.hashCode ^
      uploaded.hashCode;
}
