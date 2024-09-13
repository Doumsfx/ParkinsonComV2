// List of themes Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/keyboard.dart';
import 'package:parkinson_com_v2/listThemesPage.dart';
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
  };
  final TextEditingController _controller = TextEditingController();
  late CustomKeyboard customKeyboard;

  @override
  void initState() {
    super.initState();
    customKeyboard = CustomKeyboard(controller: _controller, textPredictions: true);

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
                    ? SizedBox()
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Arrow
                    Container(
                      margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.013, MediaQuery.of(context).size.width * 0.02, 0),
                      child: AnimatedScale(
                        scale: (_buttonAnimations["BACK ARROW"] ?? false) ? 1.1 : 1.0,

                        duration:
                        const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        child: GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["BACK ARROW"] =
                              true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["BACK ARROW"] =
                              false;
                            });
                            Navigator.pop(context);
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["BACK ARROW"] =
                              false;
                            });
                          },
                          child: Image.asset(
                            "assets/fleche.png",
                            height: MediaQuery.of(context)
                                .size
                                .width *
                                0.05,
                            width: MediaQuery.of(context)
                                .size
                                .width *
                                0.07,
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
                          ? SizedBox()
                          : Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                            child: Text(
                              'Nouveau Thème',
                              style: GoogleFonts.josefinSans(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),


                        // Subtitle
                        value
                          ? SizedBox()
                          : Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            child: Text(
                              'Indiquez ci-dessous le nom de votre nouveau thème',
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
                          height: MediaQuery.of(context).size.height > 600
                            ? MediaQuery.of(context).size.height * 0.11
                            : MediaQuery.of(context).size.height * 0.13,
                          margin: MediaQuery.of(context).size.height > 600
                            ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13)
                            : EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
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
                                    color: Color.fromRGBO(255, 183, 34, 1),),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.045),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(255, 183, 34, 1),),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.045),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(255, 183, 34, 1),),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.045),
                                  ),
                                ),
                                hintText: langFR
                                    ? 'Nom du thème'
                                    : '...',
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
                            scale: _buttonAnimations["SAVE"] == true
                                ? 1.1
                                : 1.0,
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

                                // We add the theme in our database
                                await databaseManager.insertTheme(ThemeObject(title: _controller.text, language: langFR ? "fr" : "nl"));

                                setState(() {
                                  newThemePageState = ValueNotifier<bool>(false);
                                });

                                // Redirection
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ListThemesPage(),)
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
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                  color: Color.fromRGBO(61, 192, 200, 1),
                                ),
                                padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width *
                                        0.02,
                                    MediaQuery.of(context).size.width *
                                        0.015,
                                    MediaQuery.of(context).size.width *
                                        0.02,
                                    MediaQuery.of(context).size.width *
                                        0.015),
                                child: Text(
                                  langFR
                                      ? "Enregistrer"
                                      : "...",
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
                        value
                            ? Expanded(child: SizedBox())
                            : SizedBox(),

                        // Keyboard
                        value
                            ? customKeyboard
                            : SizedBox(),

                      ],
                    ),
                  ),
                ),

                // Buttons at the right
                value
                  ? SizedBox()
                  : Container(
                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.012),
                  child: Column(
                    children: [
                      AnimatedScale(
                        scale:
                        _buttonAnimations["HELP"]! ? 1.1 : 1.0,
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
                            margin: EdgeInsets.fromLTRB(
                                0,
                                MediaQuery.of(context).size.height *
                                    0.03,
                                0,
                                MediaQuery.of(context).size.height *
                                    0.03),
                            child: Image.asset(
                              "assets/helping_icon.png",
                              height: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.06,
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.06,
                            ),
                          ),
                        ),
                      ),
                      AnimatedScale(
                        scale:
                        _buttonAnimations["HOME"]! ? 1.1 : 1.0,
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
                            print("HOMEEEEEEEEEEEEEEEEE");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["HOME"] = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                MediaQuery.of(context).size.height *
                                    0.03),
                            child: Image.asset(
                              "assets/home.png",
                              height: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.06,
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.06,
                            ),
                          ),
                        ),
                      ),
                      AnimatedScale(
                        scale:
                        _buttonAnimations["RELAX"]! ? 1.1 : 1.0,
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
                            height:
                            MediaQuery.of(context).size.width *
                                0.060,
                            width:
                            MediaQuery.of(context).size.width *
                                0.060,
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width *
                                    0.01),
                            decoration: const BoxDecoration(
                              color:
                              Color.fromRGBO(160, 208, 86, 1),
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