import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/widgets/custom/bulleted_list.dart';
import 'package:indiadaily/ui/widgets/custom/custom_cached_image.dart';
import 'package:indiadaily/util/string_utils.dart';
import 'package:nested_scroll_views/nested_scroll_views.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../models/news_shot.dart';
import '../../constants.dart';
import '../../screens/webView/default_web_view.dart';
import 'news_shot_bottom_row.dart';

class ListNewsShot extends StatelessWidget {
  const ListNewsShot(
      {super.key, required this.newsShot, this.showGreeting = false});
  final bool showGreeting;
  final NewsShot newsShot;
  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        Get.to(DefaultWebView(url: newsShot.readMore));
      },
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              NestedListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // greetings
                  Visibility(
                    visible: showGreeting,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: Text(
                        "Good ${greeting()}",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.prompt().fontFamily,
                            ),
                      ),
                    ),
                  ),
                  //image
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: CustomCachedImage(
                        height: ((Get.width) - 40) * 0.7,
                        imageUrl: newsShot.images,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RichText(
                      text: TextSpan(
                        text: getCategory(category: newsShot.category),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'FF Infra Bold', color: kPrimaryRed),
                        children: [
                          TextSpan(
                            text: timeago.format(newsShot.time,
                                locale: 'en_short'),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontFamily: 'FF Infra',
                                    ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //title
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      newsShot.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: 'FF Infra Bold',
                          ),
                    ),
                  ),

                  // description bullets
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: BulletedList(
                      listItems:
                          getBulletPoints(paragraph: newsShot.decription),
                    ),
                  ),
                  // just some space
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                ],
              ),
              // bottom action row
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: NewsShotBottomRow(
                    newsShot: newsShot,
                    globalKey: globalKey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
