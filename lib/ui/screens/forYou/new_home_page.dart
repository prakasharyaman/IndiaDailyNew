import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/widgets/newsShot/news_shot_bottom_row.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'controller/for_you_controller.dart';

class NewHomePage extends GetView<ForYouController> {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // app bar
        SliverAppBar(
          floating: true,
          centerTitle: false,
          title: kAppTitle(context),
        ),
        // list of news shots
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: controller.forYouNewsShots.length,
            (BuildContext context, int index) {
              Random random = Random();
              var newsShot = controller.forYouNewsShots[index];
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.27,
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20, bottom: 15),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Image.network(
                            newsShot.images,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: RichText(
                          text: TextSpan(
                              text:
                                  '${(newsShot.category == 'all' ? random.nextBool() ? 'Latest' : 'Trending' : newsShot.category).toUpperCase()}  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: kPrimaryRed,
                                      fontFamily: 'FF Infra'),
                              children: [
                            TextSpan(
                              text: timeago.format(newsShot.time, locale: 'en'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w100),
                            )
                          ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        newsShot.title,
                        style: const TextStyle(
                            fontFamily: 'FF Infra',
                            fontWeight: FontWeight.bold,
                            wordSpacing: -0.5,
                            letterSpacing: -0.5,
                            fontSize: 20),
                      ),
                    ),
                    NewsShotBottomRow(
                      newsShot: newsShot,
                      globalKey: GlobalKey(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
