// Custom Menu Button Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  final String text;
  final String image;
  final Color backgroundColor;
  final Color textColor;
  final double imageScale;
  final double scale;
  final EdgeInsets padding;
  final double sizedBoxHeight;

  const CustomMenuButton({super.key, required this.text, required this.image, required this.backgroundColor, required this.textColor, required this.imageScale, required this.scale, this.padding = EdgeInsets.zero, required this.sizedBoxHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image
        Container(
          height: MediaQuery.of(context).size.height * 0.28 * scale,
          width: MediaQuery.of(context).size.height * 0.28 * scale,
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.09 * scale)),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.065 * scale / imageScale - 1),
            child: Image.asset(
              image,
            ),
          ),
        ),

        // Spacing
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015 * scale,
        ),

        // Text
        Container(
          height: MediaQuery.of(context).size.height * 0.09 * scale,
          width: MediaQuery.of(context).size.height * 0.28 * scale,
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.09 * scale)),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.14 * scale,
              height: sizedBoxHeight * scale,
              child: Center(
                child: Padding(
                  padding: padding,
                  child: AutoSizeText(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                    ),
                    maxLines: 1,
                    minFontSize: 10,
                    maxFontSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
