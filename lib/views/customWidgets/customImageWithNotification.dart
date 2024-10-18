// Custom Image With Notification Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomImageWithNotification extends StatelessWidget {
  final double circleSize;
  final EdgeInsets circlePadding;
  final Color circleColor;
  final String image;
  final double sizedBoxWidth;
  final double sizedBoxHeight;
  final int nbNotification;

  const CustomImageWithNotification({super.key, required this.circleSize, required this.circlePadding, required this.circleColor, required this.image, required this.sizedBoxWidth, required this.sizedBoxHeight, required this.nbNotification,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizedBoxWidth,
      height: sizedBoxHeight,
      child: Stack(
        // Allows the circle to exceed the limits of the Stack
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          // Image
          Container(
            height: circleSize,
            width: circleSize,
            padding: circlePadding,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              image,
            ),
          ),

          // Notification
          nbNotification > 0
          ? Container(
            height: circleSize / 2.5,
            width: circleSize / 2.5,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AutoSizeText(
                nbNotification.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 50,
                ),
                maxFontSize: 50,
                minFontSize: 1,
                maxLines: 1,

              ),
            )
          )
          : const SizedBox(),

        ],
      ),
    );
  }
}
