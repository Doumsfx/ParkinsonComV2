// CustomShape Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';

class CustomShape extends StatelessWidget {
  final String text;
  final String image;
  final double scale;
  final Color backgroundColor;
  final Color textColor;

  CustomShape({super.key, required this.text, required this.image, required this.scale, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Allows the circle to exceed the limits of the Stack
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            color: backgroundColor,
          ),
          padding: EdgeInsets.fromLTRB(10 * scale, 10 * scale, 50 * scale, 10 * scale),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Positioned(
          right: -30 * scale,
          child: Container(
            width: 80 * scale,
            height: 80 * scale,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(12, 178, 255, 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(15 * scale),
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