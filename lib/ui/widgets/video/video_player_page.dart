// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:indiadaily/models/index.dart';
// import 'package:indiadaily/services/share_services.dart';
// import 'package:indiadaily/ui/constants.dart';
// import 'package:indiadaily/ui/screens/feed/controller.dart';
// import 'package:indiadaily/ui/screens/webView/default_web_view.dart';
// import 'package:indiadaily/ui/widgets/category_tag.dart';
// import 'package:indiadaily/ui/widgets/custom/custom_cached_image.dart';
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';
// import 'package:fuzzywuzzy/fuzzywuzzy.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class VideoPlayerPage extends StatefulWidget {
//   const VideoPlayerPage({super.key, required this.video});
//   final Video video;
//   @override
//   State<VideoPlayerPage> createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   FeedController feedController = Get.find<FeedController>();
//   late Video video;
//   late YoutubePlayerController _controller;
//   late PlayerState playerState;
//   double volume = 100;
//   bool muted = false;
//   bool isPlayerReady = false;
//   bool paused = false;
//   List<String> listOfNewsShotTitles() {
//     List<String> x = [];
//     for (var shot in feedController.feedNewsShots) {
//       x.add(shot.title);
//     }
//     return x;
//   }

//   findTheNewsShot({required String title}) {
//     return feedController.feedNewsShots.firstWhere(
//       (element) => element.title == title,
//       orElse: () => feedController.feedNewsShots.last,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     video = widget.video;
//     _controller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(
//               "https://www.youtube.com${widget.video.url}")
//           .toString(),
//       flags: YoutubePlayerFlags(
//         mute: forYouController.isMute,
//         autoPlay: true,
//         disableDragSeek: true,
//         loop: false,
//         isLive: false,
//         hideControls: true,
//         forceHD: false,
//         showLiveFullscreenButton: false,
//         controlsVisibleAtStart: false,
//         enableCaption: false,
//       ),
//     )..addListener(listener);
//     muted = forYouController.isMute;
//     playerState = PlayerState.unknown;
//   }

//   void listener() {
//     if (mounted) {
//       setState(() {
//         playerState = _controller.value.playerState;
//       });
//     }
//   }

//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller.pause();
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         // video player with controls
//         Container(
//           constraints: BoxConstraints(maxHeight: Get.height * 0.5),
//           child: YoutubePlayer(
//             controller: _controller,
//           ),
//         ), //title

//         // Video controls
//         Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   paused = !paused;
//                   setState(() {
//                     paused;
//                   });
//                   paused ? _controller.pause() : _controller.play();
//                 },
//                 icon: Icon(
//                   paused ? Icons.play_arrow : Icons.pause,
//                 )),
//             playerState == PlayerState.buffering ||
//                     playerState == PlayerState.unknown
//                 ? Expanded(
//                     child: LinearProgressIndicator(
//                     backgroundColor:
//                         Theme.of(context).primaryColor.withOpacity(0.1),
//                   ))
//                 : ProgressBar(
//                     controller: _controller,
//                     isExpanded: true,
//                   ),
//             IconButton(
//                 onPressed: () {
//                   muted = !muted;
//                   forYouController.setMute(setMute: muted);
//                   setState(() {
//                     muted;
//                   });
//                   muted ? _controller.mute() : _controller.unMute();
//                 },
//                 icon: Icon(
//                   muted ? Icons.volume_off : Icons.volume_up,
//                 )),
//           ],
//         ),
//         // title
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//           child: Text(
//             video.title,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontFamily: GoogleFonts.libreBaskerville().fontFamily,
//                   fontWeight: FontWeight.w900,
//                 ),
//           ),
//         ),
//         // source
//         //   avatar and name
//         // Padding(
//         //   padding: const EdgeInsets.all(10.0),
//         //   child: Card(
//         //     color: kPrimaryRed,
//         //     margin: EdgeInsets.zero,
//         //     shape: const RoundedRectangleBorder(),
//         //     elevation: 2,
//         //     child: Padding(
//         //       padding:
//         //           const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
//         //       child: Text(
//         //         video.uploaderName,
//         //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//         //             fontWeight: FontWeight.bold, color: Colors.white),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CategoryTag(tag: video.uploaderName),
//               const Spacer(),
//               // Padding(
//               //   padding: const EdgeInsets.all(10.0),
//               //   child: Container(
//               //     padding: const EdgeInsets.all(.5),
//               //     decoration: BoxDecoration(
//               //         color: Get.isDarkMode ? Colors.white : Colors.black,
//               //         shape: BoxShape.circle),
//               //     child: CircleAvatar(
//               //       radius: 10,
//               //       backgroundImage:
//               //           CachedNetworkImageProvider(video.channelAvatar),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),

//         // related article
//         Expanded(
//           child: buildRelatedNewsShot(
//             newsShot: findTheNewsShot(
//                 title: extractOne(
//               query: video.title,
//               choices: listOfNewsShotTitles(),
//             ).choice),
//             // rating: StringSimilarity.findBestMatch(
//             //   video.title,
//             //   listOfNewsShotTitles(),
//             // ).bestMatch.rating,
//           ),
//         ),
//         // views and control button nad uploaded
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // time ago
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.timelapse,
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Text(timeago.format(video.uploaded, locale: "en_short"),
//                       style: Theme.of(context).textTheme.bodySmall),
//                 ],
//               ),
//               //views
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.remove_red_eye,
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Text(NumberFormat.compact().format(video.views),
//                       style: Theme.of(context).textTheme.bodySmall),
//                 ],
//               ),
//               // share
//               GestureDetector(
//                 onTap: () {
//                   ShareServices().shareLink(
//                       url: "https://www.youtube.com${widget.video.url}");
//                 },
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.share,
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text("Share", style: Theme.of(context).textTheme.bodySmall),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     ));
//   }

//   buildRelatedNewsShot({required NewsShot newsShot}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.0),
//           child: Divider(),
//         ),

//         // news shot
//         GestureDetector(
//           onTap: () {
//             Get.to(DefaultWebView(url: newsShot.readMore));
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Featured",
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               // fontFamily: GoogleFonts.libreBaskerville().fontFamily,
//                               fontWeight: FontWeight.w900,
//                             ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10.0, top: 10),
//                         child: Text(
//                           newsShot.title,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall
//                               ?.copyWith(
//                                 fontFamily:
//                                     GoogleFonts.libreBaskerville().fontFamily,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 CustomCachedImage(
//                   imageUrl: newsShot.images,
//                   height: 100,
//                   width: 100,
//                   fit: BoxFit.cover,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.0),
//           child: Divider(),
//         ),
//         const SizedBox(height: 10)
//       ],
//     );
//   }

//   vdoTwitterStyle() {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // gradient background
//           Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     colors: [kOffBlack, Colors.black, kOffBlack],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter)),
//           ),
//           //  video player
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 80.0),
//               child: YoutubePlayer(
//                 controller: _controller,
//               ),
//             ),
//           ),

//           // info widgets
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // seeker and mute ,play pause button
//               Row(
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         paused = !paused;
//                         setState(() {
//                           paused;
//                         });
//                         paused ? _controller.pause() : _controller.play();
//                       },
//                       icon: Icon(
//                         paused ? Icons.play_arrow : Icons.pause,
//                         color: Colors.white,
//                       )),
//                   playerState == PlayerState.buffering ||
//                           playerState == PlayerState.unknown
//                       ? const Expanded(child: LinearProgressIndicator())
//                       : ProgressBar(
//                           controller: _controller,
//                           isExpanded: true,
//                         ),
//                   IconButton(
//                       onPressed: () {
//                         muted = !muted;
//                         forYouController.setMute(setMute: muted);
//                         setState(() {
//                           muted;
//                         });
//                         muted ? _controller.mute() : _controller.unMute();
//                       },
//                       icon: Icon(
//                         muted ? Icons.volume_off : Icons.volume_up,
//                         color: Colors.white,
//                       )),
//                 ],
//               ),
//               //   avatar and name
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(0.5),
//                       decoration: const BoxDecoration(
//                           color: Colors.white, shape: BoxShape.circle),
//                       child: CircleAvatar(
//                         radius: 15,
//                         backgroundImage:
//                             CachedNetworkImageProvider(video.channelAvatar),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: Text(
//                         video.uploaderName,
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               //  title
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                 child: Text(
//                   video.title,
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               // views and control button nad uploaded
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // time ago
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.timelapse,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           timeago.format(video.uploaded, locale: "en_short"),
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall
//                               ?.copyWith(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     //views
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.remove_red_eye,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           NumberFormat.compact().format(video.views),
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall
//                               ?.copyWith(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     // share
//                     GestureDetector(
//                       onTap: () {
//                         ShareServices().shareLink(
//                             url: "https://www.youtube.com${widget.video.url}");
//                       },
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.share,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "Share",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall
//                                 ?.copyWith(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
