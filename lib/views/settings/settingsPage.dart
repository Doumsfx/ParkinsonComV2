// Settings Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2


import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/views/customWidgets/customMenuButton.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/variables.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "USER SETTINGS": false,
    "APP SETTINGS": false,
    "RELAX SETTINGS": false,
    "MEDIA SETTINGS": false,
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
                              text: languagesTextsFile.texts["settings_page_title"]!,
                              image: 'assets/profile-user.png',
                              imageScale: 1,
                              backgroundColor: const Color.fromRGBO(244, 107, 55, 1),
                              textColor: Colors.white,
                              containerWidth: MediaQuery.of(context).size.width * 0.50,
                              containerHeight: MediaQuery.of(context).size.height * 0.12,
                              containerPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                              fontSize: MediaQuery.of(context).size.height * 0.1,
                              circleSize: MediaQuery.of(context).size.height * 0.1875,
                              circlePositionedLeft: MediaQuery.of(context).size.height * 0.0625 * -1,
                              fontWeight: FontWeight.w700,
                              alignment: const Alignment(0.07, 0),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Buttons at the right
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

            // List of settings
            Expanded(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // User Settings
                      AnimatedScale(
                        scale: _buttonAnimations["USER SETTINGS"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["USER SETTINGS"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["USER SETTINGS"] = false;
                            });
                            // Button Code
                            print("USERRRRRRRRRRRRRR");

                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["USER SETTINGS"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(244, 107, 55, 1),
                            textColor: Colors.white,
                            image: 'assets/user.png',
                            text: languagesTextsFile.texts["settings_page_user"]!,
                            imageScale: 1.4,
                            scale: isThisDeviceATablet ? 1.05 : 1.2,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                            sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                          ),
                        ),
                      ),

                      // App Settings
                      AnimatedScale(
                        scale: _buttonAnimations["APP SETTINGS"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["APP SETTINGS"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["APP SETTINGS"] = false;
                            });
                            // Button Code
                            print("APPPPPPPPPPPPPPP");

                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["APP SETTINGS"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(136, 113, 255, 1),
                            textColor: Colors.white,
                            image: 'assets/user-settings.png',
                            text: languagesTextsFile.texts["settings_page_settings"]!,
                            imageScale: 1.2,
                            scale: isThisDeviceATablet ? 1.05 : 1.2,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                            sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                          ),
                        ),
                      ),

                      // Relaxation Settings
                      AnimatedScale(
                        scale: _buttonAnimations["RELAX SETTINGS"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["RELAX SETTINGS"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["RELAX SETTINGS"] = false;
                            });
                            // Button Code
                            print("RELAAAAAAAAAAAAAX");

                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["RELAX SETTINGS"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(160, 208, 86, 1),
                            textColor: Colors.white,
                            image: 'assets/beach-chair.png',
                            text: languagesTextsFile.texts["settings_page_relaxation"]!,
                            imageScale: 1.4,
                            scale: isThisDeviceATablet ? 1.05 : 1.2,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                            sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                          ),
                        ),
                      ),

                      // Media Settings
                      AnimatedScale(
                        scale: _buttonAnimations["MEDIA SETTINGS"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["MEDIA SETTINGS"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["MEDIA SETTINGS"] = false;
                            });
                            // Button Code
                            print("MEDIAAAAAAAAAAAAAAAAAAAA");

                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["MEDIA SETTINGS"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(0, 180, 181, 1),
                            textColor: Colors.white,
                            image: 'assets/multimedia.png',
                            text: languagesTextsFile.texts["settings_page_media"]!,
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
        ));
  }
}
