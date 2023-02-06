import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/article.dart';
import 'package:indiadaily/services/index.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/custom/screenshot/screenshot.dart';
import '../../../widgets/bottom_sheet_tile.dart';

class ArticleBottomRow extends StatefulWidget {
  const ArticleBottomRow(
      {super.key, required this.article, required this.screenshotController});
  final Article article;

  final ScreenshotController screenshotController;

  @override
  State<ArticleBottomRow> createState() => _ArticleBottomRowState();
}

class _ArticleBottomRowState extends State<ArticleBottomRow> {
  late Article article;
  bool isSaved = false;
  late ScreenshotController screenshotController;
  bool logoError = false;
  @override
  void initState() {
    super.initState();
    screenshotController = widget.screenshotController;

    checkIfSaved();
    article = widget.article;
  }

  checkIfSaved() {
    if (getIt<StorageServices>().savedArticles.contains(widget.article)) {
      setState(() {
        isSaved = true;
      });
    }
  }

  /// saves post to storage
  saveToStorage() async {
    EasyLoading.show();
    try {
      await getIt<StorageServices>().saveArticle(article: widget.article);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Post Saved');
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
      EasyLoading.showError('Couldn\'t save');
    }
  }

  /// remove post from storage
  removePostFromStorage() async {
    EasyLoading.show();
    try {
      await getIt<StorageServices>().removeArticle(article: widget.article);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Post removed');
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
      EasyLoading.showError('Couldn\'t remove');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).colorScheme.background,
              backgroundImage: !logoError
                  ? CachedNetworkImageProvider(
                      'https://www.google.com/s2/favicons?domain=${Uri.parse(article.url).host}&sz=64',
                      errorListener: () {
                      setState(() {
                        logoError = true;
                      });
                    })
                  : const CachedNetworkImageProvider(
                      'https://picsum.photos/64'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            article.source.name.capitalizeFirst.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'FF Infra',
                ),
          ),
          const Spacer(),
          IconButton(
              tooltip: "Share this post.",
              onPressed: () {
                ShareServices()
                    .shareThisPost(screenshotController: screenshotController);
              },
              icon: const Icon(Icons.share)),
          IconButton(
              tooltip: "Save this post.",
              onPressed: () {
                if (!isSaved) {
                  saveToStorage();
                } else {
                  removePostFromStorage();
                }
                setState(() {
                  isSaved = !isSaved;
                });
              },
              icon: Icon(isSaved
                  ? Icons.bookmark_added
                  : Icons.bookmark_add_outlined)),
          IconButton(
              tooltip: "Show more options.",
              onPressed: () {
                buildArticleBottomSheet();
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
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
