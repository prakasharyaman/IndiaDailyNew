// import 'package:float_column/float_column.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../models/index.dart';
// import '../../constants.dart';
// import '../custom/custom_cached_image.dart';
// import 'article_bottom_row.dart';

// class ArticleRow extends StatelessWidget {
//   const ArticleRow({super.key, required this.article});
//   final Article article;

//   @override
//   Widget build(BuildContext context) {
//     GlobalKey globalKey = GlobalKey();
//     return RepaintBoundary(
//       key: globalKey,
//       child: Scaffold(
//         body: GestureDetector(
//           onTap: () {
//             // open full article in web view
//             Get.toNamed('/newsWebView', arguments: article);
//           },
//           child: Column(
//             children: [
//               //title
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                 child: Text(
//                   article.title,
//                   maxLines: 3,
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontFamily: GoogleFonts.libreBaskerville().fontFamily,
//                       fontWeight: FontWeight.w900),
//                 ),
//               ),
//               Divider(
//                 color: kPrimaryRed,
//                 thickness: 3,
//                 endIndent: Get.width * 0.8,
//               ),
//               // float column with image description and source
//               Expanded(
//                 child: SingleChildScrollView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: FloatColumn(
//                       children: [
//                         // image
//                         Floatable(
//                           float: FCFloat.right,
//                           clearMinSpacing: 10,
//                           maxWidthPercentage: 0.5,
//                           padding: const EdgeInsetsDirectional.all(5),
//                           child: CustomCachedImage(
//                             height: Get.height * 0.15,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             imageUrl: article.urlToImage,
//                           ),
//                         ),
//                         // source and time ago
//                         // Text(
//                         //   timeago.format(article.publishedAt, locale: 'en'),
//                         //   style: Theme.of(context)
//                         //       .textTheme
//                         //       .bodySmall
//                         //       ?.copyWith(
//                         //           fontSize: 8,
//                         //           color: Theme.of(context)
//                         //               .textTheme
//                         //               .bodySmall
//                         //               ?.color
//                         //               ?.withOpacity(0.5),
//                         //           fontFamily:
//                         //               GoogleFonts.libreBaskerville().fontFamily,
//                         //           fontWeight: FontWeight.bold),
//                         // ),
//                         // Text(
//                         //   timeago.format(article.publishedAt, locale: 'en'),
//                         //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         //         color: Theme.of(context)
//                         //             .textTheme
//                         //             .bodySmall
//                         //             ?.color
//                         //             ?.withOpacity(0.2),
//                         //       ),
//                         // ),
//                         // description
//                         Text(
//                           article.description,
//                           maxLines: 15,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium
//                               ?.copyWith(
//                                   fontWeight: FontWeight.w500,
//                                   overflow: TextOverflow.ellipsis),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               ArticleBottomRow(
//                 article: article,
//                 globalKey: globalKey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
