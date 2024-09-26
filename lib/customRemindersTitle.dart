// CustomTitle Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRemindersTitle extends StatelessWidget {
  final String text;
  final String image;
  final double imageScale;
  final Color backgroundColor;
  final Color textColor;
  final double width;

  const CustomRemindersTitle({super.key, required this.text, required this.image, required this.imageScale, required this.backgroundColor, required this.textColor, required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Allows the circle to exceed the limits of the Stack
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: width,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            color: backgroundColor,
          ),
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.085, 0, MediaQuery.of(context).size.height * 0.03, 0),
          child: Align(
            alignment: const Alignment(-1, 0.1),
            child: AutoSizeText(
              text,
              style: GoogleFonts.josefinSans(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 32,
              ),
              maxLines: 1,
              maxFontSize: 32,
              minFontSize: 5,
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.height * 0.1 * -1,
          child: Container(
            width: MediaQuery.of(context).size.height * 0.1875,
            height: MediaQuery.of(context).size.height * 0.1875,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.00625 * 1/imageScale),
              child: Image.asset(
                image,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
