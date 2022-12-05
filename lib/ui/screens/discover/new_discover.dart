// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:indiadaily/packages/vertical_tab_bar_view.dart';
// import 'package:indiadaily/ui/common/app_title.dart';
// import 'package:indiadaily/ui/constants.dart';
// import 'package:indiadaily/ui/widgets/category_tag.dart';

// class NewDiscover extends StatefulWidget {
//   const NewDiscover({super.key});

//   @override
//   State<NewDiscover> createState() => _NewDiscoverState();
// }

// class _NewDiscoverState extends State<NewDiscover>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 11, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView(
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         // Padding(
//         //   padding: const EdgeInsets.all(20.0),
//         //   child: kAppTitle(context),
//         // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //   child: Text(
        //     'Explore',
        //     style: Theme.of(context)
        //         .textTheme
        //         .headline5
        //         ?.copyWith(fontFamily: 'FF Infra Bold'),
        //   ),
        // ),
//         const SizedBox(
//           height: 20,
//         ),
//         SizedBox(
//             height: Get.height * 0.35,
//             width: Get.width,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: List.generate(
//                 kdiscoverArticlesCategories.length,
//                 (index) => buildDiscoverCard(
//                   onTap: () {},
//                   title: kdiscoverArticlesCategories[index],
//                 ),
//               ),
//             ))
//       ],
//     ));
//   }

//   buildDiscoverCard({required Function onTap, required String title}) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0),
//       child: SizedBox(
//         width: Get.width * 0.8,
//         child: Card(
//           elevation: 2,
//           child: Stack(
//             children: [
//               Image.asset(
//                 'assets/images/$title.jpg',
//                 fit: BoxFit.cover,
//                 height: double.infinity,
//                 width: double.infinity,
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: CategoryTag(
//                   tag: title,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<String> kdiscoverArticlesCategories = [
//     "business",
//     "automobile",
//     "national",
//     "politics",
//     "startup",
//     "world",
//     "entertainment",
//     "health",
//     "science",
//     "sports",
//     "technology"
//   ];
// }
