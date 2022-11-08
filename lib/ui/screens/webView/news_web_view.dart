import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/models/article.dart';
import 'package:indiadaily/services/share_services.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:indiadaily/ui/widgets/bottom_sheet_tile.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  NewsWebView({
    Key? key,
  }) : super(key: key);
  final Article article = Get.arguments;
  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isPageReady = false;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppTitle(context),
        actions: [
          IconButton(
              onPressed: () {
                buildArticleBottomSheet();
              },
              icon: const Icon(
                FontAwesomeIcons.ellipsisVertical,
                size: 20,
              )),
        ],
        bottom: !isPageReady
            ? const PreferredSize(
                preferredSize: Size(double.infinity, 1),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      extendBodyBehindAppBar: true,
      body: WebView(
        backgroundColor:
            !isPageReady ? Theme.of(context).scaffoldBackgroundColor : null,
        initialUrl: widget.article.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          setState(() {
            isPageReady = true;
          });
        },
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onWebResourceError: (e) {
          Get.back();
          showDailySnackBar('An Error Occured While Loading Story');
        },
        gestureNavigationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        tooltip: "Close this page.",
        child: const Icon(FontAwesomeIcons.xmark),
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
                              'You\'re seeing this article because you follow ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                        TextSpan(
                          text: widget.article.source.name,
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
                          'Will show more posts from ${widget.article.source.name}');
                    }),
                // show less like this
                BottomSheetTile(
                    title: "Show less like this",
                    icon: Icons.hide_source,
                    onTap: () {}),

                // copy link
                BottomSheetTile(
                    title: "Copy post link",
                    icon: Icons.add_link,
                    onTap: () {
                      Get.back();
                      showDailySnackBar('Copied article link to clipboard');
                      Clipboard.setData(
                          ClipboardData(text: widget.article.url));
                    }),
                // share link
                BottomSheetTile(
                    title: "Share this post link",
                    icon: Icons.share,
                    onTap: () {
                      ShareServices().shareLink(url: widget.article.url);
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
