// Custom Shape Themes Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/models/variables.dart';

class CustomShapeThemes extends StatelessWidget {
  final String text;
  final String image;
  final Color backgroundColor;
  final Color textColor;

  const CustomShapeThemes({super.key, required this.text, required this.image, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.31,
      height: MediaQuery.of(context).size.height * 0.095,
      child: Stack(
        // Allows the circle to exceed the limits of the Stack
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          // Text
          Container(
            width: MediaQuery.of(context).size.width * 0.31,
            height: MediaQuery.of(context).size.height * 0.067,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              color: backgroundColor,
            ),
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.00625 * 5, 0, MediaQuery.of(context).size.height * 0.00625, 0),
            child: Align(
              alignment: isThisDeviceATablet ? Alignment(-1, MediaQuery.of(context).size.width * 0.01) : Alignment(-1, MediaQuery.of(context).size.width * 0.05),
              child: AutoSizeText(
                text,
                style: GoogleFonts.josefinSans(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                ),
                maxLines: 1,
                maxFontSize: 50,
                minFontSize: 5,
              ),
            ),
          ),

          // Image
          Positioned(
            right: MediaQuery.of(context).size.height * 0.001 * -1,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.014),
                child: Image.asset(
                  image,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
