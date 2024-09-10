// Dialog Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/customShapeThemes.dart';
import 'package:parkinson_com_v2/customTitle.dart';
import 'package:parkinson_com_v2/variables.dart';
import 'package:parkinson_com_v2/dialogPage.dart';

import 'main.dart';
import 'models/database/dialog.dart';
import 'models/database/theme.dart';
import 'package:parkinson_com_v2/models/database/databasemanager.dart';

class ListDialogsPage extends StatefulWidget {
  const ListDialogsPage({super.key});

  @override
  State<ListDialogsPage> createState() => _ListDialogsPageState();
}

class _ListDialogsPageState extends State<ListDialogsPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "NEW DIALOG": false,
    "THEMES": false,
    "DIALOGS": false,
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "RELAX": false,
  };

  late List<DialogObject> _listDialogs;
  late List<bool> _dialogsAnimations;

  Future<void> initialisation() async{
    _listDialogs = await databaseManager.retrieveDialogsFromLanguage(langFR ?"fr" : "nl");
    _dialogsAnimations  = await List.filled(_listDialogs.length, false);
  }

  @override
  void initState(){
    // Initialisation of our variables

    initialisation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
      body: ValueListenableBuilder<bool>(
          valueListenable: listDialogsPageState,
          builder: (context, value, child) {
            return Column(
              children: [
                // First part
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First part
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Back Arrow
                              Container(
                                margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.013, MediaQuery.of(context).size.width * 0.02, 0),
                                child: AnimatedScale(
                                  scale: _buttonAnimations["BACK ARROW"]!
                                      ? 1.1
                                      : 1.0,
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
                                      Navigator.popUntil(
                                        context,
                                          (route) => route.isFirst,
                                      );
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

                              // Title + Themes
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width * 0.835,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Container(
                                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.19, MediaQuery.of(context).size.height / 16, 0, MediaQuery.of(context).size.height * 0.07),
                                      child: CustomTitle(
                                        text: value
                                            ? 'Les dialogues'
                                            : 'Les thèmes',
                                        image: 'assets/themeIcon.png',
                                        scale: 1,
                                        backgroundColor: Colors.white,
                                        textColor: const Color.fromRGBO(29, 52, 83, 1),
                                      ),
                                    ),

                                    // See themes Button
                                    AnimatedScale(
                                      scale: _buttonAnimations["THEMES"] == true
                                          ? 1.1
                                          : 1.0,
                                      duration: const Duration(milliseconds: 100),
                                      curve: Curves.bounceOut,
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        // Animation management
                                        onTapDown: (_) {
                                          setState(() {
                                            _buttonAnimations["THEMES"] = true;
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            _buttonAnimations["THEMES"] = false;
                                          });
                                          // BUTTON CODE
                                          print("THEMESSS");
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            _buttonAnimations["THEMES"] = false;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.40, 0, 0, 0),
                                          child: CustomShapeThemes(
                                            text: value
                                                ? 'Voir les thèmes'
                                                : 'Voir les dialogues',
                                            image: 'assets/doubleFleche.png',
                                            backgroundColor: const Color.fromRGBO(78, 237, 255, 1),
                                            textColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Text + Button
                        Container(
                          width: MediaQuery.of(context).size.width * 0.835,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Text
                              Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                child: Text(
                                  'Liste de tous les dialogues',
                                  style: GoogleFonts.josefinSans(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 1.4,
                                  ),

                                ),
                              ),

                              // Button
                              AnimatedScale(
                                scale: _buttonAnimations["NEW DIALOG"] == true
                                    ? 1.1
                                    : 1.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceOut,
                                child: GestureDetector(
                                  // Animation management
                                  onTapDown: (_) {
                                    setState(() {
                                      _buttonAnimations["NEW DIALOG"] = true;
                                    });
                                  },
                                  onTapUp: (_) async {
                                    setState(() {
                                      _buttonAnimations["NEW DIALOG"] = false;
                                    });
                                    // BUTTON CODE
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const DialogPage(idDialog: -1, initialTextDialog: "")),
                                    );
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _buttonAnimations["NEW DIALOG"] = false;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                      color: Color.fromRGBO(78, 237, 255, 1),
                                    ),
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                        MediaQuery.of(context).size.width *
                                            0.015,
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                        MediaQuery.of(context).size.width *
                                            0.015),
                                    child: Text(
                                      langFR
                                          ? "+ Nouveau dialogue"
                                          : "   Nieuw opslaan   ",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

                    // Buttons at the right
                    Container(
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
                ),




                // List of dialogs
                Expanded(
                    child: FutureBuilder(
                        future: databaseManager.retrieveDialogsFromLanguage(langFR ?"fr" : "nl"),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<DialogObject>> snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    return AnimatedScale(
                                      scale: _dialogsAnimations[index] == true
                                          ? 1.05
                                          : 1.0,
                                      duration: const Duration(milliseconds: 100),
                                      curve: Curves.bounceOut,
                                      child: GestureDetector(
                                        // Animation management
                                        onTapDown: (_) {
                                          setState(() {
                                            _dialogsAnimations[index] = true;
                                            print(snapshot.data![index].id_dialog);

                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            _dialogsAnimations[index] = false;
                                          });
                                          // BUTTON CODE
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => DialogPage(idDialog: snapshot.data![index].id_dialog, initialTextDialog: snapshot.data![index].sentence)),
                                          );

                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            _dialogsAnimations[index] = false;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(60)),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context).size.width *
                                                  0.04,
                                              MediaQuery.of(context).size.width *
                                                  0.015,
                                              MediaQuery.of(context).size.width *
                                                  0.02,
                                              MediaQuery.of(context).size.width *
                                                  0.015),
                                          child: Text(
                                            snapshot.data![index].sentence,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,

                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                    ),
              ],
            );
          }),
    );
  }
}