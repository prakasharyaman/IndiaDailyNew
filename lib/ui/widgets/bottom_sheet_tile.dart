import 'package:flutter/material.dart';

class BottomSheetTile extends StatelessWidget {
  const BottomSheetTile(
      {super.key,
      required this.title,
      required this.onTap,
      required this.icon});
  final String title;
  final void Function() onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
