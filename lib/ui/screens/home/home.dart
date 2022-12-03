import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/discover/discover.dart';
import 'package:indiadaily/ui/screens/feed/feed.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:indiadaily/ui/screens/market/market.dart';

class Home extends GetView<HomeController> {
  Home({super.key});
  final List<Widget> pages = [
    const Discover(),
    const Feed(),
    const Market(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.homeKey,
        // appBar: AppBar(
        //   title: kAppTitle(context),
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: Icon(
        //       FontAwesomeIcons.barsStaggered,
        //       color: Theme.of(context).textTheme.headline3?.color,
        //     ),
        //     onPressed: () {
        //       controller.advancedDrawerController.showDrawer();
        //     },
        //   ),
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           Get.toNamed('/notificationsSettings');
        //         },
        //         icon: const Icon(FontAwesomeIcons.bell))
        //   ],
        // ),
        body:
            Obx(() => pages.elementAt(controller.bottomNavigationIndex.value)),
        bottomNavigationBar: Obx(() {
          return Visibility(
            visible: controller.isBottombarVisible.value,
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.compass),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.house),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.chartLine),
                  label: 'Market',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.bottomNavigationIndex.value,
              onTap: controller.changeBottomNavigationIndex,
            ),
          );
        }));
  }

  // Widget homeDrawer(BuildContext context) {
  //   return SafeArea(
  //     child: ListTileTheme(
  //       textColor: Colors.white,
  //       iconColor: Colors.white,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           // main logo notihing here
  //           Builder(builder: (context) {
  //             return Container(
  //               width: 128.0,
  //               height: 128.0,
  //               margin: const EdgeInsets.only(
  //                 top: 25.0,
  //                 bottom: 50.0,
  //               ),
  //               clipBehavior: Clip.antiAlias,
  //               decoration: const BoxDecoration(
  //                 // border: Border.all(
  //                 //   color: Colors.white,
  //                 // ),
  //                 // color: kPrimaryRed,
  //                 // boxShadow: [
  //                 //   BoxShadow(
  //                 //       blurRadius: 5,
  //                 //       offset: Offset(5, 5),
  //                 //       color: Colors.black12,
  //                 //       spreadRadius: 5)
  //                 // ],
  //                 shape: BoxShape.circle,
  //               ),
  //             );
  //           }),
  //           //home tile
  //           ListTile(
  //             onTap: () {
  //               controller.advancedDrawerController.hideDrawer();
  //               controller.changeBottomNavigationIndex(1);
  //             },
  //             leading: const Icon(FontAwesomeIcons.house),
  //             title: Text(
  //               'For You',
  //               style: TextStyle(
  //                   fontFamily: GoogleFonts.archivoBlack().fontFamily),
  //             ),
  //           ),
  //           //discover tile
  //           ListTile(
  //             onTap: () {
  //               controller.advancedDrawerController.hideDrawer();
  //               controller.changeBottomNavigationIndex(0);
  //             },
  //             leading: const Icon(FontAwesomeIcons.compass),
  //             title: Text(
  //               'Discover',
  //               style: TextStyle(
  //                   fontFamily: GoogleFonts.archivoBlack().fontFamily),
  //             ),
  //           ),

  //           //market tile
  //           ListTile(
  //             onTap: () {
  //               controller.advancedDrawerController.hideDrawer();
  //               controller.changeBottomNavigationIndex(2);
  //             },
  //             leading: const Icon(FontAwesomeIcons.chartLine),
  //             title: Text(
  //               'Market',
  //               style: TextStyle(
  //                   fontFamily: GoogleFonts.archivoBlack().fontFamily),
  //             ),
  //           ),
  //           // user settings
  //           ListTile(
  //             onTap: () {
  //               controller.advancedDrawerController.hideDrawer();
  //               Get.toNamed('/notificationsSettings');
  //             },
  //             leading: const Icon(FontAwesomeIcons.solidUser),
  //             title: Text(
  //               'Me',
  //               style: TextStyle(
  //                   fontFamily: GoogleFonts.archivoBlack().fontFamily),
  //             ),
  //           ),
  //           //  settings
  //           ListTile(
  //             onTap: () {
  //               controller.advancedDrawerController.hideDrawer();
  //               Get.toNamed('/settings');
  //             },
  //             leading: const Icon(FontAwesomeIcons.gear),
  //             title: Text(
  //               'Settings',
  //               style: TextStyle(
  //                   fontFamily: GoogleFonts.archivoBlack().fontFamily),
  //             ),
  //           ),
  //           //  share App
  //           ListTile(
  //             onTap: () {
  //               controller.advancedDrawerController.hideDrawer();
  //               ShareServices().shareAppLink();
  //             },
  //             leading: const Icon(FontAwesomeIcons.shareNodes),
  //             title: Text(
  //               'Share App',
  //               style: TextStyle(
  //                   fontFamily: GoogleFonts.archivoBlack().fontFamily),
  //             ),
  //           ),

  //           const Spacer(),

  //           Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
  //             child: GestureDetector(
  //               onTap: () {
  //                 launchAppUrl(
  //                     url: 'https://www.otft.in/india-daily-privacy-policy');
  //               },
  //               child: Text(
  //                 'Terms of Service | Privacy Policy',
  //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                     color: Colors.white,
  //                     fontFamily: GoogleFonts.archivo().fontFamily),
  //                 textAlign: TextAlign.start,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
