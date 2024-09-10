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

import 'models/database/dialog.dart';
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
    "TOP ARROW": false,
    "BOT ARROW": false,
  };

  late List<DialogObject> _listDialogs;
  late List<bool> _dialogsAnimations;
  late List<bool> _deleteButtonsAnimations;
  late List<bool> _TTSButtonsAnimations;
  final ScrollController _scrollController =  ScrollController();

  Future<void> initialisation() async{
    _listDialogs = await databaseManager.retrieveDialogsFromLanguage(langFR ?"fr" : "nl");
    _dialogsAnimations  = List.filled(_listDialogs.length, false);
    _deleteButtonsAnimations  = List.filled(_listDialogs.length, false);
    _TTSButtonsAnimations  = List.filled(_listDialogs.length, false);
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
                    child: RawScrollbar(
                      thumbColor: Colors.blue,
                      controller: _scrollController,
                      trackVisibility: true,
                      thumbVisibility: true,
                      thickness: 15,
                      radius: const Radius.circular(20),
                      trackColor:
                      const Color.fromRGBO(66, 89, 109, 1),
                      crossAxisMargin: 5,
                      mainAxisMargin: 5,
                      trackRadius: const Radius.circular(20),
                      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.11),
                      child: Row(
                        children: [
                          FutureBuilder(
                              future: databaseManager.retrieveDialogsFromLanguage(langFR ?"fr" : "nl"),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<DialogObject>> snapshot) {
                                if (snapshot.hasData) {
                                  return Expanded(
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              // Dialog + TTS
                                              AnimatedScale(
                                                scale: _dialogsAnimations[index] && !_TTSButtonsAnimations[index]
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
                                                    width: MediaQuery.of(context).size.width * 0.82,
                                                    decoration: const BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(60)),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Text
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 0.57,
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
                      
                                                        // Fill in the rest of the container
                                                        Expanded(child: SizedBox()),
                      
                                                        // TTS
                                                        Container(
                                                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                                                          child: AnimatedScale(
                                                            scale: _TTSButtonsAnimations[index]
                                                                ? 1.1
                                                                : 1.0,
                                                            duration: const Duration(milliseconds: 100),
                                                            curve: Curves.bounceOut,
                                                            child: GestureDetector(
                                                              // Animation management
                                                              onTapDown: (_) {
                                                                setState(() {
                                                                  _TTSButtonsAnimations[index] = true;
                      
                                                                });
                                                              },
                                                              onTapUp: (_) {
                                                                setState(() {
                                                                  _TTSButtonsAnimations[index] = false;
                                                                });
                                                                // BUTTON CODE
                                                                // TTS
                      
                                                              },
                                                              onTapCancel: () {
                                                                setState(() {
                                                                  _TTSButtonsAnimations[index] = false;
                                                                });
                                                              },
                                                              child: Container(
                                                                child: Image.asset(
                                                                  'assets/sound.png',
                                                                  height: MediaQuery.of(context).size.height * 0.085,
                                                                  color: Colors.blue,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                      
                                              // Delete Dialog Buttons
                                              AnimatedScale(
                                                scale: _deleteButtonsAnimations[index] ? 1.1 : 1.0,
                                                duration: const Duration(milliseconds: 100),
                                                curve: Curves.bounceOut,
                                                child: GestureDetector(
                                                  onTapDown: (_) {
                                                    setState(() {
                                                      _deleteButtonsAnimations[index] = true;
                                                    });
                                                  },
                                                  onTapUp: (_) {
                                                    setState(() {
                                                      _deleteButtonsAnimations[index] = false;
                                                    });
                                                    // BUTTON CODE
                                                    print("delete: $index");
                                                  },
                                                  onTapCancel: () {
                                                    setState(() {
                                                      _deleteButtonsAnimations[index] = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.width * 0.06,
                                                    width: MediaQuery.of(context).size.width * 0.06,
                                                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                                                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                                    decoration: const BoxDecoration(
                                                      color:
                                                      Color.fromRGBO(244, 66, 56, 1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.asset(
                                                      "assets/trash.png",
                                                    ),
                                                  ),
                                                ),
                                              ),
                      
                                            ],
                                          );
                                        }),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                      
                          // ScrollWidgets
                          Container(
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                AnimatedScale(
                                  scale: _buttonAnimations["TOP ARROW"]!
                                      ? 1.1
                                      : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTap: () {
                                      _scrollController.animateTo(
                                        _scrollController.offset - 120,
                                        duration:
                                        const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    },
                      
                                    onLongPress: () {
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.minScrollExtent,
                                        duration:
                                        const Duration(milliseconds: 1),
                                        curve: Curves.easeIn,
                                      );
                                    },
                      
                                    onTapDown: (_) {
                                      setState(() {
                                        _buttonAnimations["TOP ARROW"] = true;
                                      });
                                    },
                      
                                    onTapUp: (_) {
                                      setState(() {
                                        _buttonAnimations["TOP ARROW"] = false;
                                      });
                                    },
                      
                                    onLongPressEnd: (_) {
                                      setState(() {
                                        _buttonAnimations["TOP ARROW"] = false;
                                      });
                                    },
                      
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.height *
                                          0.07,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                        color: const Color.fromRGBO(
                                            101, 72, 254, 1),
                                      ),
                                      child: Transform.rotate(
                                        angle: 1.5708,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.063,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(child: SizedBox()),
                      
                                AnimatedScale(
                                  scale: _buttonAnimations["BOT ARROW"]!
                                      ? 1.1
                                      : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTap: () {
                                      _scrollController.animateTo(
                                        _scrollController.offset + 120,
                                        duration:
                                        const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    },
                      
                                    onLongPress: () {
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                        const Duration(milliseconds: 1),
                                        curve: Curves.easeIn,
                                      );
                                    },
                      
                                    onTapDown: (_) {
                                      setState(() {
                                        _buttonAnimations["BOT ARROW"] = true;
                                      });
                                    },
                      
                                    onTapUp: (_) {
                                      setState(() {
                                        _buttonAnimations["BOT ARROW"] = false;
                                      });
                                    },
                      
                                    onLongPressEnd: (_) {
                                      setState(() {
                                        _buttonAnimations["BOT ARROW"] = false;
                                      });
                                    },
                      
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.height *
                                          0.07,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.07,
                                      margin: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          0,
                                        MediaQuery.of(context).size.height *
                                            0.02,),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                        color: const Color.fromRGBO(
                                            101, 72, 254, 1),
                                      ),
                                      child: Transform.rotate(
                                        angle: -1.5708,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.063,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    ),
              ],
            );
          }),
    );
  }
}