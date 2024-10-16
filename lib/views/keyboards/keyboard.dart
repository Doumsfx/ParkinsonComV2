// Custom Keyboard Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/predictions/prediction.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

class CustomKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> textPredictions;
  late final PredictionsHandler? predictionsHandler;
  final bool forcedPredictionsOff; //Turn to true if you want to disable the predictions (ex : Theme creation)
  final bool forcedLowerCase; // Turn to true if you want to block the text in lower case

  CustomKeyboard({super.key, required this.controller, required this.textPredictions, this.forcedPredictionsOff = false, this.forcedLowerCase = false}) {
    /*
    if (textPredictions.value) {
      predictionsHandler = PredictionsHandler(controller: controller, isFR: langFR);
    }*/
    predictionsHandler = PredictionsHandler(controller: controller, prediLanguage: language, forceDisable: forcedPredictionsOff);
  }

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  // Useful variables
  bool _maj = true;
  bool _modeAccent = false;
  bool _firstKey = true;
  List<List<String>> _keyboard = [
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["MAJ", "", "", "", "", "", "", "'", "?", "!"],
    ["?123", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
  ];
  final Map<String?, bool> _keyScales = {};
  final Map<String, bool> _buttonAnimations = {
    "RETURN": false,
    "BACKSPACE": false,
    "VALIDATE": false,
  };
  final Map<String, double> _wordScales = {
    "WORD 0": 1,
    "WORD 1": 1,
    "WORD 2": 1,
    "WORD 3": 1,
    "WORD 4": 1,
  };

  @override
  void initState() {
    super.initState();

    if(widget.forcedLowerCase){
      _maj = false;
    }

    // Initialisation of our keyboard
    _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);

    // Initialisation of our table of scales
    for (var row in _keyboard) {
      for (var key in row) {
        _keyScales[key] = false;
      }
    }
  }

  /// Utility function to get the keyboard configuration base on [maj], [modeAccent], [azerty]
  List<List<String>> _getKeyboardConfig(bool maj, bool modeAccent, bool azerty) {
    if (modeAccent) {
      return maj
          ? [
              ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
              ["À", "É", "È", "Ê", "Ï", "Ô", "Û", "Ç", '"', ":"],
              ["MAJ", "@", "/", "=", "-", "+", "*", "'", "?", "!"],
              ["ABC", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
            ]
          : [
              ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
              ["à", "é", "è", "ê", "ï", "ô", "û", "ç", '"', ":"],
              ["MAJ", "@", "/", "=", "-", "+", "*", "'", "?", "!"],
              ["ABC", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
            ];
    } else {
      if (azerty) {
        return maj
            ? [
                ["A", "Z", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["Q", "S", "D", "F", "G", "H", "J", "K", "L", "M"],
                ["MAJ", "W", "X", "C", "V", "B", "N", "'", "?", "!"],
                ["?123", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
              ]
            : [
                ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"],
                ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m"],
                ["MAJ", "w", "x", "c", "v", "b", "n", "'", "?", "!"],
                ["?123", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
              ];
      } else {
        return maj
            ? [
                ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"],
                ["K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"],
                ["MAJ", "U", "V", "W", "X", "Y", "Z", "'", "?", "!"],
                ["?123", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
              ]
            : [
                ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"],
                ["k", "l", "m", "n", "o", "p", "q", "r", "s", "t"],
                ["MAJ", "u", "v", "w", "x", "y", "z", "'", "?", "!"],
                ["?123", "TIRET", languagesTextsFile.texts["keyboard_space"], ",", "."]
              ];
      }
    }
  }

  /// Function that manages actions based on keys pressed
  void _onKeyPress(String? keyText) {

    // If it's the first key
    if (_firstKey && keyText != "MAJ" && keyText != "VALIDATE") {
      setState(() {
        _firstKey = false;
        _maj = false;
        _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
      });
    }

    if (keyText == "MAJ" && !widget.forcedLowerCase) {
      setState(() {
        _maj = !_maj;
        _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
      });
    }

    else if (keyText == "MAJ" && widget.forcedLowerCase) {
      // Do nothing
    }

    // To change keyboard mode
    else if (keyText == "?123") {
      setState(() {
        _modeAccent = true;
        _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
      });
    }

    // To change keyboard mode
    else if (keyText == "ABC") {
      setState(() {
        _modeAccent = false;
        _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
      });
    }

    // If the key space is pressed
    else if (keyText == languagesTextsFile.texts["keyboard_space"]) {
      int offset = widget.controller.selection.extentOffset;

      setState(() {
        widget.controller.text = "${widget.controller.text.substring(0, offset)} ${widget.controller.text.substring(offset, widget.controller.text.length)}";
        widget.controller.selection = TextSelection.collapsed(offset: offset + 1);
      });
    }

    // If the key
    else if (keyText == "RETURN") {
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
          }
          else {
            setState(() {
              widget.controller.text = widget.controller.text.substring(0, start) + widget.controller.text.substring(end, widget.controller.text.length);
              widget.controller.selection = TextSelection.collapsed(offset: start);
            });
          }
        }
        if (widget.controller.text.isEmpty) {
          _firstKey = true;
          if(!widget.forcedLowerCase){
            _maj = true;
          }
          _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
        }
      });
    }

    else if (keyText == "BACKSPACE") {
      int offset1 = widget.controller.selection.extentOffset;

      setState(() {
        widget.controller.text = "${widget.controller.text.substring(0, offset1)}\n${widget.controller.text.substring(offset1, widget.controller.text.length)}";
        widget.controller.selection = TextSelection.collapsed(offset: offset1 + 1);
        _firstKey = true;
        if(!widget.forcedLowerCase){
          _maj = true;
        }
        _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
      });
    }

    else if (keyText == "VALIDATE") {
      // We simply put on the origin page (without the keyboard)
      setState(() {
        dialogPageState.value = false;
        newThemePageState.value = false;
        newReminderPageState.value = false;
        newContactPageState.value = false;
        verificationPopUpState.value = false;
      });
    }

    // If the key '-' is pressed
    else if (keyText == "TIRET") {
      int offset1 = widget.controller.selection.extentOffset;

      setState(() {
        widget.controller.text = "${widget.controller.text.substring(0, offset1)}-${widget.controller.text.substring(offset1, widget.controller.text.length)}";
        widget.controller.selection = TextSelection.collapsed(offset: offset1 + 1);
      });
    }

    // For any other keys
    else {
      int offset1 = widget.controller.selection.extentOffset;

      setState(() {
        widget.controller.text = widget.controller.text.substring(0, offset1) + keyText! + widget.controller.text.substring(offset1, widget.controller.text.length);
        widget.controller.selection = TextSelection.collapsed(offset: offset1 + 1);
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
            // Text Predictions
            widget.forcedPredictionsOff
                ?
                // Force the predictions to be turned off
                Container(height: MediaQuery.of(context).size.height * 0.077, width: MediaQuery.of(context).size.width, color: const Color.fromRGBO(69, 73, 76, 1))
                :
                // Predictions can be turned on
                // Detect when disconnected from internet
                ValueListenableBuilder(
                    valueListenable: widget.textPredictions,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.077,
                        width: MediaQuery.of(context).size.width,
                        color: widget.textPredictions.value
                            ? const Color.fromRGBO(87, 138, 227, 1) // Blue
                            : const Color.fromRGBO(69, 73, 76, 1), // Light Grey
                        // Display of predictions
                        child: widget.textPredictions.value
                            ? ValueListenableBuilder(
                                // Refresh when the suggested words list is modified
                                valueListenable: widget.predictionsHandler!.suggestedWordsList,
                                builder: (BuildContext context, List<String> value, Widget? child) {
                                  List<String> nonEmptyValues = value.where((word) => word.isNotEmpty).toList();
                                  int nbValues = nonEmptyValues.length;

                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.077,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: nbValues,
                                      itemBuilder: (BuildContext context, int index) {
                                        if (index != nbValues - 1) {
                                          return Row(
                                            children: [
                                              GestureDetector(
                                                // Let the gesture hit the whole sized box, not only the text
                                                behavior: HitTestBehavior.opaque,
                                                // Animation management
                                                onTapDown: (_) {
                                                  setState(() {
                                                    _wordScales["WORD $index"] = 1.1;
                                                  });
                                                },
                                                onTapUp: (_) {
                                                  setState(() {
                                                    _wordScales["WORD $index"] = 1.0;
                                                    //Complete the sentence with the selected word
                                                    widget.predictionsHandler!.completeSentence(widget.controller.text, nonEmptyValues[index]);
                                                    widget.predictionsHandler!.suggestedWordsList.value = List.empty();
                                                    _firstKey = false;
                                                    _maj = false;
                                                    _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
                                                  });
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    _wordScales["WORD $index"] = 1.0;
                                                  });
                                                },
                                                child: SizedBox(
                                                  // 16 is the size of the VerticalDivider
                                                  width: MediaQuery.sizeOf(context).width / nbValues - 16,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        nonEmptyValues[index],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: MediaQuery.of(context).size.width * 0.025 * _wordScales["WORD $index"]!,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(
                                                thickness: MediaQuery.of(context).size.height * 0.006,
                                                color: Colors.grey,
                                                indent: MediaQuery.of(context).size.height * 0.012,
                                                endIndent: MediaQuery.of(context).size.height * 0.012,
                                              )
                                            ],
                                          );
                                        } else {
                                          return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            // Animation management
                                            onTapDown: (_) {
                                              setState(() {
                                                _wordScales["WORD 4"] = 1.1;
                                              });
                                            },
                                            onTapUp: (_) {
                                              setState(() {
                                                _wordScales["WORD 4"] = 1.0;
                                                // Complete the sentence with the selected word
                                                widget.predictionsHandler!.completeSentence(widget.controller.text, nonEmptyValues[index]);
                                                widget.predictionsHandler!.suggestedWordsList.value = List.empty();
                                                _firstKey = false;
                                                _maj = false;
                                                _keyboard = _getKeyboardConfig(_maj, _modeAccent, azerty);
                                              });
                                            },
                                            onTapCancel: () {
                                              setState(() {
                                                _wordScales["WORD 4"] = 1.0;
                                              });
                                            },
                                            child: SizedBox(
                                              width: MediaQuery.sizeOf(context).width / nbValues,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(nonEmptyValues[index],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: MediaQuery.of(context).size.width * 0.025 * _wordScales["WORD $index"]!,
                                                    )),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                })
                            : const SizedBox(), // No prediction
                      );
                    },
                  ),

            // Keyboard
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // First part of the keyboard
                Container(
                  color: const Color.fromRGBO(34, 39, 42, 1),
                  child: VirtualKeyboard(
                      height: isThisDeviceATablet ? MediaQuery.of(context).size.height * (0.55 - 0.077) : MediaQuery.of(context).size.height * (0.58 - 0.13),
                      width: MediaQuery.of(context).size.width * 0.887,
                      textColor: Colors.white,
                      defaultLayouts: const [VirtualKeyboardDefaultLayouts.Custom],
                      type: VirtualKeyboardType.Custom,
                      keys: _keyboard,
                      builder: (context, key) {
                        // We define the size of the keys
                        Size keySize = key.text == languagesTextsFile.texts["keyboard_space"]
                            ? Size(MediaQuery.of(context).size.width / 2.2, MediaQuery.of(context).size.height / 11)
                            : key.text == "?123" || key.text == "ABC"
                                ? Size(MediaQuery.of(context).size.width / 11.5, MediaQuery.of(context).size.height / 11)
                                : Size(MediaQuery.of(context).size.width / 13, MediaQuery.of(context).size.height / 11);

                        Color backgroundColor = key.text == "MAJ" || key.text == "?123" || key.text == "TIRET" || key.text == "," || key.text == "." || key.text == "ABC" || key.action == VirtualKeyboardKeyAction.Return
                            ? const Color.fromRGBO(51, 56, 59, 1) // Dark Grey
                            : const Color.fromRGBO(69, 73, 76, 1); // Light Grey

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
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  child: key.text == "MAJ"
                                      ? Image.asset(
                                    'assets/maj.png',
                                    height: MediaQuery.of(context).size.height * 0.065,
                                    width: MediaQuery.of(context).size.height * 0.065,
                                  )
                                      : AutoSizeText(
                                    key.text == "TIRET" ? "-" : key.text.toString(),
                                    maxLines: 1,
                                    maxFontSize: 50,
                                    minFontSize: 5,
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
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
