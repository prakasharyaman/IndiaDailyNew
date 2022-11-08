import 'package:quiver/core.dart';
export 'package:quiver/core.dart';
export 'article.dart';
export 'video.dart';
export 'news_shot.dart';

T? checkOptional<T>(Optional<T?>? optional, T? Function()? def) {
  // No value given, just take default value
  if (optional == null) return def?.call();

  // We have an input value
  if (optional.isPresent) return optional.value;

  // We have a null inside the optional
  return null;
}
