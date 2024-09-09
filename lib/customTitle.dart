// CustomTitle Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final String image;
  final double scale;
  final Color backgroundColor;
  final Color textColor;

  CustomTitle({super.key, required this.text, required this.image, required this.scale, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Allows the circle to exceed the limits of the Stack
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [

        Container(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            color: backgroundColor,
          ),
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.0126, MediaQuery.of(context).size.height * 0.0126, MediaQuery.of(context).size.height * 0.0126, MediaQuery.of(context).size.height * 0.0126),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.josefinSans(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.height > 600
                          ? 32
                          : 28,
              ),
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.height * 0.0625 * -1,
          child: Container(
            width: MediaQuery.of(context).size.height * 0.1875,
            height: MediaQuery.of(context).size.height * 0.1875,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.00625),
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
