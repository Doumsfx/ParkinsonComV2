// Custom Keyboard Hour Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

/* This keyboard is only for hours input */

import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

import '../../models/popupsHandler.dart';

class CustomKeyboardHour extends StatefulWidget {
  final TextEditingController controller;

  const CustomKeyboardHour({super.key, required this.controller});

  @override
  State<CustomKeyboardHour> createState() => _CustomKeyboardHourState();
}

class _CustomKeyboardHourState extends State<CustomKeyboardHour> {
  // Useful variables
  final List<List<String>> _keyboard = [
    ["7", "8", "9"],
    ["4", "5", "6"],
    ["1", "2", "3"],
    ["0"]
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


  /// Function to check if the time is valid
  bool isTimeValidOrNull(String input) {
    if(input.isEmpty){
      return true;
    }
    else{
      final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
      return timeRegex.hasMatch(input);
    }
  }


  /// Function that manages actions based on keys pressed
  void _onKeyPress(String? keyText) {

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
        if(isTimeValidOrNull(widget.controller.text)){
          newReminderPageState.value = false;
        }
        else{
          Popups.showPopupOk(context, text: languagesTextsFile.texts["pop_up_invalid_hour_format"]!, textOk: languagesTextsFile.texts["pop_up_ok"]!, functionOk: Popups.functionToQuit);
        }

      });
    }
    else if(keyText == "BACKSPACE"){
      // Do nothing
    }

    // For any other keys
    else {
      int offset = widget.controller.selection.extentOffset;

      setState(() {
        if(widget.controller.text.length >= 5){
        }
        else{
          String oldText = widget.controller.text;

          if(widget.controller.text.length >= 3){
            if(!widget.controller.text.contains(":")){
              widget.controller.text = "${widget.controller.text.substring(0, 2)}:${widget.controller.text.substring(2, widget.controller.text.length)}";
            }
          }

          if(offset == 0){
            if(int.parse(keyText!) < 3){
              // Adding the number to the controller text
              widget.controller.text = keyText + widget.controller.text.substring(offset, widget.controller.text.length);
              widget.controller.selection = TextSelection.collapsed(offset: offset + 1);

            }
            else{
              // Adding the number to the controller text
              widget.controller.text = "0$keyText:";
              widget.controller.selection = TextSelection.collapsed(offset: offset + 3);
            }
          }
          else if(offset == 1){
            if(int.parse(keyText!) <= 3 || widget.controller.text[0] == "0" || widget.controller.text[0] == "1"){
              // Adding the number to the controller text
              widget.controller.text = "${widget.controller.text.substring(0, offset)}$keyText${widget.controller.text.substring(offset, widget.controller.text.length)}:";
              widget.controller.selection = TextSelection.collapsed(offset: offset + 2);
            }
          }
          else if(widget.controller.text.indexOf(':') + 1 == offset || widget.controller.text.length <= 2){
            if(int.parse(keyText!) <= 5){
              // Adding the number to the controller text
              widget.controller.text = "${widget.controller.text.substring(0, offset)}$keyText${widget.controller.text.substring(offset, widget.controller.text.length)}";
              widget.controller.selection = TextSelection.collapsed(offset: offset + 1);
            }
            else if(widget.controller.text.length <= 2){
              // Adding the number to the controller text
              widget.controller.text = "${widget.controller.text.substring(0, offset)}:0$keyText${widget.controller.text.substring(offset, widget.controller.text.length)}";
              widget.controller.selection = TextSelection.collapsed(offset: offset + 3);
            }
            else{
              // Adding the number to the controller text
              widget.controller.text = "${widget.controller.text.substring(0, offset)}0$keyText${widget.controller.text.substring(offset, widget.controller.text.length)}";
              widget.controller.selection = TextSelection.collapsed(offset: offset + 2);
            }
          }
          else if(offset == 4){
            if(int.parse(widget.controller.text[3]) <= 5){
              // Adding the number to the controller text
              widget.controller.text = widget.controller.text.substring(0, offset) + keyText! + widget.controller.text.substring(offset, widget.controller.text.length);
              widget.controller.selection = TextSelection.collapsed(offset: offset + 1);
            }
          }
          else{
            // Adding the number to the controller text
            widget.controller.text = widget.controller.text.substring(0, offset) + keyText! + widget.controller.text.substring(offset, widget.controller.text.length);
            widget.controller.selection = TextSelection.collapsed(offset: offset + 1);
          }

          if(widget.controller.text.length >= 3){
            if(!widget.controller.text.contains(":")){
              widget.controller.text = "${widget.controller.text.substring(0, 2)}:${widget.controller.text.substring(2, widget.controller.text.length)}";
            }
          }


          if(widget.controller.text.length > 3){
            if(widget.controller.text.split(":")[0].length != 2){
              widget.controller.text = oldText;
            }
          }

        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.55 : MediaQuery.of(context).size.height * 0.58,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: const Color.fromRGBO(34, 39, 42, 1),
        child: Column(
          children: [
            // The predictions container which in this case is always disabled
            Container(
                height: MediaQuery.of(context).size.height * 0.077,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(69, 73, 76, 1)
            ),

            // Keyboard
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // First part of the keyboard
                Container(
                  color: const Color.fromRGBO(34, 39, 42, 1),
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: VirtualKeyboard(
                      height: isThisDeviceATablet ? MediaQuery.of(context).size.height * (0.55 - 0.077) : MediaQuery.of(context).size.height * (0.58 - 0.13),
                      width: MediaQuery.of(context).size.width * 0.887,
                      textColor: Colors.white,
                      defaultLayouts: const [VirtualKeyboardDefaultLayouts.Custom],
                      type: VirtualKeyboardType.Custom,
                      keys: _keyboard,
                      builder: (context, key) {
                        // We define the size of the keys as well as the font size
                        Size keySize = Size(MediaQuery.of(context).size.width / 13, MediaQuery.of(context).size.height / 11);

                        double fontSize = 20;

                        Color backgroundColor = const Color.fromRGBO(69, 73, 76, 1);

                        return Container(
                          margin: isThisDeviceATablet ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.01) : EdgeInsets.zero,
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

                // Second part of the keyboard (the 3 keys on the right)
                Container(
                  color: const Color.fromRGBO(34, 39, 42, 1),
                  height: isThisDeviceATablet ? MediaQuery.of(context).size.height * (0.55 - 0.08) : MediaQuery.of(context).size.height * (0.58 - 0.08),
                  width: MediaQuery.of(context).size.width * (1 - 0.887),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Return Key
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

                      // Backspace Key
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

                      // Validate Key
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
