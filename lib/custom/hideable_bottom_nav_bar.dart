import 'package:flutter/material.dart';

class HideAbleBottomNavigationBar extends StatefulWidget {
  const HideAbleBottomNavigationBar(
      {super.key, required this.child, required this.visible});
  final Widget child;
  final bool visible;
  @override
  State<HideAbleBottomNavigationBar> createState() =>
      _HideAbleBottomNavigationBarState();
}

class _HideAbleBottomNavigationBarState
    extends State<HideAbleBottomNavigationBar> {
  @override
  Widget build(BuildContext context) => AnimatedContainer(
      height: widget.visible ? kBottomNavigationBarHeight : 0,
      duration: const Duration(milliseconds: 200),
      child: Wrap(children: [widget.child]));
}
