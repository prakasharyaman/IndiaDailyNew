// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:indiadaily/models/article.dart';
// import 'package:indiadaily/models/news_shot.dart';
// import 'package:indiadaily/ui/constants.dart';
// import 'package:indiadaily/util/string_utils.dart';
// import 'package:nested_scroll_views/nested_scroll_views.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key, required this.newsShot, required this.articles});
//   final NewsShot newsShot;
//   final List<Article> articles;
//   @override
//   Widget build(BuildContext context) {
//     return NestedListView(
//       children: [
//         const SizedBox(
//           height: 10,
//         ),

//         // top story
//         // newsShotBuilder(context),
//         // const SizedBox(
//         //   height: 10,
//         // ),
//         // Padding(
//         //   padding: const EdgeInsets.all(20.0),
//         //   child: FloatColumn(
//         //     children: [
//         //       // image
//         //       Floatable(
//         //         float: FCFloat.right,
//         //         maxWidthPercentage: 0.3,
//         //         padding: const EdgeInsetsDirectional.all(5),
//         //         child: CustomCachedImage(
//         //           height: Get.height * 0.1,
//         //           width: double.infinity,
//         //           fit: BoxFit.cover,
//         //           imageUrl: articles[0].urlToImage,
//         //         ),
//         //       ),
//         //       // source and time ago
//         //       // Text(
//         //       //   timeago.format(article.publishedAt, locale: 'en'),
//         //       //   style: Theme.of(context)
//         //       //       .textTheme
//         //       //       .bodySmall
//         //       //       ?.copyWith(
//         //       //           fontSize: 8,
//         //       //           color: Theme.of(context)
//         //       //               .textTheme
//         //       //               .bodySmall
//         //       //               ?.color
//         //       //               ?.withOpacity(0.5),
//         //       //           fontFamily:
//         //       //               GoogleFonts.libreBaskerville().fontFamily,
//         //       //           fontWeight: FontWeight.bold),
//         //       // ),
//         //       // Text(
//         //       //   timeago.format(article.publishedAt, locale: 'en'),
//         //       //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//         //       //         color: Theme.of(context)
//         //       //             .textTheme
//         //       //             .bodySmall
//         //       //             ?.color
//         //       //             ?.withOpacity(0.2),
//         //       //       ),
//         //       // ),
//         //       // description
//         //       Text(
//         //         articles[0].title,
//         //         maxLines: 15,
//         //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//         //               fontFamily: 'FF Infra Bold',
//         //             ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }

//   GestureDetector newsShotBuilder(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print(newsShot.readMore);
//       },
//       child: Container(
//         alignment: Alignment.center,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: Get.height * 0.4,
//               width: Get.width,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 20.0, left: 20, right: 20, bottom: 20),
//                 child: Card(
//                   margin: EdgeInsets.zero,
//                   child: Image.network(
//                     newsShot.images,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: RichText(
//                   text: TextSpan(
//                       text: getCategory(category: newsShot.category),
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: kPrimaryRed, fontFamily: 'FF Infra Bold'),
//                       children: [
//                     TextSpan(
//                       text: timeago.format(newsShot.time, locale: 'en_short'),
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall
//                           ?.copyWith(fontWeight: FontWeight.w100),
//                     )
//                   ])),
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//               child: Text(
//                 newsShot.title,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontFamily: 'FF Infra Bold',
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
