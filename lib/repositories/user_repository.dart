import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UserRepository {
  /// updates every time the user opens app
  updateLastActive({required String userId}) async {
    var profile = {'activeOn': getDateAsTimestamp()};
    updateUserProfile(profile: profile, userId: userId);
  }

  /// adds info regarding model, brand and date of joining
  logUserFirstTimeLogin({required String userId}) async {
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
      var profile = {
        'device': deviceInfo.model,
        'joined': getDateAsTimestamp()
      };
      updateUserProfile(profile: profile, userId: userId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// update anything in user profile by giving a map
  updateUserProfile(
      {required Map<String, dynamic> profile, required String userId}) async {
    // profile["createdAt"] = Timestamp.now();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(profile, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

int getDateAsTimestamp() {
  DateTime dateTime = DateTime.now();
  int day = dateTime.day;
  int month = dateTime.month;
  var year = dateTime.year;
  int timeStamp =
      (DateTime(year, month = month, day = day).millisecondsSinceEpoch) ~/ 1000;
  return timeStamp;
}
