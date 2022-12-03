// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:indiadaily/ui/common/app_title.dart';
// import 'controller/for_you_controller.dart';

// class NewHomePage extends GetView<ForYouController> {
//   const NewHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         const SliverToBoxAdapter(
//           child: SizedBox(height: 20),
//         ),
//         // app bar
//         SliverAppBar(
//           floating: true,
//           centerTitle: false,
//           expandedHeight: 80,
//           title: kAppTitle(context),
//         ),

//         // list of news shots
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             childCount: controller.forYouNewsShots.length,
//             (BuildContext context, int index) {},
//           ),
//         ),
//       ],
//     );
//   }
// }
