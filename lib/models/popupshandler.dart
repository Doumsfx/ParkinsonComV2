// Popups Handler
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';

///Class to handle the generic popups (popup with a single Ok button / popup with a Yes and a No buttons)
class Popups {
  static void showPopupYesOrNo(BuildContext context,
      {required String text, required String textYes, required textNo, required Function(BuildContext) functionYes, required Function(BuildContext context) functionNo, int numberOfExecutionsYes = 1, int numberOfExecutionsNo = 1}) {
    final Map<String, bool> _buttonAnimations = {
      "POPUP YES": false,
      "POPUP NO": false,
    };
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.15),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                    //Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Cancel button
                        AnimatedScale(
                          scale: _buttonAnimations["POPUP NO"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["POPUP NO"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["POPUP NO"] = false;
                              });
                              // BUTTON CODE
                              for (int i = 0; i < numberOfExecutionsNo; i++) {
                                functionNo(context);
                              }
                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["POPUP NO"] = false;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 8.0, screenWidth * 0.1, 8.0),
                              child: Text(
                                textNo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Blank space between the buttons
                        SizedBox(width: screenWidth * 0.15),
                        //Yes button
                        AnimatedScale(
                          scale: _buttonAnimations["POPUP YES"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["POPUP YES"] = true;
                              });
                            },
                            onTapUp: (_) async {
                              setState(() {
                                _buttonAnimations["POPUP YES"] = false;
                              });
                              //BUTTON CODE
                              for (int i = 0; i < numberOfExecutionsYes; i++) {
                                functionYes(context);
                              }
                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["POPUP YES"] = false;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                                color: Colors.lightGreen,
                              ),
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 8.0, screenWidth * 0.1, 8.0),
                              child: Text(
                                textYes,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            );
          });
        });
  }

  static void showPopupOk(BuildContext context, {required String text, required String textOk, required Function(BuildContext) functionOk, int numberOfExecutionsOk = 1}) {
    final Map<String, bool> _buttonAnimations = {
      "POPUP OK": false,
    };
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.15),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                    //Button OK
                    AnimatedScale(
                      scale: _buttonAnimations["POPUP OK"]! ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceOut,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        // Animation management
                        onTapDown: (_) {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = true;
                          });
                        },
                        onTapUp: (_) async {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = false;
                          });
                          //BUTTON CODE
                          for (int i = 0; i < numberOfExecutionsOk; i++) {
                            functionOk(context);
                          }
                        },
                        onTapCancel: () {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = false;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: Colors.lightGreen,
                          ),
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 8.0, screenWidth * 0.1, 8.0),
                          child: Text(
                            textOk,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            );
          });
        });
  }

  static void functionToQuit(BuildContext context) {
    Navigator.of(context).pop();
  }
}
