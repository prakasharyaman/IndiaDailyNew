import 'package:flutter/material.dart';
import 'package:indiadaily/models/article.dart';
import 'package:nested_scroll_views/nested_scroll_views.dart';

import 'widget/row_article.dart';

class TwoArticlePage extends StatelessWidget {
  const TwoArticlePage({super.key, required this.articles});

  final List<Article> articles;
  @override
  Widget build(BuildContext context) {
    return NestedListView(
      children: [
        RowArticle(article: articles[0]),
        RowArticle(article: articles[1]),
      ],
    );
  }
}
