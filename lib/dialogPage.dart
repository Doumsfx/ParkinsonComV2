// Dialog Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:diacritic/diacritic.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/customShape.dart';
import 'package:parkinson_com_v2/keyboard.dart';
import 'package:parkinson_com_v2/variables.dart';

import 'models/database/contact.dart';
import 'models/database/dialog.dart';
import 'models/database/theme.dart';

class DialogPage extends StatefulWidget {
  final int idDialog;
  final String initialTextDialog;
  final int idTheme;

  DialogPage({
    Key? key,
    required this.idDialog,
    required this.initialTextDialog,
    int? idTheme,
  })  :
        //Default theme is 1 for French and 13 for Dutch, add other cases if you want more languages
        idTheme = idTheme ?? (language == "fr" ? 1 : language == "nl" ? 13 : 1),
        super(key: key);

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
    "POPUP OK": false,
    "POPUP YES": false,
    "POPUP NO": false,
  };
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late CustomKeyboard customKeyboard;

  @override
  void initState() {
    super.initState();
    customKeyboard = CustomKeyboard(controller: _controller, textPredictions: isConnected);
    _controller.text = widget.initialTextDialog;
    dialogPageState.value = false;
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
                  trackColor: const Color.fromRGBO(66, 89, 109, 1),
                  crossAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                  mainAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                  trackRadius: const Radius.circular(20),
                  padding: value
                      ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.0807, MediaQuery.of(context).size.width * 0.0640 * -1)
                      : isThisDeviceATablet
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
                            height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.11 : MediaQuery.of(context).size.height * 0.13,
                            width: isThisDeviceATablet ? MediaQuery.of(context).size.width * 0.86 : MediaQuery.of(context).size.width * 0.86,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Back Arrow
                                value
                                    ? Container(
                                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.09),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                                        child: AnimatedScale(
                                          scale: _buttonAnimations["BACK ARROW"]! ? 1.1 : 1.0,
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
                                              //BUTTON CODE
                                              if(_controller.text != widget.initialTextDialog) {
                                                _showTextUnsavedBackArrow();
                                              }
                                              else {
                                                Navigator.pop(
                                                  context,
                                                );
                                              }

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

                                Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Text(
                                    languagesTextsFile.texts["dialog_title"]!,
                                    style: GoogleFonts.josefinSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Displaying the Theme of the Dialog at the top right corner
                                Expanded(
                                  child: Center(
                                    child: FutureBuilder(
                                      // Need to retrieve the theme before displaying it
                                      future: databaseManager.retrieveThemeFromId(widget.idTheme),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return AutoSizeText(
                                            '${languagesTextsFile.texts["dialog_theme"]!} ${snapshot.data!.title}',
                                            maxLines: 1,
                                            maxFontSize: 15,
                                            minFontSize: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.white,
                                              decorationThickness: 1.7,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            margin: EdgeInsets.only(
                                              right: MediaQuery.of(context).size.width * 0.01,
                                            ),
                                            child: OverflowBox(
                                              maxWidth: double.infinity,
                                              child: Text(
                                                languagesTextsFile.texts["dialog_without_theme"]!,
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
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // TextField
                          SizedBox(
                            height: isThisDeviceATablet
                                ? value
                                    ? MediaQuery.of(context).size.height * 0.34
                                    : MediaQuery.of(context).size.height * 0.58
                                : value
                                    ? MediaQuery.of(context).size.height * 0.29
                                    : MediaQuery.of(context).size.height * 0.50,
                            width: isThisDeviceATablet ? MediaQuery.of(context).size.width * 0.86 : MediaQuery.of(context).size.width * 0.85,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, 0, MediaQuery.of(context).size.height * 0.03),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // TextField
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.73,
                                      height: MediaQuery.of(context).size.width * 0.5,
                                      child: TextField(
                                        scrollController: _scrollController,
                                        scrollPhysics: const BouncingScrollPhysics(
                                          decelerationRate: ScrollDecelerationRate.normal,
                                        ),
                                        style: TextStyle(
                                          fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.026 : MediaQuery.of(context).size.height * 0.058,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(50, 50, 50, 1),
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
                                        minLines: isThisDeviceATablet ? 3 : 2,
                                        maxLines: null,
                                        cursorWidth: isThisDeviceATablet ? 3 : 2,
                                        cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          iconColor: Colors.white,
                                          disabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusColor: Colors.white,
                                          hoverColor: Colors.white,
                                          contentPadding: EdgeInsets.fromLTRB(
                                            MediaQuery.of(context).size.width * 0.03,
                                            0,
                                            MediaQuery.of(context).size.width * 0.03,
                                            MediaQuery.of(context).size.width * 0.04,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                            ),
                                          ),
                                          hintText: languagesTextsFile.texts["dialog_hint_text"]!,
                                        ),
                                      ),
                                    ),

                                    // Spacing between the TextField and the image
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),

                                    // Erase and TTS
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.01,
                                        ),
                                        AnimatedScale(
                                          scale: _buttonAnimations["ERASE"]! ? 1.1 : 1.0,
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
                                                _buttonAnimations["ERASE"] = false;

                                                customKeyboard.predictionsHandler?.clearText();
                                              });
                                            },
                                            onTapCancel: () {
                                              setState(() {
                                                _buttonAnimations["ERASE"] = false;
                                              });
                                            },

                                            child: Image.asset(
                                              'assets/pageBlanche.png',
                                              height: MediaQuery.of(context).size.height * 0.09,
                                              width: MediaQuery.of(context).size.height * 0.09,
                                            ),
                                          ),
                                        ),

                                        // Space between
                                        const Expanded(child: SizedBox()),

                                        AnimatedScale(
                                          scale: _buttonAnimations["TTS"]! ? 1.1 : 1.0,
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
                                                //TTS
                                                ttsHandler.setText(_controller.text);
                                                ttsHandler.speak();
                                              });
                                            },
                                            onTapCancel: () {
                                              setState(() {
                                                _buttonAnimations["TTS"] = false;
                                              });
                                            },

                                            child: Image.asset(
                                              'assets/sound.png',
                                              height: MediaQuery.of(context).size.height * 0.1,
                                              width: MediaQuery.of(context).size.height * 0.1,
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
                          ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Scroll widgets
                          Container(
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.00, MediaQuery.of(context).size.width * 0.015, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AnimatedScale(
                                  scale: _buttonAnimations["TOP ARROW"]! ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTap: () {
                                      _scrollController.animateTo(
                                        _scrollController.offset - 50,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    },

                                    onLongPress: () {
                                      _scrollController.animateTo(
                                        _scrollController.position.minScrollExtent,
                                        duration: const Duration(milliseconds: 1),
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
                                      margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.005),
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                        color: const Color.fromRGBO(101, 72, 254, 1),
                                      ),
                                      child: Transform.rotate(
                                        angle: 1.5708,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white,
                                          size: MediaQuery.of(context).size.height * 0.063,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.257 : MediaQuery.of(context).size.height * 0.22,
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
                                  scale: _buttonAnimations["BOT ARROW"]! ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTap: () {
                                      _scrollController.animateTo(
                                        _scrollController.offset + 50,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    },

                                    onLongPress: () {
                                      _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: const Duration(milliseconds: 1),
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
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.005, 0, MediaQuery.of(context).size.height * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                        color: const Color.fromRGBO(101, 72, 254, 1),
                                      ),
                                      child: Transform.rotate(
                                        angle: -1.5708,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white,
                                          size: MediaQuery.of(context).size.height * 0.063,
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
                                    emergencyRequest.sendEmergencyRequest(context);
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
                                    if(_controller.text != widget.initialTextDialog) {
                                      _showTextUnsavedHomeButton();
                                    }
                                    else {
                                      Navigator.popUntil(
                                        context,
                                            (route) => route.isFirst,
                                      );
                                    }
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

                            ],
                          ),
                        ],
                      )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Scroll widgets
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.06, MediaQuery.of(context).size.width * 0.015, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimatedScale(
                                        scale: _buttonAnimations["TOP ARROW"]! ? 1.1 : 1.0,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.bounceOut,
                                        child: GestureDetector(
                                          // Animation management
                                          onTap: () {
                                            _scrollController.animateTo(
                                              _scrollController.offset - 50,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          },

                                          onLongPress: () {
                                            _scrollController.animateTo(
                                              _scrollController.position.minScrollExtent,
                                              duration: const Duration(milliseconds: 1),
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
                                            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.08, 0, MediaQuery.of(context).size.height * 0.02),
                                            width: MediaQuery.of(context).size.height * 0.07,
                                            height: MediaQuery.of(context).size.height * 0.07,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                              color: const Color.fromRGBO(101, 72, 254, 1),
                                            ),
                                            child: Transform.rotate(
                                              angle: 1.5708,
                                              child: Icon(
                                                Icons.arrow_back_ios_new_rounded,
                                                color: Colors.white,
                                                size: MediaQuery.of(context).size.height * 0.063,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.25,
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
                                        scale: _buttonAnimations["BOT ARROW"]! ? 1.1 : 1.0,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.bounceOut,
                                        child: GestureDetector(
                                          // Animation management
                                          onTap: () {
                                            _scrollController.animateTo(
                                              _scrollController.offset + 50,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          },

                                          onLongPress: () {
                                            _scrollController.animateTo(
                                              _scrollController.position.maxScrollExtent,
                                              duration: const Duration(milliseconds: 1),
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
                                            width: MediaQuery.of(context).size.height * 0.07,
                                            height: MediaQuery.of(context).size.height * 0.07,
                                            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                              color: const Color.fromRGBO(101, 72, 254, 1),
                                            ),
                                            child: Transform.rotate(
                                              angle: -1.5708,
                                              child: Icon(
                                                Icons.arrow_back_ios_new_rounded,
                                                color: Colors.white,
                                                size: MediaQuery.of(context).size.height * 0.063,
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
                                          emergencyRequest.sendEmergencyRequest(context);

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
                                          if(_controller.text != widget.initialTextDialog) {
                                            _showTextUnsavedHomeButton();
                                          }
                                          else {
                                            Navigator.popUntil(
                                              context,
                                                  (route) => route.isFirst,
                                            );
                                          }

                                          dialogPageState.value = false;
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
                              // Save button
                              AnimatedScale(
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
                                    //Empty dialog can't be saved
                                    if (_controller.text.isNotEmpty) {
                                      //Retrieve the list of the themes for the actual language
                                      List<ThemeObject> themesList = await databaseManager.retrieveThemesFromLanguage(language);

                                      // Sorting list in alphabetic order
                                      themesList.sort((a, b) {
                                        if (a.id_theme == idDialogWithoutTheme[language]) return -1;
                                        if (b.id_theme == idDialogWithoutTheme[language]) return 1;
                                        return removeDiacritics(a.title).compareTo(removeDiacritics(b.title));
                                      });

                                      ThemeObject? selectedTheme = themesList[0];
                                      for (var t in themesList) {
                                        if (t.id_theme == widget.idTheme) selectedTheme = t;
                                      }

                                      //Popup for choosing a theme
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          bool isSaved = false;
                                          // Use StatefulBuilder to manage the state inside the dialog
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              double screenHeight = MediaQuery.of(context).size.height;
                                              double screenWidth = MediaQuery.of(context).size.width;
                                              if (!isSaved) {
                                                return Dialog(
                                                  backgroundColor: Colors.black87,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    // Optional padding for aesthetics
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      // Ensures the dialog is as small as needed
                                                      children: [
                                                        // Title for theme selection
                                                        Text(
                                                          languagesTextsFile.texts["pop_up_save_dialog"]!,
                                                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(height: screenHeight * 0.1),
                                                        // Dropdown menu for themes
                                                        Container(
                                                          color: Colors.amber,
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton2<ThemeObject>(
                                                              value: selectedTheme,
                                                              dropdownStyleData: DropdownStyleData(
                                                                maxHeight: screenHeight * 0.35,
                                                                decoration: const BoxDecoration(color: Colors.amber),
                                                              ),
                                                              style: const TextStyle(color: Color.fromRGBO(65, 65, 65, 1), fontWeight: FontWeight.bold, fontSize: 20),
                                                              onChanged: (ThemeObject? newValue) {
                                                                setState(() {
                                                                  selectedTheme = newValue; // Update the selected theme
                                                                });
                                                              },
                                                              items: themesList.map((ThemeObject theme) {
                                                                return DropdownMenuItem<ThemeObject>(
                                                                  value: theme,
                                                                  child: Text(
                                                                    theme.title,
                                                                  ),
                                                                );
                                                              }).toList(),

                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: screenHeight * 0.2),
                                                        //Buttons to cancel and validate
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
                                                                  Navigator.pop(context);
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
                                                                    languagesTextsFile.texts["pop_up_cancel"]!,
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
                                                                  await databaseManager.insertDialog(DialogObject(
                                                                    sentence: _controller.text,
                                                                    language: language,
                                                                    id_theme: selectedTheme!.id_theme,
                                                                  ));
                                                                  //Display the confirmation of the saving
                                                                  setState(() {
                                                                    isSaved = true;
                                                                    _buttonAnimations["POPUP YES"] = false;
                                                                  });
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
                                                                    languagesTextsFile.texts["pop_up_validate"]!,
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
                                              } else {
                                                return Dialog(
                                                  backgroundColor: Colors.black87,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.15),
                                                        // Title for saving confirmation
                                                        Text(
                                                          languagesTextsFile.texts["pop_up_save_dialog_succes"]!,
                                                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(height: screenHeight * 0.2),
                                                        //Button to quit
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
                                              }
                                            },
                                          );
                                        },
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedTheme = value; // Update the main widget with the selected theme
                                          });
                                        }
                                      });
                                    } else {
                                      //Popup can't save an empty dialog
                                      _showGenericPopupOK(languagesTextsFile.texts["pop_up_cant_save_dialog"]!);
                                    }
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _buttonAnimations["SAVE"] = false;
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.29,
                                    height: MediaQuery.of(context).size.width * 0.065,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(60)),
                                      color: Color.fromRGBO(255, 183, 34, 1),
                                    ),
                                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.01, 0),
                                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
                                    child: Center(
                                      child: AutoSizeText(
                                        languagesTextsFile.texts["dialog_save"]!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 10,
                                        maxFontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),

                              // Send button
                              AnimatedScale(
                                scale: _buttonAnimations["SEND"] == true ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceOut,
                                child: GestureDetector(
                                  // Animation management
                                  onTapDown: (_) {
                                    setState(() {
                                      _buttonAnimations["SEND"] = true;
                                    });
                                  },
                                  onTapUp: (_) async {
                                    setState(() {
                                      _buttonAnimations["SEND"] = false;
                                    });
                                    // BUTTON CODE
                                    print("SENDDDDDDDDDDD");
                                    _showContactList();
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _buttonAnimations["SEND"] = false;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.08, 0),
                                    child: CustomShape(
                                      image: "assets/enveloppe.png",
                                      text: languagesTextsFile.texts["dialog_send"]!,
                                      backgroundColor: const Color.fromRGBO(12, 178, 255, 1),
                                      textColor: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      containerWidth: MediaQuery.of(context).size.width * 0.34,
                                      containerHeight: MediaQuery.of(context).size.width * 0.065,
                                      containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.013, MediaQuery.of(context).size.width * 0.013 , MediaQuery.of(context).size.width * 0.065 , MediaQuery.of(context).size.width * 0.013 ),
                                      circleSize: MediaQuery.of(context).size.width * 0.104,
                                      imageScale: 0.9,
                                      circlePositionedRight: MediaQuery.of(context).size.width * 0.0013 * -30,
                                      sizedBoxWidth: MediaQuery.of(context).size.width * 0.34,
                                      sizedBoxHeight: MediaQuery.of(context).size.width * 0.065,
                                      scale: 1,

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //Existing Dialog
                          if (widget.idDialog != -1)
                            AnimatedScale(
                              scale: _buttonAnimations["MODIFY"] == true ? 1.1 : 1.0,
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
                                  //Can't save the modified dialog if it is empty
                                  if (_controller.text.isNotEmpty) {
                                    //Retrieve the list of the themes for the actual language
                                    List<ThemeObject> themesList = await databaseManager.retrieveThemesFromLanguage(language);

                                    // Sorting list in alphabetic order
                                    themesList.sort((a, b) {
                                      if (a.id_theme == idDialogWithoutTheme[language]) return -1;
                                      if (b.id_theme == idDialogWithoutTheme[language]) return 1;
                                      return removeDiacritics(a.title).compareTo(removeDiacritics(b.title));
                                    });

                                    ThemeObject? selectedTheme = themesList[0];
                                    //Select by default the actual theme of the dialog
                                    for (var t in themesList) {
                                      if (t.id_theme == widget.idTheme) {
                                        selectedTheme = t;
                                      }
                                    }
                                    //Popup for choosing a theme
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        bool isModified = false;
                                        // Use StatefulBuilder to manage the state inside the dialog
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            double screenHeight = MediaQuery.of(context).size.height;
                                            double screenWidth = MediaQuery.of(context).size.width;
                                            // Popup for confirmation of the dialog modification
                                            if (!isModified) {
                                              return Dialog(
                                                backgroundColor: Colors.black87,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0), // Optional padding for aesthetics
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min, // Ensures the dialog is as small as needed
                                                    children: [
                                                      // Title for theme selection
                                                      Text(
                                                        languagesTextsFile.texts["pop_up_save_dialog"]!,
                                                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(height: screenHeight * 0.1),
                                                      // Dropdown menu for themes
                                                      Container(
                                                        color: Colors.amber,
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton2<ThemeObject>(
                                                            value: selectedTheme,
                                                            dropdownStyleData: DropdownStyleData(
                                                              maxHeight: screenHeight * 0.35,
                                                              decoration: const BoxDecoration(color: Colors.amber),
                                                            ),
                                                            style: const TextStyle(color: Color.fromRGBO(65, 65, 65, 1), fontWeight: FontWeight.bold, fontSize: 20),
                                                            onChanged: (ThemeObject? newValue) {
                                                              setState(() {
                                                                selectedTheme = newValue; // Update the selected theme
                                                              });
                                                            },
                                                            items: themesList.map((ThemeObject theme) {
                                                              return DropdownMenuItem<ThemeObject>(
                                                                value: theme,
                                                                child: Text(
                                                                  theme.title,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: screenHeight * 0.2),
                                                      //Buttons to cancel and validate
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
                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
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
                                                                  languagesTextsFile.texts["pop_up_cancel"]!,
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
                                                                await databaseManager.updateDialog(DialogObject(
                                                                  id_dialog: widget.idDialog,
                                                                  sentence: _controller.text,
                                                                  language: language,
                                                                  id_theme: selectedTheme!.id_theme,
                                                                ));
                                                                //Refresh the UI to display the success of modification
                                                                setState(() {
                                                                  isModified = true;
                                                                  _buttonAnimations["POPUP YES"] = false;
                                                                });
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
                                                                  languagesTextsFile.texts["pop_up_validate"]!,
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
                                            }
                                            // Popup to inform that the modification is a success
                                            else {
                                              return Dialog(
                                                backgroundColor: Colors.black87,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0), // Optional padding for aesthetics
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min, // Ensures the dialog is as small as needed
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.15),
                                                      // Title for theme selection
                                                      Text(
                                                        languagesTextsFile.texts["pop_up_modify_dialog_succes"]!,
                                                        style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(height: screenHeight * 0.2),
                                                      //Button to quit
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
                                                              languagesTextsFile.texts["pop_up_ok"]!,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: screenHeight * 0.025,
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
                                            }
                                          },
                                        );
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedTheme = value; // Update the main widget with the selected theme
                                        });
                                      }
                                    });
                                  } else {
                                    //Popup can't save an empty dialog
                                    _showGenericPopupOK(languagesTextsFile.texts["pop_up_cant_save_dialog"]!);
                                  }
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["MODIFY"] = false;
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.29,
                                  height: MediaQuery.of(context).size.width * 0.065,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(60)),
                                    color: Color.fromRGBO(255, 183, 34, 1),
                                  ),
                                  padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.01, 0),
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, MediaQuery.of(context).size.height * 0.03, 0, 0),
                                  child: Center(
                                    child: AutoSizeText(
                                      languagesTextsFile.texts["dialog_modify"]!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 10,
                                      maxFontSize: 18,
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

  ///Popup when the user try to quit without saving his modifications
  void _showTextUnsavedBackArrow() {
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
                      languagesTextsFile.texts["pop_up_dialog_unsaved"]!,
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
                              Navigator.pop(context);
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
                                languagesTextsFile.texts["pop_up_no"]!,
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
                              //Close the popup
                              Navigator.pop(context);
                              //Close the menu
                              Navigator.pop(context);
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
                                languagesTextsFile.texts["pop_up_yes"]!,
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

  ///Popup when the user try to quit without saving his modifications
  void _showTextUnsavedHomeButton() {
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
                      languagesTextsFile.texts["pop_up_dialog_unsaved"]!,
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
                              Navigator.pop(context);
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
                                languagesTextsFile.texts["pop_up_no"]!,
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
                              //Close the popup
                              Navigator.popUntil(
                                context,
                                    (route) => route.isFirst,
                              );
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
                                languagesTextsFile.texts["pop_up_yes"]!,
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

  ///Generic popup to display a specific [text] from the JSON and with an "OK" button
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


  ///Popup that display the list of contact and let choose to who we are sending the message
  void _showContactList() async {
    //Get contact list
    List<Contact> contactsList = await databaseManager.retrieveContacts();
    if(contactsList.isEmpty) {
      _showGenericPopupOK(languagesTextsFile.texts["pop_up_contact_empty"]!);
    }
    //Popup to choose the contact
    else {
      Contact? selectedContact = contactsList[0];
      //Set directly on the principal contact
      for(var c in contactsList) {
        if(c.priority == 1) {
          selectedContact = c;
          break;
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Use StatefulBuilder to manage the state inside the dialog
          return StatefulBuilder(
            builder: (context, setState) {
              double screenHeight = MediaQuery.of(context).size.height;
              double screenWidth = MediaQuery.of(context).size.width;
                return Dialog(
                  backgroundColor: Colors.black87,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // Optional padding for aesthetics
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Ensures the dialog is as small as needed
                      children: [
                        // Title for theme selection
                        Text(
                          languagesTextsFile.texts["pop_up_contact_send"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        // Dropdown menu for themes
                        Container(
                          color: Colors.amber,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Contact>(
                              value: selectedContact,
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: screenHeight * 0.35,
                                decoration: const BoxDecoration(color: Colors.amber),
                              ),
                              style: const TextStyle(color: Color.fromRGBO(65, 65, 65, 1), fontWeight: FontWeight.bold, fontSize: 20),
                              onChanged: (Contact? newValue) {
                                setState(() {
                                  selectedContact = newValue; // Update the selected contact
                                });
                              },
                              items: contactsList.map((Contact contact) {
                                return DropdownMenuItem<Contact>(
                                  value: contact,
                                  child: Text(
                                    //Show "(last name) (first name) - (method for contacting)"
                                    "${contact.last_name} ${contact.first_name} - ${contact.email != null ? languagesTextsFile.texts["list_contacts_mail"]! : languagesTextsFile.texts["list_contacts_phone"]!}",
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.2),
                        //Buttons to cancel and validate
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
                                  Navigator.pop(context);
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
                                    languagesTextsFile.texts["pop_up_cancel"]!,
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
                                  //Send message to selectedContact
                                  Navigator.of(context).pop();
                                  if (_controller.text.isNotEmpty) {
                                    //Send an E-Mail
                                    if (selectedContact!.email != null) {
                                      //todo update info sender
                                      String content = "${languagesTextsFile.texts["mail_body_1"]!} ${selectedContact!.first_name}, ${selectedContact!.email}\n\n${_controller.text}\n\n${languagesTextsFile.texts["mail_body_2"]!} ${selectedContact!.email} ${languagesTextsFile.texts["mail_body_3"]!}";
                                      final result = await emailHandler.sendMessage(selectedContact!.email!, content);
                                      if (mounted) { //Protect from trying to display the popup when the context has changed (ex : going back to the menu)
                                        if(result == 1) {
                                          String contactName = "${selectedContact!.last_name} ${selectedContact!.first_name}";
                                          _showGenericPopupOK("${languagesTextsFile.texts["pop_up_message_sent"]!}\n$contactName");
                                        }
                                        else if(result < 0) {
                                          _showGenericPopupOK(languagesTextsFile.texts["popup_message_send_fail"]!);
                                        }
                                      }
                                    }
                                    //Send a SMS
                                    else if(selectedContact!.phone != null) {
                                      String phoneNumber = selectedContact!.phone as String;
                                      final int result = await smsHandler.checkPermissionAndSendSMS(_controller.text, [phoneNumber]);
                                      if (mounted) {
                                        if(result == 1) {
                                          String contactName = "${selectedContact!.last_name} ${selectedContact!.first_name}";
                                          _showGenericPopupOK("${languagesTextsFile.texts["pop_up_message_sent"]!}\n$contactName");
                                        }
                                        else if(result == -1) {
                                          _showGenericPopupOK(languagesTextsFile.texts["popup_message_send_fail"]!);
                                        }
                                        else if(result == -2){
                                          _showGenericPopupOK(languagesTextsFile.texts["popup_message_permission_denied"]!);
                                        }
                                      }
                                    }
                                  }
                                  else {
                                    _showGenericPopupOK(languagesTextsFile.texts["pop_up_cant_send_empty_msg"]!);
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
                                    languagesTextsFile.texts["pop_up_validate"]!,
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

              },
          );
          },
      );
    }
  }


}
