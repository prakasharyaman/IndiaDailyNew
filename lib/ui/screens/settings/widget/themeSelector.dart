// ignore_for_file: file_names

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector(
      {Key? key,
      required this.menuOptions,
      required this.selectedOption,
      required this.onValueChanged})
      : super(key: key);
  final List<dynamic> menuOptions;
  final String selectedOption;
  final void Function(dynamic) onValueChanged;
  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
        groupValue: selectedOption,
        // ignore: prefer_for_elements_to_map_fromiterable
        children: Map.fromIterable(
          menuOptions,
          key: (option) => option.key,
          value: (option) => Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(option.icon),
                ),
                Text(option.value),
              ],
            ),
          ),
        ),
        onValueChanged: onValueChanged);
  }
}
