// Relaxation Activities Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2


import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/views/customWidgets/customMenuButton.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/variables.dart';

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key});

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "IMAGES RELAX": false,
    "MUSIC RELAX": false,
    "SENTENCES RELAX": false,
    "RADIO RELAX": false,
    "YOUTUBE RELAX": false,
  };

  @override
  void initState() {
    super.initState();
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
                                Navigator.popUntil(
                                  context,
                                      (route) => route.isFirst,
                                );
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

                        // Title
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.835,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.19, MediaQuery.of(context).size.height / 16, 0, MediaQuery.of(context).size.height * 0.07),
                            child: CustomTitle(
                              text: languagesTextsFile.texts["main_relax"]!,
                              image: 'assets/beach-chair.png',
                              imageScale: 0.4,
                              backgroundColor: const Color.fromRGBO(160, 208, 86, 1),
                              textColor: Colors.white,
                              containerWidth: MediaQuery.of(context).size.width * 0.50,
                              containerHeight: MediaQuery.of(context).size.height * 0.12,
                              containerPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                              fontSize: MediaQuery.of(context).size.height * 0.1,
                              circleSize: MediaQuery.of(context).size.height * 0.1875,
                              circlePositionedLeft: MediaQuery.of(context).size.height * 0.0625 * -1,
                              fontWeight: FontWeight.w600,
                              alignment: const Alignment(0.07, 0),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Buttons at the right
                //todo add the dialog button
                Container(
                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.012),
                  child: Column(
                    children: [
                      // Help Button
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
                            // Button Code
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

                      // Home Button
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
                            // Button Code
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
                    ],
                  ),
                ),
              ],
            ),

            // List of relaxation activities
            Expanded(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // Radio
                      if(relaxActivities.contains("radio")) 
                        AnimatedScale(
                        scale: _buttonAnimations["RADIO RELAX"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["RADIO RELAX"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["RADIO RELAX"] = false;
                            });
                            // Button Code
                            print("RADIOOOOO");


                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["RADIO RELAX"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(255, 231, 69, 1),
                            textColor: const Color.fromRGBO(241, 101, 2, 1),
                            image: 'assets/relax_radio.png',
                            text: languagesTextsFile.texts["relax_radio"]!,
                            imageScale: 1.4,
                            scale: isThisDeviceATablet ? 1.05 : 1.2,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                            sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                          ),
                        ),
                      ),

                      // Music
                      if(relaxActivities.contains("music"))
                        AnimatedScale(
                          scale: _buttonAnimations["MUSIC RELAX"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["MUSIC RELAX"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["MUSIC RELAX"] = false;
                              });
                              // Button Code
                              print("MUSIIIIIC");

                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["MUSIC RELAX"] = false;
                              });
                            },
                            child: CustomMenuButton(
                              backgroundColor: const Color.fromRGBO(63, 154, 255, 1),
                              textColor: Colors.white,
                              image: 'assets/relax_music.png',
                              text: languagesTextsFile.texts["relax_music"]!,
                              imageScale: 1.2,
                              scale: isThisDeviceATablet ? 1.05 : 1.2,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                              sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                            ),
                          ),
                        ),
                      
                      // Images
                      if(relaxActivities.contains("images"))
                        AnimatedScale(
                          scale: _buttonAnimations["IMAGES RELAX"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["IMAGES RELAX"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["IMAGES RELAX"] = false;
                              });
                              // Button Code
                              print("IMAGEEEEEES");

                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["IMAGES RELAX"] = false;
                              });
                            },
                            child: CustomMenuButton(
                              backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                              textColor: const Color.fromRGBO(87, 164, 255, 1),
                              image: 'assets/relax_image.png',
                              text: languagesTextsFile.texts["relax_images"]!,
                              imageScale: 1.4,
                              scale: isThisDeviceATablet ? 1.05 : 1.2,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                              sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                            ),
                          ),
                        ),

                      // Reflexive sentences
                      if(relaxActivities.contains("sentences"))
                        AnimatedScale(
                          scale: _buttonAnimations["SENTENCES RELAX"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["SENTENCES RELAX"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["SENTENCES RELAX"] = false;
                              });
                              // Button Code
                              print("REFLEXIVE SENTENCEEEES");

                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["SENTENCES RELAX"] = false;
                              });
                            },
                            child: CustomMenuButton(
                              backgroundColor: const Color.fromRGBO(0, 148, 148, 1),
                              textColor: Colors.white,
                              image: 'assets/relax_yoga.png',
                              text: languagesTextsFile.texts["relax_sentences"]!,
                              imageScale: 1.4,
                              scale: isThisDeviceATablet ? 1.05 : 1.2,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                              sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                            ),
                          ),
                        ),
                      
                      // Youtube
                      if(relaxActivities.contains("youtube"))
                        AnimatedScale(
                          scale: _buttonAnimations["YOUTUBE RELAX"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["YOUTUBE RELAX"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["YOUTUBE RELAX"] = false;
                              });
                              // Button Code
                              print("YOUTUUUUUUUUUBE");

                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["YOUTUBE RELAX"] = false;
                              });
                            },
                            child: CustomMenuButton(
                              backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
                              textColor: Colors.white,
                              image: 'assets/relax_youtube.png',
                              text: languagesTextsFile.texts["relax_youtube"]!,
                              imageScale: 1.4,
                              scale: isThisDeviceATablet ? 1.05 : 1.2,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                              sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                            ),
                          ),
                        ),
                      
                    ],
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }
}
