// CustomShapeMenu Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomShapeMenu extends StatelessWidget {
  final String text;
  final String image;
  final double imageScale;
  final Color backgroundColor;
  final Color textColor;
  final double scale;

  const CustomShapeMenu({super.key, required this.text, required this.image, required this.imageScale, required this.backgroundColor, required this.textColor, required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2725 * scale,
      height: MediaQuery.of(context).size.width * 0.085 * scale,
      child: Stack(
        // Allows the circle to exceed the limits of the Stack
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.23 * scale,
            height: MediaQuery.of(context).size.width * 0.05 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60 * scale)),
              color: backgroundColor,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01 * scale, 0, MediaQuery.of(context).size.width * 0.035 * scale, 0),
                child: AutoSizeText(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  maxFontSize: 20,
                  minFontSize: 5,
                ),
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.001 * -1 * scale,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.085 * scale,
              height: MediaQuery.of(context).size.width * 0.085 * scale,
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
