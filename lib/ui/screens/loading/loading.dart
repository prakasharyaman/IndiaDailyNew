import 'package:flutter/material.dart';
import 'package:indiadaily/ui/common/app_title.dart';

class Loading extends StatelessWidget {
  /// Shows a loading screen.
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppTitle(context),
        centerTitle: true,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
