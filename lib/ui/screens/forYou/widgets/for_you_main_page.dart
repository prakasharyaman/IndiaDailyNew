import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/models/article.dart';
import 'package:indiadaily/models/news_shot.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/ui/screens/forYou/controller/for_you_controller.dart';
import 'package:indiadaily/ui/screens/webView/default_web_view.dart';
import 'package:indiadaily/ui/widgets/bottom_sheet_tile.dart';
import 'package:indiadaily/ui/widgets/custom/custom_cached_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForYouMainPage extends GetView<ForYouController> {
  const ForYouMainPage(
      {super.key, required this.newsShot, required this.articles});
  final NewsShot newsShot;
  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // latest news shot
          Expanded(
            flex: 3,
            child: homepageNewsShot(context),
          ),
          // top two latest news articles
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  // first article
                  homeArticle(context, article: articles[0]),
                  // second article
                  homeArticle(context, article: articles[1]),
                ],
              ))
        ],
      ),
    );
  }

  Expanded homeArticle(BuildContext context, {required Article article}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/newsWebView', arguments: article);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //image
            Expanded(
                flex: 5,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomCachedImage(
                      imageUrl: article.urlToImage,
                      showPlaceHolder: true,
                      placeHolderColor:
                          Random().nextBool() ? Colors.red : Colors.blue,
                      fit: BoxFit.fitHeight,
                    ))),
            // title
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'FFInfra',
                        ),
                  ),
                )),
            // source name and menu
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      article.source.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      buildArticleBottomSheet(
                          context: context, article: article);
                    },
                    child: const Icon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 15,
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  buildNewsShotBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        isScrollControlled: true,
        builder: (_) {
          return Container(
            height: Get.height * 0.5,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // heading
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: RichText(
                      text: TextSpan(
                          text: 'You\'re seeing this post because you follow ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                        TextSpan(
                          text: newsShot.category == 'all'
                              ? "Latest"
                              : newsShot.category,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ])),
                ),
                // show more like this
                BottomSheetTile(
                    title: "Show more like this",
                    icon: Icons.favorite,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(
                          'Will show more posts from ${newsShot.category == 'all' ? "Latest" : newsShot.category}');
                    }),
                // show less like this
                BottomSheetTile(
                    title: "Show less like this",
                    icon: Icons.hide_source,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(
                          'Will show less posts from ${newsShot.category == 'all' ? "Latest" : newsShot.category}');
                    }),
                // view on web
                BottomSheetTile(
                    title: "View on web",
                    icon: Icons.open_in_new,
                    onTap: () {
                      Get.back();
                      Get.to(DefaultWebView(url: newsShot.readMore));
                    }),
                // copy link
                BottomSheetTile(
                    title: "Copy post link",
                    icon: Icons.add_link,
                    onTap: () {
                      Get.back();
                      showDailySnackBar('Copied article link to clipboard');
                      Clipboard.setData(ClipboardData(text: newsShot.readMore));
                    }),
                // report
                BottomSheetTile(
                    title: "Report",
                    icon: Icons.report,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(
                          'Post Reported! \nWe\'ll look into it.');
                    }),
              ],
            )),
          );
        });
  }

  buildArticleBottomSheet(
      {required BuildContext context, required Article article}) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        isScrollControlled: true,
        builder: (_) {
          return Container(
            height: Get.height * 0.5,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // heading
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: RichText(
                      text: TextSpan(
                          text:
                              'You\'re seeing this article because you follow ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                        TextSpan(
                          text: article.source.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ])),
                ),
                // show more like this
                BottomSheetTile(
                    title: "Show more like this",
                    icon: Icons.favorite,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(
                          'Will show more posts from ${article.source.name}');
                    }),
                // show less like this
                BottomSheetTile(
                    title: "Show less like this",
                    icon: Icons.hide_source,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(
                          'Will show less posts from ${article.source.name}');
                    }),
                // view on web
                BottomSheetTile(
                    title: "View on web",
                    icon: Icons.open_in_new,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/newsWebView", arguments: article);
                    }),
                // copy link
                BottomSheetTile(
                    title: "Copy post link",
                    icon: Icons.add_link,
                    onTap: () {
                      Get.back();
                      showDailySnackBar('Copied article link to clipboard');
                      Clipboard.setData(ClipboardData(text: article.url));
                    }),
                // report
                BottomSheetTile(
                    title: "Report",
                    icon: Icons.report,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(
                          'Article Reported! \nWe\'ll look into it.');
                    }),
              ],
            )),
          );
        });
  }

  homepageNewsShot(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DefaultWebView(url: newsShot.readMore));
      },
      child: Stack(
        children: [
          // image
          Container(
            foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.black38,
                Colors.transparent,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
            child: SizedBox.expand(
              child: CustomCachedImage(
                imageUrl: newsShot.images,
                fit: BoxFit.cover,
                placeHolderColor: Colors.deepPurple,
                showPlaceHolder: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // heading title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    newsShot.title,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontFamily: 'FFInfra',
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                // source and timeago
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // category tag
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Card(
                        color: kPrimaryRed,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
                        shadowColor: Colors.white24,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(
                            newsShot.category == 'all'
                                ? 'Latest'
                                : newsShot.category.capitalizeFirst.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontFamily:
                                        GoogleFonts.archivoBlack().fontFamily,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // time ago shortened
                    Text(
                      timeago.format(newsShot.time, locale: 'en_short'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
