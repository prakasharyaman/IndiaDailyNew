import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

Widget kAppTitle(context) {
  return RichText(
    textAlign: TextAlign.left,
    text: TextSpan(
      text: 'India',
      style: Theme.of(context).textTheme.headline4?.copyWith(
            color: Theme.of(context).textTheme.headline4?.color,
            fontFamily: GoogleFonts.archivoBlack().fontFamily,
            // fontFamily: GoogleFonts.montserratSubrayada().fontFamily,
          ),
      children: [
        TextSpan(
          text: 'Daily',
          style: Theme.of(context).textTheme.headline4?.copyWith(
                color: kPrimaryRed,
                fontFamily: GoogleFonts.archivoBlack().fontFamily,
              ),
        ),
      ],
    ),
  );
}

Widget kDifferentAppTitle(context, title) {
  return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title.toString(),
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Theme.of(context).primaryColor,
              fontFamily: GoogleFonts.archivoBlack().fontFamily,
            ),
      ));
}

Widget kCenterAppTitle = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        color: kPrimaryRed,
        child: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
            ' INDIA ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        color: kOffWhite,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            ' DAILY ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: kPrimaryRed,
            ),
          ),
        ),
      ),
    ]);
