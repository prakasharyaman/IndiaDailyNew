import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/article.dart';
import '../../constants.dart';
import '../custom/custom_cached_image.dart';
import 'article_bottom_row.dart';

class ArticleColumn extends StatelessWidget {
  const ArticleColumn({super.key, required this.article});
  final Article article;
  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    return RepaintBoundary(
      key: globalKey,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            Get.toNamed('/newsWebView', arguments: article);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: CustomCachedImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: article.urlToImage,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'You might like',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //title
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Text(
                  article.title,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.libreBaskerville().fontFamily,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Divider(
                color: kPrimaryRed,
                thickness: 3,
                endIndent: Get.width * 0.8,
              ),
              // source and time ago
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              //   child: Text(
              //     timeago.format(article.publishedAt, locale: 'en'),
              //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //         fontSize: 8,
              //         color: Theme.of(context)
              //             .textTheme
              //             .bodySmall
              //             ?.color
              //             ?.withOpacity(0.5),
              //         fontFamily: GoogleFonts.libreBaskerville().fontFamily,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              // description
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Text(
                  article.description,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: ArticleBottomRow(
                    article: article,
                    globalKey: globalKey,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
