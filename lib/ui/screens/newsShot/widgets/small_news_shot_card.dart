import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/newsShot/news_shot_page.dart';
import 'package:indiadaily/ui/widgets/custom/screenshot/screenshot.dart';
import 'package:indiadaily/util/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'news_shot_bottom_row.dart';

class SmallNewsShotCard extends StatelessWidget {
  const SmallNewsShotCard(
      {super.key, required this.newsShot, this.showCategory = true});
  final NewsShot newsShot;
  final bool showCategory;
  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();
    return Screenshot(
      controller: screenshotController,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: Get.height * 0.9, minHeight: Get.height * 0.9),
              builder: (context) {
                return Scaffold(
                  body: NewsShotPage(newsShot: newsShot),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(FontAwesomeIcons.xmark),
                  ),
                );
              });
        },
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                            "${showCategory ? getCategory(category: newsShot.category) : ""} ",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kPrimaryRed, fontFamily: 'FF Infra Bold'),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(
                  newsShot.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontFamily: 'FF Infra Bold'),
                ),
              ),
              NewsShotBottomRow(
                newsShot: newsShot,
                screenshotController: screenshotController,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Divider(),
              // ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
