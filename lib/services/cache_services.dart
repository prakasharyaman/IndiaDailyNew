import 'dart:developer';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheServices {
  /// Download images to cache.
  cacheImages({required List<String> imageUrlList}) async {
    for (String imageUrl in imageUrlList) {
      FileInfo? fileInfo =
          await DefaultCacheManager().getFileFromCache(imageUrl);
      if (fileInfo != null) {
        // check if file exist or not
        if (!await fileInfo.file.exists()) {
          try {
            await DefaultCacheManager()
                .downloadFile(imageUrl, key: imageUrl.toString());
          } catch (e) {
            log(e.toString());
          }
        }
      } else {
        // download the image to cache
        try {
          await DefaultCacheManager()
              .downloadFile(imageUrl, key: imageUrl.toString());
        } catch (e) {
          log(e.toString());
        }
      }
    }
  }
}
