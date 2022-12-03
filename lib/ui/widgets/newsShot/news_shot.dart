// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:indiadaily/models/index.dart';
// import 'package:indiadaily/ui/constants.dart';
// import 'package:indiadaily/ui/screens/webView/default_web_view.dart';
// import 'package:indiadaily/ui/widgets/newsShot/news_shot_bottom_row.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../category_tag.dart';
// import '../custom/custom_cached_image.dart';

// class NewsShotPage extends StatelessWidget {
//   const NewsShotPage({super.key, required this.newsShot});
//   final NewsShot newsShot;

//   @override
//   Widget build(BuildContext context) {
//     GlobalKey globalKey = GlobalKey();
//     Random random = Random();
//     return RepaintBoundary(
//       key: globalKey,
//       child: Scaffold(
//         body: GestureDetector(
//           onTap: () {
//             Get.to(DefaultWebView(url: newsShot.readMore));
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //image
//               Stack(
//                 fit: StackFit.loose,
//                 children: [
//                   CustomCachedImage(
//                     height: Get.height * 0.3,
//                     imageUrl: newsShot.images,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   Positioned(
//                       bottom: 0,
//                       left: 0,
//                       child: CategoryTag(
//                         tag: newsShot.category == 'all'
//                             ? random.nextBool()
//                                 ? 'Latest'
//                                 : 'Trending'
//                             : newsShot.category,
//                       ))
//                 ],
//               ),

//               //title
//               Padding(
//                 padding: const EdgeInsets.only(
//                     bottom: 5.0, left: 10, right: 10, top: 10),
//                 child: Text(
//                   newsShot.title,
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
//               // description
//               Padding(
//                 padding: const EdgeInsets.only(
//                     bottom: 10.0, left: 10, right: 10, top: 5),
//                 child: Text(
//                   newsShot.decription,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Text(
//                   timeago.format(newsShot.time, locale: 'en'),
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         fontSize: 8,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodySmall
//                             ?.color
//                             ?.withOpacity(0.5),
//                       ),
//                 ),
//               ),

//               const Spacer(),
//               NewsShotBottomRow(
//                 newsShot: newsShot,
//                 globalKey: globalKey,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // Padding(
// //                       padding: const EdgeInsets.all(10.0),
// //                       child: Text(
// //                         newsShot.category == 'all'
// //                             ? '#Latest'
// //                             : "#${newsShot.category}",
// //                         style: Theme.of(context).textTheme.titleSmall?.copyWith(
// //                             color: Colors.white,
// //                             backgroundColor: kPrimaryRed,
// //                             fontFamily:
// //                                 GoogleFonts.libreBaskerville().fontFamily,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
