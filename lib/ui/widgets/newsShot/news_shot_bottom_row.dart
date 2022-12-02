import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/services/index.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/ui/screens/webView/default_web_view.dart';
import '../bottom_sheet_tile.dart';

class NewsShotBottomRow extends StatefulWidget {
  const NewsShotBottomRow(
      {super.key, required this.newsShot, required this.globalKey});
  final NewsShot newsShot;
  final GlobalKey globalKey;
  @override
  State<NewsShotBottomRow> createState() => _NewsShotBottomRowState();
}

class _NewsShotBottomRowState extends State<NewsShotBottomRow> {
  late NewsShot newsShot;
  bool isSaved = false;
  @override
  void initState() {
    super.initState();
    checkIfSaved();
    newsShot = widget.newsShot;
  }

  checkIfSaved() {
    if (getIt<StorageServices>().savedNewsShots.contains(widget.newsShot)) {
      setState(() {
        isSaved = true;
      });
    }
  }

  /// saves post to storage
  saveToStorage() async {
    EasyLoading.show();
    try {
      await getIt<StorageServices>().saveNewsShot(newsShot: widget.newsShot);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Post Saved');
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
      EasyLoading.showError('Couldn\'t save');
    }
  }

  /// remove post from storage
  removeFromStorage() async {
    EasyLoading.show();
    try {
      await getIt<StorageServices>().removeNewsShot(newsShot: widget.newsShot);
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
    return // functions
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
              'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=' +
                  newsShot.readMore +
                  '&size=128',
            ),
          ),
          Spacer(),
          IconButton(
              tooltip: "Share this post.",
              onPressed: () {
                ShareServices().convertWidgetToImageAndShare(
                    context, widget.globalKey, newsShot.title, '');
              },
              icon: const Icon(Icons.share)),
          IconButton(
              tooltip: "Save this post.",
              onPressed: () {
                if (!isSaved) {
                  saveToStorage();
                } else {
                  removeFromStorage();
                }
                setState(() {
                  isSaved = !isSaved;
                });
              },
              icon: Icon(isSaved ? Icons.check : Icons.add)),
          IconButton(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
              tooltip: "Open menu.",
              onPressed: () {
                buildNewsShotBottomSheet();
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  buildNewsShotBottomSheet() {
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
                              : newsShot.category.capitalizeFirst,
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
}
