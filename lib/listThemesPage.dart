// List of themes Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/customShapeThemes.dart';
import 'package:parkinson_com_v2/customTitle.dart';
import 'package:parkinson_com_v2/listDialogsPage.dart';
import 'package:parkinson_com_v2/listDialogsPageFiltered.dart';
import 'package:parkinson_com_v2/models/database/theme.dart';
import 'package:parkinson_com_v2/newThemePage.dart';
import 'package:parkinson_com_v2/variables.dart';

class ListThemesPage extends StatefulWidget {
  const ListThemesPage({super.key});

  @override
  State<ListThemesPage> createState() => _ListThemesPageState();
}

class _ListThemesPageState extends State<ListThemesPage> {
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
    "POPUP NO": false,
    "POPUP YES": false,
  };

  List<ThemeObject> _listThemes = [];
  late List<bool> _dialogsAnimations;
  late List<bool> _deleteButtonsAnimations;
  late List<bool> _ttsButtonsAnimations;
  final ScrollController _scrollController =  ScrollController();

  Future<void> initialisation() async{
    _listThemes = await databaseManager.retrieveThemesFromLanguage(langFR ?"fr" : "nl");
    setState(() {});
    _dialogsAnimations  = List.filled(_listThemes.length, false);
    _deleteButtonsAnimations  = List.filled(_listThemes.length, false);
    _ttsButtonsAnimations  = List.filled(_listThemes.length, false);

    // Sorting the list
    int i;
    int endIndex;
    List<ThemeObject> firstPart = [];
    List<ThemeObject> secondPart = [];

    // Separate into two lists: firstPart with the themes of the user and secondPart with the base themes
    if(_listThemes.length > 1){
      for(i = _listThemes.length - 1; i >= 0; i -= 1){
        if(_listThemes[i].id_theme > 24){
          firstPart.add(_listThemes[i]);
        }
        else{
          endIndex = i;
          secondPart = _listThemes.sublist(0, endIndex + 1);
          break;
        }
      }

      // Combine the two parts
      _listThemes = [];
      _listThemes = firstPart + secondPart;
      setState(() {});
    }
  }

  @override
  void initState() {
    // Initialisation of our variables
    initialisation();
    super.initState();
  }

  ///Used to refresh the UI from the StatefulBuilder
  void _updateParent() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: Column(
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
                    Row(
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
                                  text: langFR
                                      ? 'Les thèmes'
                                      : "De thema's",
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
                                    print("DIALOGUEEEE");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ListDialogsPage()),
                                    );
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _buttonAnimations["THEMES"] = false;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.40, 0, 0, 0),
                                    child: CustomShapeThemes(
                                      text: langFR
                                          ? 'Voir les dialogues'
                                          : 'Bekijk de dialogen',
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

                    // Text + Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.835,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text
                          Container(
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0, 0, MediaQuery.of(context).size.height * 0.02),
                            child: Text(
                              langFR
                                  ? 'Liste de tous les thèmes'
                                  : "Lijst met thema's",

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
                                  MaterialPageRoute(builder: (context) => const NewThemePage(),)
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
                                  color: Color.fromRGBO(255, 183, 34, 1),
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
                                      ? "+ Nouveau thème"
                                      : "+ Nieuw thema",
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
                thickness: MediaQuery.of(context).size.width * 0.01125,
                radius: Radius.circular(MediaQuery.of(context).size.width * 0.015),
                trackColor:
                const Color.fromRGBO(66, 89, 109, 1),
                crossAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                mainAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                trackRadius: const Radius.circular(20),
                padding: MediaQuery.of(context).size.height > 600
                    ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.11)
                    : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.027, MediaQuery.of(context).size.height * 0.11),
                child: Row(
                  children: [
                    // List of dialogs
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _listThemes.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                // Themes
                                AnimatedScale(
                                  scale: _dialogsAnimations[index] &&
                                      !_ttsButtonsAnimations[index]
                                      ? 1.05
                                      : 1.0,
                                  duration:
                                  const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTapDown: (_) {
                                      setState(() {
                                        _dialogsAnimations[index] = true;

                                      });
                                    },
                                    onTapUp: (_) {
                                      setState(() {
                                        _dialogsAnimations[index] = false;
                                      });
                                      // BUTTON CODE
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ListDialogsPageFiltered(idTheme: _listThemes[index].id_theme))
                                      );

                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _dialogsAnimations[index] = false;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.025,
                                          0,
                                          0,
                                          MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.02),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.82,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(60)),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.745,
                                        padding:
                                        EdgeInsets.fromLTRB(
                                            MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.04,
                                            MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.015,
                                            MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.02,
                                            MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.015),
                                        child: Text(
                                          _listThemes[index].title,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Delete Dialog Buttons
                                AnimatedScale(
                                  scale: _deleteButtonsAnimations[index]
                                      ? 1.1
                                      : 1.0,
                                  duration:
                                  const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    onTapDown: (_) {
                                      setState(() {
                                        _deleteButtonsAnimations[index] =
                                        true;
                                      });
                                    },
                                    onTapUp: (_) {
                                      // BUTTON CODE
                                      setState(() {
                                        _deleteButtonsAnimations[index] =
                                        false;
                                      });
                                      //Popup to confirm the deletion
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Use StatefulBuilder to manage the state inside the dialog
                                            return StatefulBuilder(builder:
                                                (context, setState) {
                                              double screenHeight =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              double screenWidth =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width;

                                              return Dialog(
                                                backgroundColor:
                                                Colors.black87,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .all(
                                                      16.0), // Optional padding for aesthetics
                                                  child: Column(
                                                      mainAxisSize: MainAxisSize
                                                          .min, // Ensures the dialog is as small as needed
                                                      children: [
                                                        SizedBox(
                                                            height:
                                                            screenHeight *
                                                                0.1),
                                                        //Suppression warning
                                                        Text(
                                                          langFR
                                                              ? 'Voulez vous vraiment supprimer le thème:\n${_listThemes[index].title} ?'
                                                              : 'Weet je zeker dat je het thema wil verwijderen:\n${_listThemes[index].title}?',
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),

                                                        FutureBuilder(future: databaseManager.countDialogsFromTheme(_listThemes[index].id_theme), builder:
                                                        (context, snapshot) {
                                                          if(snapshot.hasData) {
                                                            return Text(
                                                              langFR
                                                                  ? 'Il y a ${snapshot.data} dans ce thème.\nCes dialogues seront supprimés.'
                                                                  : 'Er is ${snapshot.data} dialogen in dit thema.\nDeze dialogen worden verwijderd.',
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:20,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            );
                                                          }
                                                          else {
                                                            return const SizedBox.shrink();
                                                          }
                                                        },
                                                        ),

                                                        SizedBox(
                                                            height:
                                                            screenHeight *
                                                                0.2),
                                                        //Buttons to cancel and validate
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                                  Navigator.pop(context);

                                                                },
                                                                onTapCancel: () {
                                                                  setState(() {
                                                                    _buttonAnimations["POPUP NO"] = false;
                                                                  });
                                                                },
                                                                child:
                                                                Container(
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(60)),
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      screenWidth *
                                                                          0.1,
                                                                      8.0,
                                                                      screenWidth *
                                                                          0.1,
                                                                      8.0),
                                                                  child: Text(
                                                                    langFR
                                                                        ? "NON"
                                                                        : "NEEN",
                                                                    style:
                                                                    const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      fontSize: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            //Blank space between the buttons
                                                            SizedBox(
                                                                width:
                                                                screenWidth *
                                                                    0.15),
                                                            //Validate button
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
                                                                  await databaseManager.deleteTheme(_listThemes[index].id_theme);
                                                                  //Refresh ui
                                                                  _listThemes.removeAt(index);
                                                                  _updateParent();
                                                                  //Close the popup
                                                                  Navigator.pop(context); // Close the dialog
                                                                },

                                                                onTapCancel: () {
                                                                  setState(() {
                                                                    _buttonAnimations["POPUP YES"] = false;
                                                                  });
                                                                },
                                                                child:
                                                                Container(
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(60)),
                                                                    color: Colors
                                                                        .lightGreen,
                                                                  ),
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      screenWidth *
                                                                          0.1,
                                                                      8.0,
                                                                      screenWidth *
                                                                          0.1,
                                                                      8.0),
                                                                  child: Text(
                                                                    langFR
                                                                        ? "OUI"
                                                                        : "JA",
                                                                    style:
                                                                    const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      fontSize: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: screenHeight * 0.03),
                                                      ]),
                                                ),
                                              );
                                            });
                                          });
                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _deleteButtonsAnimations[index] =
                                        false;
                                      });
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.06,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.06,
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.01),
                                      margin: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.01,
                                          0,
                                          0,
                                          MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.02),
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
                    ),

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

                          Expanded(child: Container(
                            width: MediaQuery.of(context).size.width * 0.01875,
                            margin: MediaQuery.of(context).size.height > 600
                                ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.014)
                                : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.011),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(66, 89, 109, 1),
                            ),

                            child: Container(
                              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.00375),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue,
                              ),
                            ),

                          )),

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
        )
    );
  }
}
