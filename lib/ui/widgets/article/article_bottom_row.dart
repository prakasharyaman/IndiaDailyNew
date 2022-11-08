import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/article.dart';
import 'package:indiadaily/services/share_services.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../bottom_sheet_tile.dart';

class ArticleBottomRow extends StatefulWidget {
  const ArticleBottomRow(
      {super.key, required this.article, required this.globalKey});
  final Article article;
  final GlobalKey globalKey;
  @override
  State<ArticleBottomRow> createState() => _ArticleBottomRowState();
}

class _ArticleBottomRowState extends State<ArticleBottomRow> {
  late Article article;
  @override
  void initState() {
    super.initState();
    article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
              "${article.source.name} ${timeago.format(article.publishedAt, locale: 'en_short')}",
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall),
        )),
        IconButton(
            tooltip: "Share this post.",
            onPressed: () {
              ShareServices().convertWidgetToImageAndShare(
                  context, widget.globalKey, article.title, "");
            },
            icon: const Icon(Icons.share)),
        IconButton(
            tooltip: "Save this post.",
            onPressed: () {},
            icon: const Icon(Icons.add)),
        IconButton(
            tooltip: "Show more options.",
            onPressed: () {
              buildArticleBottomSheet();
            },
            icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  buildArticleBottomSheet() {
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
                              'This post is recommended based on your recent intrests and is from ',
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
                // share link
                BottomSheetTile(
                    title: "Share this post link",
                    icon: Icons.share,
                    onTap: () {
                      ShareServices().shareLink(url: article.url);
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
}
