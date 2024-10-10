// Custom Shape Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomShape extends StatelessWidget {
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
  final double circlePositionedRight;
  final FontWeight fontWeight;
  final double sizedBoxHeight;
  final double sizedBoxWidth;
  final double scale;

  const CustomShape({super.key, required this.text, required this.image, required this.imageScale, required this.backgroundColor, required this.textColor, required this.fontSize, required this.containerWidth, required this.containerHeight, required this.containerPadding, required this.circleSize, required this.circlePositionedRight, required this.fontWeight, required this.sizedBoxHeight, required this.sizedBoxWidth, required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizedBoxWidth * scale,
      height: sizedBoxHeight * scale,
      child: Stack(
        // Allows the circle to exceed the limits of the Stack
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          // Text
          Container(
            height: containerHeight * scale,
            width: containerWidth * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60 * scale)),
              color: backgroundColor,
            ),
            child: Center(
              child: Padding(
                padding: containerPadding * scale,
                child: AutoSizeText(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                  ),
                  maxLines: 1,
                  minFontSize: 5,
                  maxFontSize: 30,
                ),
              ),
            ),
          ),

          // Image
          Positioned(
            right: circlePositionedRight * scale,
            child: Container(
              width: circleSize * scale,
              height: circleSize * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.016 * scale / imageScale - 1),
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
