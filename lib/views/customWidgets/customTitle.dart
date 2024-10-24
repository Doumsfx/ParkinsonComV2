// Custom Title Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final String image;
  final double imageScale;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double containerWidth;
  final double containerHeight;
  final EdgeInsets containerPadding;
  final double circleSize;
  final double circlePositionedLeft;
  final FontWeight fontWeight;
  final Alignment alignment;
  final double sizedBoxHeight;
  final double sizedBoxWidth;

  const CustomTitle({super.key, required this.text, required this.image, required this.imageScale, required this.backgroundColor, required this.textColor, required this.fontWeight, this.alignment = const Alignment(0, 0), required this.fontSize, required this.containerWidth, required this.containerHeight, required this.containerPadding, required this.circleSize, required this.circlePositionedLeft, this.sizedBoxHeight = 0, this.sizedBoxWidth = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Allows the circle to exceed the limits of the Stack
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        // Text
        Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            color: backgroundColor,
          ),
          padding: containerPadding,
          child: Align(
            alignment: alignment,
            child: SizedBox(
              width: sizedBoxWidth == 0 ? null : sizedBoxWidth,
              height: sizedBoxHeight == 0 ? null : sizedBoxHeight,
              child: AutoSizeText(
                text,
                style: GoogleFonts.josefinSans(
                  color: textColor,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                ),
                maxLines: 1,
                maxFontSize: 100,
                minFontSize: 5,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        // Image
        Positioned(
          left: circlePositionedLeft,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.00625 / imageScale),
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
