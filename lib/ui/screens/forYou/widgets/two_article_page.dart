import 'package:flutter/material.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/ui/widgets/article/article_row.dart';

class TwoArticlePage extends StatefulWidget {
  const TwoArticlePage({super.key, required this.articles});
  final List<Article> articles;
  @override
  State<TwoArticlePage> createState() => _TwoArticlePageState();
}

class _TwoArticlePageState extends State<TwoArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: ArticleRow(article: widget.articles[0])),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
          Expanded(child: ArticleRow(article: widget.articles[1])),
        ],
      ),
    );
  }
}
