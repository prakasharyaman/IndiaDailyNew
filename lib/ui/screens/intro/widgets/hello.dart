import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/ui/constants.dart';

class Hello extends StatelessWidget {
  const Hello({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Text(
        //   'Namaste 🙏🏻\nand',
        //   style: Theme.of(context).textTheme.bodySmall,
        //   textAlign: TextAlign.center,
        // ),
        Text(
          'Welcome to',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        // app title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'India',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontFamily: GoogleFonts.archivoBlack().fontFamily,
                    shadows: <Shadow>[
                      Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 2.0,
                          color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color
                                  ?.withOpacity(0.1) ??
                              Colors.grey.shade50),
                    ],
                  ),
                  children: [
                    TextSpan(
                      text: 'Daily',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontFamily: GoogleFonts.archivoBlack().fontFamily,
                        color: kPrimaryRed,
                        shadows: <Shadow>[
                          Shadow(
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 2.0,
                              color: kPrimaryRed.withOpacity(0.1)),
                        ],
                      ),
                    ),
                  ])),
        ),
        // info
        Text(
          'Let\'s get started,\nSwipe up to continue.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        Icon(
          Icons.arrow_upward,
          shadows: [
            Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 2.0,
                color: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.color
                        ?.withOpacity(0.1) ??
                    Colors.black),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Swipe Up',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 2.0,
                    color: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.color
                            ?.withOpacity(0.1) ??
                        Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
