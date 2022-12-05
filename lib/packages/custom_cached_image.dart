import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeHolderColor,
    this.showPlaceHolder = false,
    this.color,
    this.colorBlendMode,
  });

  /// The target image that is displayed.
  final String imageUrl;
  final bool showPlaceHolder;
  final double? width;

  final double? height;

  final BoxFit? fit;

  /// If non-null, this color is blended with each image pixel using [colorBlendMode].
  final Color? color;
  final Color? placeHolderColor;

  ///  * [BlendMode], which includes an illustration of the effect of each blend mode.
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      cacheKey: imageUrl,
      placeholder: (_, s) {
        Color randomColor =
            Random().nextBool() ? Colors.deepPurple : Colors.deepOrange;
        return showPlaceHolder
            ? Container(color: placeHolderColor ?? randomColor)
            : Container();
      },
      errorWidget: (context, url, error) =>
          Container(color: Theme.of(context).primaryColor),
      fadeOutDuration: const Duration(milliseconds: 200),
      fadeInDuration: const Duration(milliseconds: 200),
    );
  }
}
