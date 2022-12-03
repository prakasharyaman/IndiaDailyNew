// import 'package:flutter/material.dart';
// import 'package:indiadaily/models/index.dart';
// import 'package:indiadaily/ui/widgets/article/article_column.dart';
// import '../../article/widget/row_article.dart';

// class SecondTwoArticlePage extends StatefulWidget {
//   const SecondTwoArticlePage({super.key, required this.articles});
//   final List<Article> articles;
//   @override
//   State<SecondTwoArticlePage> createState() => _SecondTwoArticlePageState();
// }

// class _SecondTwoArticlePageState extends State<SecondTwoArticlePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(flex: 9, child: ArticleColumn(article: widget.articles[0])),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.0),
//           child: Divider(),
//         ),
//         Expanded(
//             flex: 7,
//             child: RowArticle(
//               article: widget.articles[1],
//             ))
//       ],
//     );
//   }
// }
