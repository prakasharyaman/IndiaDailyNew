import 'package:flutter/material.dart';

class Unauthenticated extends StatelessWidget {
  const Unauthenticated({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('You are logged out'),
    );
  }
}
