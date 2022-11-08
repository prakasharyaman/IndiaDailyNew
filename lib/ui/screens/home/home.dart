import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/discover/discover.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:indiadaily/ui/screens/forYou/for_you.dart';
import 'package:indiadaily/ui/screens/user/user_settings.dart';

class Home extends GetView<HomeController> {
  Home({super.key});
  final List<Widget> pages = [
    const Discover(),
    const ForYou(),
    const UserSettings(),
  ];
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Theme.of(context).primaryColor,
      controller: controller.advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      drawer: homeDrawer(context),
      child: Scaffold(
          key: controller.homeKey,
          body: Obx(
              () => pages.elementAt(controller.bottomNavigationIndex.value)),
          bottomNavigationBar: Obx(() {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
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
                    icon: Icon(FontAwesomeIcons.solidUser),
                    label: 'User Settings',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.bottomNavigationIndex.value,
                onTap: controller.changeBottomNavigationIndex,
              ),
            );
          })),
    );
  }

  Widget homeDrawer(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // main logo notihing here
            Builder(builder: (context) {
              return Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 50.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.white,
                  // ),
                  // color: kPrimaryRed,
                  // boxShadow: [
                  //   BoxShadow(
                  //       blurRadius: 5,
                  //       offset: Offset(5, 5),
                  //       color: Colors.black12,
                  //       spreadRadius: 5)
                  // ],
                  shape: BoxShape.circle,
                ),
              );
            }),
            //home tile
            ListTile(
              onTap: () {
                controller.advancedDrawerController.hideDrawer();
                controller.changeBottomNavigationIndex(1);
              },
              leading: const Icon(FontAwesomeIcons.house),
              title: const Text('For You'),
            ),
            //discover tile
            ListTile(
              onTap: () {
                controller.advancedDrawerController.hideDrawer();
                controller.changeBottomNavigationIndex(0);
              },
              leading: const Icon(FontAwesomeIcons.compass),
              title: const Text('Discover'),
            ),
            //TODO: add market here
            //market tile
            // ListTile(
            //   onTap: () {
            //     controller.advancedDrawerController.hideDrawer();
            //     controller.changeBottomNavigationIndex(2);
            //   },
            //   leading: const Icon(FontAwesomeIcons.chartLine),
            //   title: const Text('Market'),
            // ),
            // user settings
            ListTile(
              onTap: () {
                controller.advancedDrawerController.hideDrawer();
                controller.changeBottomNavigationIndex(2);
              },
              leading: const Icon(FontAwesomeIcons.solidUser),
              title: const Text('Profile'),
            ),
            //  settings
            ListTile(
              onTap: () {
                controller.advancedDrawerController.hideDrawer();
                controller.changeBottomNavigationIndex(0);
              },
              leading: const Icon(FontAwesomeIcons.gear),
              title: const Text('Settings'),
            ),
            //  share App
            ListTile(
              onTap: () {
                controller.advancedDrawerController.hideDrawer();
                controller.changeBottomNavigationIndex(0);
              },
              leading: const Icon(FontAwesomeIcons.shareNodes),
              title: const Text('Share App'),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Terms of Service | Privacy Policy',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
