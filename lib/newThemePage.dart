// List of themes Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/keyboard.dart';
import 'package:parkinson_com_v2/models/database/theme.dart';
import 'package:parkinson_com_v2/variables.dart';

class NewThemePage extends StatefulWidget {
  const NewThemePage({super.key});

  @override
  State<NewThemePage> createState() => _NewThemePageState();
}

class _NewThemePageState extends State<NewThemePage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "RELAX": false,
    "SAVE": false,
    "POPUP OK": false,
    "POPUP NO": false,
    "POPUP YES": false,
  };
  final TextEditingController _controller = TextEditingController();
  late CustomKeyboard customKeyboard;

  @override
  void initState() {
    super.initState();
    customKeyboard = CustomKeyboard(controller: _controller, textPredictions: isConnected, forcedPredictionsOff: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
      body: ValueListenableBuilder<bool>(
          valueListenable: newThemePageState,
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Arrow
                value
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Arrow
                          Container(
                            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.013, MediaQuery.of(context).size.width * 0.02, 0),
                            child: AnimatedScale(
                              scale: (_buttonAnimations["BACK ARROW"] ?? false) ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["BACK ARROW"] = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["BACK ARROW"] = false;
                                  });
                                  Navigator.pop(context);
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["BACK ARROW"] = false;
                                  });
                                },
                                child: Image.asset(
                                  "assets/fleche.png",
                                  height: MediaQuery.of(context).size.width * 0.05,
                                  width: MediaQuery.of(context).size.width * 0.07,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),

                // Titles + TextField + Save Button
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        // Title
                        value
                            ? const SizedBox()
                            : Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                                child: Text(
                                  languagesTextsFile.texts["new_theme_title"],
                                  style: GoogleFonts.josefinSans(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                        // Subtitle
                        value
                            ? const SizedBox()
                            : Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                child: Text(
                                  languagesTextsFile.texts["new_theme_subtitle"],
                                  style: GoogleFonts.josefinSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                        // TextField
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.height * 0.11 : MediaQuery.of(context).size.height * 0.13,
                          margin: MediaQuery.of(context).size.height > 600 ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13) : EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 183, 34, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(MediaQuery.of(context).size.width * 0.045),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.02,
                              0,
                              MediaQuery.of(context).size.width * 0.02,
                              0,
                            ),
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color.fromRGBO(50, 50, 50, 1),
                                overflow: TextOverflow.ellipsis,
                              ),

                              controller: _controller,
                              readOnly: true, // a mettre en true
                              showCursor: true,
                              enableInteractiveSelection: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromRGBO(255, 183, 34, 1),
                                iconColor: const Color.fromRGBO(255, 183, 34, 1),
                                focusColor: const Color.fromRGBO(255, 183, 34, 1),
                                hoverColor: const Color.fromRGBO(255, 183, 34, 1),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(255, 183, 34, 1),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(255, 183, 34, 1),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(255, 183, 34, 1),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                hintText: languagesTextsFile.texts["new_theme_hint_text"],
                              ),

                              onTap: () {
                                setState(() {
                                  newThemePageState.value = true;
                                });
                                print("TOUCHEEEEEEEEEEEEEEE");
                              },
                            ),
                          ),
                        ),

                        // Save Button
                        Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                          child: AnimatedScale(
                            scale: _buttonAnimations["SAVE"] == true ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceOut,
                            child: GestureDetector(
                              // Animation management
                              onTapDown: (_) {
                                setState(() {
                                  _buttonAnimations["SAVE"] = true;
                                });
                              },
                              onTapUp: (_) async {
                                setState(() {
                                  _buttonAnimations["SAVE"] = false;
                                });
                                // BUTTON CODE
                                // Save button
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    //Popup Can't save an empty theme
                                    double screenWidth = MediaQuery.of(context).size.width;
                                    double screenHeight = MediaQuery.of(context).size.height;
                                    if (_controller.text.isEmpty) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(
                                            backgroundColor: Colors.black87,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: screenHeight * 0.1, width: screenWidth * 0.95),
                                                  Text(
                                                    languagesTextsFile.texts["pop_up_cant_save_theme"],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenHeight * 0.1),
                                                  //Button to close the popup
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
                                                          languagesTextsFile.texts["pop_up_ok"],
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screenHeight * 0.03)
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    //Popup Theme added with success
                                    else {
                                      //Add the theme into the database
                                      databaseManager.insertTheme(ThemeObject(title: _controller.text, language: langFR ? "fr" : "nl"));

                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(
                                            backgroundColor: Colors.black87,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: screenHeight * 0.1, width: screenWidth * 0.95),
                                                  Text(
                                                    languagesTextsFile.texts["pop_up_save_theme"],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenHeight * 0.1),
                                                  //Button to close the popup
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
                                                      onTapUp: (_) {
                                                        setState(() {
                                                          newThemePageState = ValueNotifier<bool>(false);
                                                          _buttonAnimations["POPUP OK"] = false;
                                                        });

                                                        // Redirection
                                                        Navigator.pop(context); // Quit popup
                                                        Navigator.pop(context); // Get back to list
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
                                                          languagesTextsFile.texts["pop_up_ok"],
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
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                              onTapCancel: () {
                                setState(() {
                                  _buttonAnimations["SAVE"] = false;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Color.fromRGBO(61, 192, 200, 1),
                                ),
                                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.015, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.015),
                                child: Text(
                                  languagesTextsFile.texts["new_theme_save"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Space
                        value ? const Expanded(child: SizedBox()) : const SizedBox(),

                        // Keyboard
                        value ? customKeyboard : const SizedBox(),
                      ],
                    ),
                  ),
                ),

                // Buttons at the right
                value
                    ? const SizedBox()
                    : Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.012),
                        child: Column(
                          children: [
                            AnimatedScale(
                              scale: _buttonAnimations["HELP"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                // Animation management
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["HELP"] = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["HELP"] = false;
                                  });
                                  // BUTTON CODE
                                  print("HELLLLLLLLLLP");
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["HELP"] = false;
                                  });
                                },

                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.03),
                                  child: Image.asset(
                                    "assets/helping_icon.png",
                                    height: MediaQuery.of(context).size.width * 0.06,
                                    width: MediaQuery.of(context).size.width * 0.06,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedScale(
                              scale: _buttonAnimations["HOME"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["HOME"] = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["HOME"] = false;
                                  });
                                  // BUTTON CODE
                                  Navigator.popUntil(
                                    context,
                                        (route) => route.isFirst,
                                  );
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["HOME"] = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.03),
                                  child: Image.asset(
                                    "assets/home.png",
                                    height: MediaQuery.of(context).size.width * 0.06,
                                    width: MediaQuery.of(context).size.width * 0.06,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedScale(
                              scale: _buttonAnimations["RELAX"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["RELAX"] = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["RELAX"] = false;
                                  });
                                  // BUTTON CODE
                                  print("RELAAAAAAAAAX");
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["RELAX"] = false;
                                  });
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.width * 0.060,
                                  width: MediaQuery.of(context).size.width * 0.060,
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(160, 208, 86, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/beach-chair.png",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          }),
    );
  }
}
