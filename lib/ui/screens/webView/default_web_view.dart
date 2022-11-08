import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:indiadaily/services/share_services.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/common/snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets/bottom_sheet_tile.dart';

class DefaultWebView extends StatefulWidget {
  const DefaultWebView({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<DefaultWebView> createState() => _DefaultWebViewState();
}

class _DefaultWebViewState extends State<DefaultWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isPageReady = false;
  late String url;
  @override
  void initState() {
    super.initState();
    url = widget.url;
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
                buildBottomSheet();
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
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String urla) {
          setState(() {
            isPageReady = true;
            url = urla;
          });
        },
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onWebResourceError: (e) {
          Get.back();
          showDailySnackBar('An Error Occured While Loading Story');
        },
        onPageFinished: (String url) {
          // debugPrint(url);
        },
        gestureNavigationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Close this page.",
        onPressed: () {
          Get.back();
        },
        child: const Icon(FontAwesomeIcons.xmark),
      ),
    );
  }

  buildBottomSheet() {
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
                    text: 'Menu :',
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
                ),
                // show more like this
                BottomSheetTile(
                    title: "Show more like this",
                    icon: Icons.favorite,
                    onTap: () {
                      Get.back();
                      showDailySnackBar('Will show more posts from $url');
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
                      Clipboard.setData(ClipboardData(text: url));
                    }),
                // share link
                BottomSheetTile(
                    title: "Share this post link",
                    icon: Icons.share,
                    onTap: () {
                      ShareServices().shareLink(url: url);
                    }),
                // report
                BottomSheetTile(
                    title: "Report",
                    icon: Icons.report,
                    onTap: () {
                      Get.back();
                      showDailySnackBar(' Reported! \nWe\'ll look into it.');
                    }),
              ],
            )),
          );
        });
  }
}
