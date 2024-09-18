// CustomHomePageTitle Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHomePageTitle extends StatelessWidget {
  final String text;
  final String image;
  final Color backgroundColor;
  final Color textColor;

  const CustomHomePageTitle({super.key, required this.text, required this.image, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Allows the circle to exceed the limits of the Stack
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [

        // Text
        Container(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            color: backgroundColor,
          ),
          padding: MediaQuery.of(context).size.height > 600
            ? EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.05, MediaQuery.of(context).size.height * 0.008, MediaQuery.of(context).size.height * 0.0126, MediaQuery.of(context).size.height * 0.0126)
            : EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.05, 0, MediaQuery.of(context).size.height * 0.0126, 0),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.josefinSans(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 35,
              ),
            ),
          ),
        ),

        // Image
        Positioned(
          left: MediaQuery.of(context).size.height * 0.0625 * -1,
          child: Container(
            width: MediaQuery.of(context).size.height * 0.1875,
            height: MediaQuery.of(context).size.height * 0.1875,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Image.asset(
              image,
              scale: 1,
            ),
          ),
        ),

      ],
    );
  }
}
