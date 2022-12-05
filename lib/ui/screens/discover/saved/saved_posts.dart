import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/models/index.dart';
import 'package:indiadaily/services/index.dart';
import 'package:indiadaily/ui/screens/newsShot/widgets/small_news_shot_card.dart';
import '../../article/widget/row_article.dart';

class SavedPosts extends StatelessWidget {
  const SavedPosts({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppTitle(context, 'Saved Posts'),
        centerTitle: false,
      ),
      body: getIt<StorageServices>().savedNewsShots.isNotEmpty ||
              getIt<StorageServices>().savedArticles.isNotEmpty
          ? ListView(
              children: getSavedPosts(),
            )
          : Center(
              child: kAppTitle(context, 'You haven\'t saved any post.'),
            ),
    );
  }

  Widget kAppTitle(context, title) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title.toString(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Theme.of(context).primaryColor,
                fontFamily: GoogleFonts.archivoBlack().fontFamily,
              ),
        ));
  }

  /// gets all the saved posts and return a list of respective widgets sorted by their time
  List<Widget> getSavedPosts() {
    List<NewsShot> newsShots = getIt<StorageServices>().savedNewsShots;
    List<Article> articles = getIt<StorageServices>().savedArticles;
    List<Widget> posts = [];
    // articles.sort((b, a) => a.publishedAt.compareTo(b.publishedAt));
    // newsShots.sort((b, a) => a.time.compareTo(b.time));
    List<Map<String, dynamic>> postsAndTime = [];

    for (var element in articles) {
      postsAndTime.add(
          {'type': 'article', 'time': element.publishedAt, 'val': element});
    }
    for (var element in newsShots) {
      postsAndTime
          .add({'type': 'newsShot', 'time': element.time, 'val': element});
    }
    postsAndTime.sort((b, a) => a['time'].compareTo(b['time']));
    // add to widgets list
    for (var element in postsAndTime) {
      if (element['type'] == 'article') {
        var article = element['val'];
        posts.add(RowArticle(article: article));
      } else if (element['type'] == 'newsShot') {
        var newsShot = element['val'];
        posts.add(SmallNewsShotCard(newsShot: newsShot));
      }
    }
    return posts;
  }
}
