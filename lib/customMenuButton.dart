// CustomHomePageTitle Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
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
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.09)
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.065 / imageScale - 1),
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
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.09)
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
              child: AutoSizeText(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),

                maxLines: 1,
                minFontSize: 10,
                maxFontSize: 20,

              ),
            ),
          ),
        ),
      ],
    );
  }
}
