import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  /// Shows a loading screen.
  const Loading({super.key, this.centerTitle = true});
  final bool centerTitle;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
