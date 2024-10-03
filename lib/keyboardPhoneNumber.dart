// CustomKeyboard Widget
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/variables.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

class CustomKeyboardPhoneNumber extends StatefulWidget {
  final TextEditingController controller;

  const CustomKeyboardPhoneNumber({super.key, required this.controller});

  @override
  State<CustomKeyboardPhoneNumber> createState() => _CustomKeyboardPhoneNumberState();
}

class _CustomKeyboardPhoneNumberState extends State<CustomKeyboardPhoneNumber> {
  // Useful variables
  final List<List<String>> _keyboard = [
    ["7", "8", "9"],
    ["4", "5", "6"],
    ["1", "2", "3"],
    ["", "0", "+"]
  ];
  final Map<String?, bool> _keyScales = {};
  final Map<String, bool> _buttonAnimations = {
    "RETURN": false,
    "BACKSPACE": false,
    "VALIDATE": false,
    "POPUP OK": false,
  };

  @override
  void initState() {
    super.initState();

    // Initialisation of our table of scales
    for (var row in _keyboard) {
      for (var key in row) {
        _keyScales[key] = false;
      }
    }
  }

  // Generic popup to display a specific [text] from the JSON and with an "OK" button
  void _showGenericPopupOK(String text) {
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
                    //Button to quit
                    AnimatedScale(
                      scale: _buttonAnimations["POPUP OK"]! ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceOut,
                      child: GestureDetector(
                        // Animation management
                        onTapDown: (_) {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = true;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = false;
                          });
                          // BUTTON CODE
                          Navigator.pop(context);
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
                            languagesTextsFile.texts["pop_up_ok"]!,
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

  // Function that manages actions based on keys pressed
  void _onKeyPress(String? keyText) {
    print('Key pressed: $keyText');

    if (keyText == "RETURN") {
      setState(() {
        if (widget.controller.text.isNotEmpty) {
          int offset0 = widget.controller.selection.extentOffset;
          int start = widget.controller.selection.start;
          int end = widget.controller.selection.end;

          if (start == end) {
            setState(() {
              widget.controller.text = widget.controller.text.substring(0, offset0 - 1) + widget.controller.text.substring(offset0, widget.controller.text.length);
              widget.controller.selection = TextSelection.collapsed(offset: offset0 - 1);
            });
          } else {
            setState(() {
              widget.controller.text = widget.controller.text.substring(0, start) + widget.controller.text.substring(end, widget.controller.text.length);
              widget.controller.selection = TextSelection.collapsed(offset: start);
            });
          }
        }
      });
    }
    else if (keyText == "VALIDATE") {
      setState(() {
        dialogPageState.value = false;
        newThemePageState.value = false;
        // On verifie le numero de tel
        if(true){
          newContactPageState.value = false;
        }
        else{
          _showGenericPopupOK("Le format de l'heure n'est pas correct");
        }

      });
    }

    // For any other keys
    else if(keyText != ""){
      int offset = widget.controller.selection.extentOffset;

      setState(() {
        widget.controller.text = widget.controller.text.substring(0, offset) + keyText! + widget.controller.text.substring(offset, widget.controller.text.length);
        widget.controller.selection = TextSelection.collapsed(offset: offset + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.height * 0.55 : MediaQuery.of(context).size.height * 0.58,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: const Color.fromRGBO(34, 39, 42, 1),
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).size.height * 0.077, width: MediaQuery.of(context).size.width, color: const Color.fromRGBO(69, 73, 76, 1)),

            // Keyboard
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: const Color.fromRGBO(34, 39, 42, 1),
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: VirtualKeyboard(
                      height: MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.height * (0.55 - 0.077) : MediaQuery.of(context).size.height * (0.58 - 0.13),
                      width: MediaQuery.of(context).size.width * 0.887,
                      textColor: Colors.white,
                      defaultLayouts: const [VirtualKeyboardDefaultLayouts.Custom],
                      type: VirtualKeyboardType.Custom,
                      keys: _keyboard,
                      builder: (context, key) {
                        // We define the size of the keys as well as the font size
                        Size keySize = Size(MediaQuery.of(context).size.width / 13, MediaQuery.of(context).size.height / 11);

                        double fontSize = 20;

                        Color backgroundColor = key.text == "" ? const Color.fromRGBO(34, 39, 42, 1) : const Color.fromRGBO(69, 73, 76, 1);

                        return Container(
                          margin: MediaQuery.of(context).size.height > 600 ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.01) : EdgeInsets.zero,
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _keyScales[key.text] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _keyScales[key.text] = false;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                _keyScales[key.text] = false;
                              });
                            },
                            child: AnimatedScale(
                              scale: _keyScales[key.text] == true ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.bounceOut,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: backgroundColor,
                                  fixedSize: keySize,
                                  minimumSize: const Size(0, 0),
                                  alignment: Alignment.center,
                                  // Allows you to define the click size only on the button
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  _onKeyPress(key.text);
                                },
                                child: Text(
                                  key.text.toString(),
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      onKeyPress: _onKeyPress),
                ),
                Container(
                  color: const Color.fromRGBO(34, 39, 42, 1),
                  height: MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.height * (0.55 - 0.08) : MediaQuery.of(context).size.height * (0.58 - 0.08),
                  width: MediaQuery.of(context).size.width * (1 - 0.887),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedScale(
                        scale: _buttonAnimations["RETURN"] == true ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        child: GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["RETURN"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["RETURN"] = false;
                            });
                            _onKeyPress("RETURN");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["RETURN"] = false;
                            });
                          },
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width / 11.25, MediaQuery.of(context).size.height / 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: const Color.fromRGBO(51, 56, 59, 1)),
                              onPressed: () {
                                _onKeyPress("RETURN");
                              },
                              child: Image.asset(
                                'assets/delete.png',
                                height: 65,
                                width: 65,
                              )),
                        ),
                      ),
                      AnimatedScale(
                        scale: _buttonAnimations["BACKSPACE"] == true ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["BACKSPACE"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["BACKSPACE"] = false;
                            });
                            _onKeyPress("BACKSPACE");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["BACKSPACE"] = false;
                            });
                          },
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width / 11.25, MediaQuery.of(context).size.height / 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: const Color.fromRGBO(87, 138, 227, 1)),
                              onPressed: () {
                                _onKeyPress("BACKSPACE");
                              },
                              child: Image.asset(
                                'assets/backspace.png',
                                height: 65,
                                width: 65,
                              )),
                        ),
                      ),
                      AnimatedScale(
                        scale: _buttonAnimations["VALIDATE"] == true ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["VALIDATE"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["VALIDATE"] = false;
                            });
                            _onKeyPress("VALIDATE");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["VALIDATE"] = false;
                            });
                          },
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(MediaQuery.of(context).size.width / 11.25, MediaQuery.of(context).size.height / 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: const Color.fromRGBO(155, 199, 84, 1),
                              ),
                              onPressed: () {
                                _onKeyPress("VALIDATE");
                              },
                              child: Image.asset(
                                'assets/checkmark.png',
                                height: 65,
                                width: 65,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
