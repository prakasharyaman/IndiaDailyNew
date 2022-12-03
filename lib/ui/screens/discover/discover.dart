import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/discover/saved/saved_posts.dart';
import 'package:indiadaily/ui/screens/discover/topicPage/controller/topic_bindings.dart';
import 'package:indiadaily/ui/screens/discover/topicPage/topic_page.dart';
import 'package:indiadaily/ui/screens/home/controller/home_controller.dart';
import 'package:indiadaily/ui/widgets/category_tag.dart';

import '../../common/app_title.dart';

class Discover extends StatelessWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    var discoverArticlesCategories = kdiscoverArticlesCategories;
    discoverArticlesCategories.shuffle();
    return Scaffold(
      appBar: AppBar(
        title: kAppTitle(context),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomScrollView(
          slivers: [
            //discover heading
            SliverToBoxAdapter(
              child: title(text: 'Discover', context: context),
            ),
            divider(),
            // saved posts and boah
            SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 1.5,
              children: <Widget>[
                gridItem(
                    title: 'saved',
                    onTap: () {
                      Get.to(const SavedPosts(),
                          transition: Transition.rightToLeft);
                    }),
                gridItem(
                    title: 'yourFeed',
                    onTap: () {
                      Get.find<HomeController>().changeBottomNavigationIndex(1);
                    }),
              ],
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            // Topics heading
            SliverToBoxAdapter(
              child: title(text: 'Topics', context: context),
            ),
            divider(),
            // topics grid
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return gridItem(
                      title: discoverArticlesCategories[index],
                      onTap: () {
                        Get.to(const TopicPage(),
                            binding: TopicBindings(
                              topic: discoverArticlesCategories[index]
                                  .toLowerCase(),
                            ),
                            transition: Transition.rightToLeft);
                      });
                },
                childCount: discoverArticlesCategories.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// build a grid item with title and onTap funcion
  Card gridItem({required String title, required Function onTap}) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: const RoundedRectangleBorder(),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/$title.jpg'))),
            alignment: Alignment.bottomLeft,
            child: CategoryTag(tag: title)),
      ),
    );
  }

  /// creates a red divider
  SliverToBoxAdapter divider() {
    // just a divider
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(
        color: kPrimaryRed,
        endIndent: Get.width * 0.9,
        thickness: 3,
      ),
    ));
  }

  /// creates a title heading
  Widget title({required String text, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: GoogleFonts.archivoBlack().fontFamily,
            ),
      ),
    );
  }
}

List<String> kdiscoverArticlesCategories = [
  "business",
  "automobile",
  "national",
  "politics",
  "startup",
  "world",
  "entertainment",
  "health",
  "science",
  "sports",
  "technology"
];
