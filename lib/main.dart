import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // firebase initialize
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // firebase crash analytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Setup preferred orientations,
    // and then run app.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((value) => runApp(const App()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}
