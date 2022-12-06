import 'package:flutter/material.dart';

class HideAbleBottomNavigationBar extends StatelessWidget {
  const HideAbleBottomNavigationBar(
      {super.key, required this.visible, required this.child});

  final Widget child;
  final bool visible;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
      height: visible ? kBottomNavigationBarHeight : 0,
      duration: const Duration(milliseconds: 200),
      child: Wrap(children: [child]));
}
