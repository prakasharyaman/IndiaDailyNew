import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/screens/loading/loading.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../widgets/category_tag.dart';
import '../../widgets/custom/custom_cached_image.dart';
import '../../widgets/newsShot/news_shot_bottom_row.dart';
import '../webView/default_web_view.dart';

class NotificationNewsShotPage extends StatefulWidget {
  const NotificationNewsShotPage({super.key, required this.newsShot});
  final NewsShot newsShot;
  @override
  State<NotificationNewsShotPage> createState() =>
      _NotificationNewsShotPageState();
}

class _NotificationNewsShotPageState extends State<NotificationNewsShotPage> {
  late NewsShot newsShot;
  @override
  void initState() {
    super.initState();
    newsShot = widget.newsShot;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    return PageView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      children: [
        /// notification newsShot
        buildNotificationnewsShot(globalKey, context),
        // show loading indicator
        const Loading(),
      ],
      onPageChanged: (int index) {
        if (index == 1 || index != 0) {
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.back();
          });
        }
      },
    );
  }

  Scaffold buildNotificationnewsShot(
      GlobalKey<State<StatefulWidget>> globalKey, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppTitle(context),
        centerTitle: false,
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Scaffold(
          body: GestureDetector(
            onVerticalDragEnd: ((details) {}),
            onTap: () {
              Get.to(DefaultWebView(url: newsShot.readMore));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //image
                Stack(
                  fit: StackFit.loose,
                  children: [
                    CustomCachedImage(
                      height: Get.height * 0.3,
                      imageUrl: newsShot.images,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: CategoryTag(
                        tag: newsShot.category == 'all'
                            ? 'Latest'
                            : newsShot.category,
                      ),
                    ),
                  ],
                ),

                //title
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    newsShot.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: GoogleFonts.libreBaskerville().fontFamily,
                        fontWeight: FontWeight.w900),
                  ),
                ),

                // description
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    newsShot.decription,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    timeago.format(newsShot.time, locale: 'en'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 8,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.5),
                        fontFamily: GoogleFonts.libreBaskerville().fontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                const Spacer(),
                NewsShotBottomRow(
                  newsShot: newsShot,
                  globalKey: globalKey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
