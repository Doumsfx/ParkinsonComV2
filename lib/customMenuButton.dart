// CustomHomePageTitle Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  final String text;
  final String image;
  final Color backgroundColor;
  final Color textColor;
  final double imageScale;

  CustomMenuButton({super.key, required this.text, required this.image, required this.backgroundColor, required this.textColor, required this.imageScale});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.28,
          width: MediaQuery.of(context).size.height * 0.28,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(70)
          ),
          child: Padding(
            padding: EdgeInsets.all(52 / imageScale - 1),
            child: Image.asset(
              image,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.height * 0.28,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(70)
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,

              ),
            ),
          ),
        ),
      ],
    );
  }
}
