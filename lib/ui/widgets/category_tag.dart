import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

///  builds a tag to show a category
class CategoryTag extends StatelessWidget {
  const CategoryTag({super.key, required this.tag});
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: kPrimaryRed,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        shadowColor: Colors.white24,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Text(
            tag.capitalizeFirst.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontFamily: GoogleFonts.archivoBlack().fontFamily,
                ),
          ),
        ),
      ),
    );
  }
}
