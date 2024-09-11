// Dialog Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/customShape.dart';
import 'package:parkinson_com_v2/keyboard.dart';
import 'package:parkinson_com_v2/listDialogsPage.dart';
import 'package:parkinson_com_v2/variables.dart';

import 'models/database/dialog.dart';
import 'models/database/theme.dart';

class DialogPage extends StatefulWidget {
  final int idDialog;
  final String initialTextDialog;
  final int idTheme;

  const DialogPage({super.key, required this.idDialog, required this.initialTextDialog, this.idTheme = 1});


  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "ERASE": false,
    "TTS": false,
    "TOP ARROW": false,
    "BOT ARROW": false,
    "SAVE": false,
    "SEND": false,
    "HELP": false,
    "HOME": false,
    "RELAX": false,
    "BACK ARROW": false,
    "MODIFY": false,
  };
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late CustomKeyboard customKeyboard;


  @override
  void initState() {
    super.initState();
    customKeyboard = CustomKeyboard(controller: _controller, textPredictions: true);
    _controller.text = widget.initialTextDialog;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
      body: ValueListenableBuilder<bool>(
          valueListenable: dialogPageState,
          builder: (context, value, child) {
            return Column(
              children: [
                // First part
                RawScrollbar(
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
                  padding: value
                      ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.0807, MediaQuery.of(context).size.width * 0.0640 * -1)
                      : MediaQuery.of(context).size.height > 600
                        ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.23, MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.width * 0.034 * -1)
                        : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.24, MediaQuery.of(context).size.width * 0.104, MediaQuery.of(context).size.width * 0.047 * -1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titles and TextField
                      Column(
                        children: [
                          // Titles
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 600
                                ? MediaQuery.of(context).size.height * 0.11
                                : MediaQuery.of(context).size.height * 0.13,
                            width: MediaQuery.of(context).size.height > 600
                                ? MediaQuery.of(context).size.width * 0.86
                                : MediaQuery.of(context).size.width * 0.86,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Back Arrow
                                value
                                    ? Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.09),
                                )
                                    : Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.02),
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
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const ListDialogsPage()),
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

                                Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Text(
                                    langFR
                                        ? 'Rédiger un dialogue'
                                        : 'Een dialoog schrijven',
                                    style: GoogleFonts.josefinSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                //Displaying the Theme of the Dialog at the top right corner
                                if(widget.idDialog == -1) Container(
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01,),
                                  child: Text(
                                    langFR
                                        ? 'Thème: Dialogue sans thème'
                                        : 'Thema: Dialoog zonder onderwerp',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      decorationThickness: 1.7,
                                    ),
                                  ),
                                ),
                                //Need to retrieve the theme before displaying it
                                if(widget.idDialog != -1) FutureBuilder(
                                    future: databaseManager.retrieveThemeFromId(widget.idTheme),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData) {
                                        return Container(
                                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01,),
                                          child: Text(langFR
                                              ? 'Thème: ${snapshot.data!.title}'
                                              : 'Thema: ${snapshot.data!.title}',style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.white,
                                            decorationThickness: 1.7,
                                          ),),
                                        );
                                      }
                                      else {
                                        return Container(
                                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01,),
                                          child: Text(langFR
                                              ? 'Thème: Dialogue sans thème'
                                              : 'Thema: Dialoog zonder onderwerp',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.white,
                                              decorationThickness: 1.7,
                                            ),),
                                        );
                                      }
                                    },),

                              ],
                            ),
                          ),

                          // TextField
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 600
                                ? value
                                ? MediaQuery.of(context).size.height * 0.34
                                : MediaQuery.of(context).size.height * 0.58
                                : value
                                ? MediaQuery.of(context).size.height * 0.29
                                : MediaQuery.of(context).size.height * 0.50,
                            width: MediaQuery.of(context).size.height > 600
                                ? MediaQuery.of(context).size.width * 0.86
                                : MediaQuery.of(context).size.width * 0.85,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.03,
                                  0,
                                  0,
                                  MediaQuery.of(context).size.height * 0.03),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.045),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // TextField
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.73,
                                      height:
                                      MediaQuery.of(context).size.width * 0.5,
                                      child: TextField(
                                        scrollController: _scrollController,
                                        scrollPhysics:
                                        const BouncingScrollPhysics(
                                          decelerationRate:
                                          ScrollDecelerationRate.normal,
                                        ),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .size
                                              .height >
                                              600
                                              ? MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.026
                                              : MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.058,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(
                                              50, 50, 50, 1),
                                        ),
                                        controller: _controller,
                                        readOnly: true,
                                        showCursor: true,
                                        onTap: () {
                                          setState(() {
                                            dialogPageState.value = true;
                                          });
                                          print("TOUCHEEEEEEEEEEEEEEE");
                                        },
                                        enableInteractiveSelection: true,
                                        minLines:
                                        MediaQuery.of(context).size.height >
                                            600
                                            ? 3
                                            : 2,
                                        maxLines: null,
                                        cursorWidth:
                                        MediaQuery.of(context).size.height >
                                            600
                                            ? 3
                                            : 2,
                                        cursorColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          iconColor: Colors.white,
                                          disabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusColor: Colors.white,
                                          hoverColor: Colors.white,
                                          contentPadding: EdgeInsets.fromLTRB(
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                            0,
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
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
                                                color: Colors.white),
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
                                                color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.045),
                                            ),
                                          ),
                                          hintText: langFR
                                              ? 'Ecrire votre texte ici...'
                                              : 'Schrijf hier uw tekst...',
                                        ),
                                      ),
                                    ),

                                    // Spacing between the TextField and the image
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.01),

                                    // Erase and TTS
                                    Column(
                                      children: [
                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                        ),
                                        AnimatedScale(
                                          scale: _buttonAnimations["ERASE"]!
                                              ? 1.1
                                              : 1.0,
                                          duration: const Duration(milliseconds: 100),
                                          curve: Curves.bounceIn,
                                          child: GestureDetector(
                                            // Animation management
                                            onTapDown: (_) {
                                              setState(() {
                                                _buttonAnimations["ERASE"] = true;
                                              });
                                            },
                                            onTapUp: (_) {
                                              setState(() {
                                                _buttonAnimations["ERASE"] =
                                                false;
                                                customKeyboard.predictionsHandler
                                                    ?.clearText();
                                              });
                                            },
                                            onTapCancel: () {
                                              setState(() {
                                                _buttonAnimations["ERASE"] =
                                                false;
                                              });
                                            },

                                            child: Image.asset(
                                              'assets/pageBlanche.png',
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.09,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.09,
                                            ),
                                          ),
                                        ),

                                        // Space between
                                        const Expanded(child: SizedBox()),

                                        AnimatedScale(
                                          scale: _buttonAnimations["TTS"]!
                                              ? 1.1
                                              : 1.0,
                                          duration: const Duration(milliseconds: 100),
                                          curve: Curves.bounceIn,
                                          child: GestureDetector(
                                            // Animation management
                                            onTapDown: (_) {
                                              setState(() {
                                                _buttonAnimations["TTS"] = true;
                                              });
                                            },
                                            onTapUp: (_) {
                                              setState(() {
                                                _buttonAnimations["TTS"] = false;
                                                // TODO code du TTS
                                                // Je pense que le mieux est de faire une fonction que l'on appelle juste ici
                                              });
                                            },
                                            onTapCancel: () {
                                              setState(() {
                                                _buttonAnimations["TTS"] = false;
                                              });
                                            },

                                            child: Image.asset(
                                              'assets/sound.png',
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Buttons at the right
                      value
                          // Scroll Widget
                          ? SizedBox(
                        height: MediaQuery.of(context).size.height > 600
                            ? MediaQuery.of(context).size.height * 0.45
                            : MediaQuery.of(context).size.height * 0.42,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    _scrollController.offset - 50,
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
                                  margin: EdgeInsets.fromLTRB(
                                      0,
                                      MediaQuery.of(context).size.height *
                                          0.02,
                                      0,
                                      0),
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
                            Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.01875,
                                  margin: MediaQuery.of(context).size.height > 600
                                        ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.01)
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

                                )
                            ),
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
                                    _scrollController.offset + 50,
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
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Scroll widgets
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.01,
                                MediaQuery.of(context).size.height * 0.06,
                                MediaQuery.of(context).size.width * 0.015,
                                0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                AnimatedScale(
                                  scale: _buttonAnimations["TOP ARROW"]!
                                      ? 1.1
                                      : 1.0,
                                  duration:
                                  const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTap: () {
                                      _scrollController.animateTo(
                                        _scrollController.offset - 50,
                                        duration: const Duration(
                                            milliseconds: 500),
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
                                        _buttonAnimations["TOP ARROW"] =
                                        true;
                                      });
                                    },

                                    onTapUp: (_) {
                                      setState(() {
                                        _buttonAnimations["TOP ARROW"] =
                                        false;
                                      });
                                    },

                                    onLongPressEnd: (_) {
                                      setState(() {
                                        _buttonAnimations["TOP ARROW"] =
                                        false;
                                      });
                                    },

                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0,
                                          MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.08,
                                          0,
                                          MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.02),
                                      width: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.07,
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context)
                                                .size
                                                .width *
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
                                Container(
                                  height: MediaQuery.of(context).size.height > 600
                                      ? MediaQuery.of(context).size.height * 0.3
                                      : MediaQuery.of(context).size.height * 0.25,

                                  width: MediaQuery.of(context).size.width * 0.01875,
                                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.01),
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

                                ),
                                AnimatedScale(
                                  scale: _buttonAnimations["BOT ARROW"]!
                                      ? 1.1
                                      : 1.0,
                                  duration:
                                  const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTap: () {
                                      _scrollController.animateTo(
                                        _scrollController.offset + 50,
                                        duration: const Duration(
                                            milliseconds: 500),
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
                                        _buttonAnimations["BOT ARROW"] =
                                        true;
                                      });
                                    },

                                    onTapUp: (_) {
                                      setState(() {
                                        _buttonAnimations["BOT ARROW"] =
                                        false;
                                      });
                                    },

                                    onLongPressEnd: (_) {
                                      setState(() {
                                        _buttonAnimations["BOT ARROW"] =
                                        false;
                                      });
                                    },

                                    child: Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.07,
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.07,
                                      margin: EdgeInsets.fromLTRB(
                                          0,
                                          MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.02,
                                          0,
                                          0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context)
                                                .size
                                                .width *
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
                          ),

                          // Navigation Icons
                          Column(
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
                        ],
                      ),
                    ],
                  ),
                ),

                // Second part
                value
                // Keyboard
                    ? Expanded(child: customKeyboard)
                // Buttons
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            AnimatedScale(
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
                                  print("SAVEEEEEEEEE");

                                  //Retrieve the list of the themes for the actual language
                                  List<ThemeObject> themesList =
                                  await databaseManager
                                      .retrieveThemesFromLanguage(
                                      langFR ? 'fr' : 'nl');
                                  ThemeObject? selectedTheme = themesList[0];
                                  //Popup for choosing a theme
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Use StatefulBuilder to manage the state inside the dialog
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          double screenHeight =
                                              MediaQuery.of(context)
                                                  .size
                                                  .height;
                                          double screenWidth =
                                              MediaQuery.of(context)
                                                  .size
                                                  .width;
                                          return Dialog(
                                            backgroundColor: Colors.black87,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  16.0), // Optional padding for aesthetics
                                              child: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Ensures the dialog is as small as needed
                                                children: [
                                                  // Title for theme selection
                                                  Text(
                                                    langFR
                                                        ? 'Veuillez choisir un thème pour ce dialogue:'
                                                        : 'Kies een onderwerp voor deze dialoog:',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        screenHeight *
                                                            0.03,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                      screenHeight * 0.1),
                                                  // Dropdown menu for themes
                                                  Container(
                                                    color: Colors.amber,
                                                    child:
                                                    DropdownButtonHideUnderline(
                                                      child: DropdownButton2<
                                                          ThemeObject>(
                                                        value: selectedTheme,
                                                        dropdownStyleData:
                                                        DropdownStyleData(
                                                          maxHeight:
                                                          screenHeight *
                                                              0.35,
                                                          decoration:
                                                          const BoxDecoration(
                                                              color: Colors
                                                                  .amber),
                                                        ),
                                                        style: TextStyle(
                                                          color: const Color
                                                              .fromRGBO(
                                                              65, 65, 65, 1),
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize:
                                                          screenHeight *
                                                              0.025,
                                                        ),
                                                        onChanged:
                                                            (ThemeObject?
                                                        newValue) {
                                                          setState(() {
                                                            selectedTheme =
                                                                newValue; // Update the selected theme
                                                          });
                                                        },
                                                        items: themesList.map(
                                                                (ThemeObject
                                                            theme) {
                                                              return DropdownMenuItem<
                                                                  ThemeObject>(
                                                                value: theme,
                                                                child: Text(
                                                                  theme.title,
                                                                ),
                                                              );
                                                            }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                      screenHeight * 0.2),
                                                  //Buttons to cancel and validate
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      //Cancel button
                                                      GestureDetector(
                                                        onTapUp: (_) {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          decoration:
                                                          const BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .all(Radius
                                                                .circular(
                                                                60)),
                                                            color: Colors.red,
                                                          ),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                              screenWidth *
                                                                  0.1,
                                                              8.0,
                                                              screenWidth *
                                                                  0.1,
                                                              8.0),
                                                          child: Text(
                                                            langFR
                                                                ? "Annuler"
                                                                : "Annuleren",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              screenHeight *
                                                                  0.025,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      //Blank space between the buttons
                                                      SizedBox(
                                                          width: screenWidth *
                                                              0.15),
                                                      //Validate button
                                                      GestureDetector(
                                                        onTapUp: (_) async {
                                                          await databaseManager
                                                              .insertDialog(
                                                              DialogObject(
                                                                sentence:
                                                                _controller
                                                                    .text,
                                                                language: langFR
                                                                    ? "fr"
                                                                    : "nl",
                                                                id_theme:
                                                                selectedTheme!
                                                                    .id_theme,
                                                              ));

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          decoration:
                                                          const BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .all(Radius
                                                                .circular(
                                                                60)),
                                                            color: Colors
                                                                .lightGreen,
                                                          ),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                              screenWidth *
                                                                  0.1,
                                                              8.0,
                                                              screenWidth *
                                                                  0.1,
                                                              8.0),
                                                          child: Text(
                                                            langFR
                                                                ? "Valider"
                                                                : "Bevestigen",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              screenHeight *
                                                                  0.025,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedTheme =
                                            value; // Update the main widget with the selected theme
                                      });
                                    }
                                  });
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["SAVE"] = false;
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                    color: Color.fromRGBO(255, 183, 34, 1),
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
                                  margin: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width *
                                          0.05,
                                      0,
                                      0,
                                      0),
                                  child: Text(
                                    langFR
                                        ? "Enregistrer nouveau"
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
                            const Expanded(
                              child: SizedBox(),
                            ),
                            AnimatedScale(
                              scale: _buttonAnimations["SEND"] == true
                                  ? 1.1
                                  : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                // Animation management
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["SEND"] = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["SEND"] = false;
                                  });
                                  // BUTTON CODE
                                  print("SENDDDDDDDDDDD");
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["SEND"] = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      MediaQuery.of(context).size.width *
                                          0.08,
                                      0),
                                  child: CustomShape(
                                    image: "assets/enveloppe.png",
                                    text: langFR
                                        ? "Envoyer à un contact"
                                        : "Stuur naar een contact",
                                    scale: MediaQuery.of(context).size.width *
                                        0.0013,
                                    backgroundColor:
                                    const Color.fromRGBO(12, 178, 255, 1),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if(widget.idDialog != -1)
                          AnimatedScale(
                            scale: _buttonAnimations["MODIFY"] == true
                                ? 1.1
                                : 1.0,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceOut,
                            child: GestureDetector(
                              // Animation management
                              onTapDown: (_) {
                                setState(() {
                                  _buttonAnimations["MODIFY"] = true;
                                });
                              },
                              onTapUp: (_) async {
                                setState(() {
                                  _buttonAnimations["MODIFY"] = false;
                                });
                                // BUTTON CODE
                                //Retrieve the list of the themes for the actual language
                                List<ThemeObject> themesList =
                                await databaseManager
                                    .retrieveThemesFromLanguage(
                                    langFR ? 'fr' : 'nl');
                                ThemeObject? selectedTheme = themesList[0];
                                //Select by default the actual theme of the dialog
                                for(var t in themesList) {
                                  if(t.id_theme == widget.idTheme) {
                                    selectedTheme = t;
                                  }
                                }
                                //Popup for choosing a theme
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // Use StatefulBuilder to manage the state inside the dialog
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        double screenHeight =
                                            MediaQuery.of(context)
                                                .size
                                                .height;
                                        double screenWidth =
                                            MediaQuery.of(context)
                                                .size
                                                .width;
                                        return Dialog(
                                          backgroundColor: Colors.black87,
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                16.0), // Optional padding for aesthetics
                                            child: Column(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Ensures the dialog is as small as needed
                                              children: [
                                                // Title for theme selection
                                                Text(
                                                  langFR
                                                      ? 'Veuillez choisir un thème pour ce dialogue:'
                                                      : 'Kies een onderwerp voor deze dialoog:',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                      screenHeight *
                                                          0.03,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                SizedBox(
                                                    height:
                                                    screenHeight * 0.1),
                                                // Dropdown menu for themes
                                                Container(
                                                  color: Colors.amber,
                                                  child:
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton2<
                                                        ThemeObject>(
                                                      value: selectedTheme,
                                                      dropdownStyleData:
                                                      DropdownStyleData(
                                                        maxHeight:
                                                        screenHeight *
                                                            0.35,
                                                        decoration:
                                                        const BoxDecoration(
                                                            color: Colors
                                                                .amber),
                                                      ),
                                                      style: TextStyle(
                                                        color: const Color
                                                            .fromRGBO(
                                                            65, 65, 65, 1),
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize:
                                                        screenHeight *
                                                            0.025,
                                                      ),
                                                      onChanged:
                                                          (ThemeObject?
                                                      newValue) {
                                                        setState(() {
                                                          selectedTheme =
                                                              newValue; // Update the selected theme
                                                        });
                                                      },
                                                      items: themesList.map(
                                                              (ThemeObject
                                                          theme) {
                                                            return DropdownMenuItem<
                                                                ThemeObject>(
                                                              value: theme,
                                                              child: Text(
                                                                theme.title,
                                                              ),
                                                            );
                                                          }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                    screenHeight * 0.2),
                                                //Buttons to cancel and validate
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    //Cancel button
                                                    GestureDetector(
                                                      onTapUp: (_) {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      child: Container(
                                                        decoration:
                                                        const BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              60)),
                                                          color: Colors.red,
                                                        ),
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                            screenWidth *
                                                                0.1,
                                                            8.0,
                                                            screenWidth *
                                                                0.1,
                                                            8.0),
                                                        child: Text(
                                                          langFR
                                                              ? "Annuler"
                                                              : "Annuleren",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            screenHeight *
                                                                0.025,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //Blank space between the buttons
                                                    SizedBox(
                                                        width: screenWidth *
                                                            0.15),
                                                    //Validate button
                                                    GestureDetector(
                                                      onTapUp: (_) async {
                                                        await databaseManager
                                                            .updateDialog(
                                                            DialogObject(
                                                              id_dialog: widget.idDialog,
                                                              sentence:
                                                              _controller
                                                                  .text,
                                                              language: langFR
                                                                  ? "fr"
                                                                  : "nl",
                                                              id_theme:
                                                              selectedTheme!
                                                                  .id_theme,
                                                            ));

                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      child: Container(
                                                        decoration:
                                                        const BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              60)),
                                                          color: Colors
                                                              .lightGreen,
                                                        ),
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                            screenWidth *
                                                                0.1,
                                                            8.0,
                                                            screenWidth *
                                                                0.1,
                                                            8.0),
                                                        child: Text(
                                                          langFR
                                                              ? "Valider"
                                                              : "Bevestigen",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            screenHeight *
                                                                0.025,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedTheme =
                                          value; // Update the main widget with the selected theme
                                    });
                                  }
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _buttonAnimations["MODIFY"] = false;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(60)),
                                  color: Color.fromRGBO(255, 183, 34, 1),
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
                                margin: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width *
                                        0.05,
                                    MediaQuery.of(context).size.height *
                                        0.03,
                                    0,
                                    0),
                                child: Text(
                                  langFR
                                      ? " Remplacer existant "
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
              ],
            );
          }),
    );
  }
}
