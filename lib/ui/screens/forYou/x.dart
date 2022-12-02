import 'package:flutter/material.dart';
import 'package:nested_scroll_views/nested_scroll_views.dart';

class Xs extends StatefulWidget {
  const Xs({super.key});

  @override
  State<Xs> createState() => _XsState();
}

class _XsState extends State<Xs> {
  @override
  Widget build(BuildContext context) {
    return NestedPageView(
      wantKeepAlive: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        NestedListView.builder(
          wantKeepAlive: true,
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => ListTile(
            title: Center(child: Text('Item $index')),
          ),
        ),
        const Center(child: Text('Page 2')),
        NestedListView.builder(
          wantKeepAlive: true,
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => ListTile(
            title: Text('Item $index'),
          ),
        ),
        Center(child: const Text('Page 2')),
      ],
    );
  }
}
