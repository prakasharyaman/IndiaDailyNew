import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/widgets/article/article_bottom_row.dart';
import 'package:indiadaily/util/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../models/index.dart';
import '../../../widgets/custom/custom_cached_image.dart';

//TODO: screenshot
class RowArticle extends StatelessWidget {
  const RowArticle({super.key, required this.article});

  final Article article;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //title
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            article.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'FF Infra Bold',
                ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FloatColumn(
            children: [
              // article image
              Floatable(
                float: FCFloat.right,
                clearMinSpacing: 10,
                maxWidthPercentage: 0.5,
                padding: const EdgeInsetsDirectional.all(5),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: CustomCachedImage(
                    height: Get.height * 0.15,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: article.urlToImage,
                  ),
                ),
              ),
              // category , published at  and description
              RichText(
                maxLines: 15,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: getCategory(category: article.category),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'FF Infra Bold', color: kPrimaryRed),
                    children: [
                      TextSpan(
                        text:
                            '${timeago.format(article.publishedAt, locale: 'en_short')}\n\n',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'FF Infra',
                            ),
                      ),
                      TextSpan(
                        text: article.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ]),
              ),
            ],
          ),
        ),
        ArticleBottomRow(article: article, globalKey: GlobalKey())
      ],
    );
  }
}
