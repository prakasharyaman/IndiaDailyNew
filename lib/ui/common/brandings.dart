import 'package:flutter/material.dart';

class Brandings extends StatelessWidget {
  const Brandings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Row(
        children: [
          Card(
            child: Image.asset(
              'assets/images/playBadge.png',
              width: 150,
              fit: BoxFit.cover,
              height: 50,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Card(
            child: Image.asset(
              'assets/images/brand.png',
              width: 150,
              fit: BoxFit.cover,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
