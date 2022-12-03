// import 'package:float_column/float_column.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:indiadaily/models/news_shot.dart';
// import 'package:indiadaily/ui/constants.dart';
// import 'package:indiadaily/ui/screens/webView/default_web_view.dart';
// import 'package:indiadaily/ui/widgets/custom/custom_cached_image.dart';
// import 'package:indiadaily/ui/widgets/newsShot/news_shot_bottom_row.dart';

// class NewsShotRow extends StatelessWidget {
//   const NewsShotRow({super.key, required this.newsShot});
//   final NewsShot newsShot;

//   @override
//   Widget build(BuildContext context) {
//     GlobalKey globalKey = GlobalKey();
//     return RepaintBoundary(
//       key: globalKey,
//       child: GestureDetector(
//         onTap: () {
//           // open full newsShot in web view
//           Get.to(DefaultWebView(url: newsShot.readMore));
//         },
//         child: Column(
//           children: [
//             //title
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//               child: Text(
//                 newsShot.title,
//                 maxLines: 3,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontFamily: GoogleFonts.libreBaskerville().fontFamily,
//                     fontWeight: FontWeight.w900),
//               ),
//             ),
//             Divider(
//               color: kPrimaryRed,
//               thickness: 3,
//               endIndent: Get.width * 0.8,
//             ),
//             // float column with image description and source
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: FloatColumn(
//                     children: [
//                       // image
//                       Floatable(
//                         float: FCFloat.right,
//                         clearMinSpacing: 10,
//                         maxWidthPercentage: 0.5,
//                         padding: const EdgeInsetsDirectional.all(5),
//                         child: CustomCachedImage(
//                           height: Get.height * 0.15,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           imageUrl: newsShot.images,
//                         ),
//                       ),

//                       // description
//                       Text(
//                         newsShot.decription,
//                         maxLines: 15,
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             fontWeight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             NewsShotBottomRow(
//               newsShot: newsShot,
//               globalKey: globalKey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
