import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class ShareServices {
  // late Box<dynamic> box;
  // List<String> newsShotStorageList = [];
  // List<String> articleStorageList = [];
  // static const String newsShotListKey = 'newsShotList';
  // static const String articleListKey = 'articleList';

  void convertWidgetToImageAndShare(BuildContext context,
      GlobalKey containerKey, String title, String url) async {
    List<String> imagePaths = [];
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = containerKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final pth = await getApplicationDocumentsDirectory();
      var directory = pth.path;

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      File imgFile = File('$directory/screenshot.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {
        await Share.shareFiles(imagePaths,
            text: "$title\nMore at: https://bit.ly/indiadaily",
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }).catchError((onError) {
        debugPrint(onError);
      });
    });
  }

  shareLink({required String url}) async {
    await Share.share("$url\nMore at: https://bit.ly/indiadaily ");
  }

  shareAppLink() async {
    try {
      await Share.share("Check out this App: https://bit.ly/indiadaily ");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
