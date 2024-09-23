// Main Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_com_v2/customHomePageTitle.dart';
import 'package:parkinson_com_v2/customMenuButton.dart';
import 'package:parkinson_com_v2/customShapeMenu.dart';
import 'package:parkinson_com_v2/listDialogsPage.dart';
import 'package:parkinson_com_v2/variables.dart';
import 'package:battery_plus/battery_plus.dart';

import 'models/internetAlert.dart';

void main() {
  // We put the game in full screen mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // First initialization of the database manager when launching the app
  databaseManager.initDB();

  // Initialization of the TTS handler when launching the app
  ttsHandler.initTts();

  // Set the texts to the default language
  languagesTextsFile.setNewLanguage("fr");

  // We ensure that the phone preserve the landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late InternetAlert internetAlert;
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "POWER": false,
    "HELP": false,
    "DIALOG": false,
    "RELAX": false,
    "SETTINGS": false,
    "REMINDERS": false,
    "CONTACTS": false,
  };
  var battery = Battery();
  int batteryLevel = 0;
  late Timer timer;
  var timeAndDate = DateTime.now();

  Future<void> initialisation() async {
    batteryLevel = await battery.batteryLevel;
  }

  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  void initState() {
    super.initState();
    // Initialisation de nos variables
    initialisation();

    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      int newBatteryLevel = await battery.batteryLevel;
      DateTime newTimeAndDate = DateTime.now();

      // Update of our variables
      setState(() {
        batteryLevel = newBatteryLevel;
        timeAndDate = newTimeAndDate;
      });
    });

    //Internet Checker
    internetAlert = InternetAlert();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      internetAlert.startCheckInternet(context);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: Column(
          children: [
            // First part
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time + Date + Battery
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Button + Battery %
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Power Button
                                  AnimatedScale(
                                    scale: _buttonAnimations["POWER"]! ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _buttonAnimations["POWER"] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _buttonAnimations["POWER"] = false;
                                        });
                                        // BUTTON CODE
                                        SystemNavigator.pop();
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _buttonAnimations["POWER"] = false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.015, 0, 0),
                                        child: Image.asset(
                                          'assets/power-button.png',
                                          width: MediaQuery.of(context).size.height * 0.1,
                                          height: MediaQuery.of(context).size.height * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Text
                                  Container(
                                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.08, MediaQuery.of(context).size.height * 0.04, MediaQuery.of(context).size.height * 0.02, 0),
                                    child: Text(
                                      "$batteryLevel%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),

                                  // Battery
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, MediaQuery.of(context).size.width * 0.015, 0),
                                    child: Image.asset(
                                      'assets/batterie.png',
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      height: MediaQuery.of(context).size.height * 0.07,
                                    ),
                                  ),

                                  const Expanded(child: SizedBox()),
                                ],
                              ),

                              // Date
                              Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                child: Text(
                                  "${formatWithTwoDigits(timeAndDate.day)}/${formatWithTwoDigits(timeAndDate.month)}/${timeAndDate.year}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              // Time
                              Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, 0, 0),
                                child: Text(
                                  "${formatWithTwoDigits(timeAndDate.hour)}:${formatWithTwoDigits(timeAndDate.minute)}:${formatWithTwoDigits(timeAndDate.second)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          )),

                      // Title
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.685,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, MediaQuery.of(context).size.height / 16, 0, 0),
                          child: CustomHomePageTitle(
                            text: languagesTextsFile.texts["main_title"]!,
                            image: 'assets/home.png',
                            backgroundColor: const Color.fromRGBO(0, 204, 255, 1),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Help Button
                  Container(
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

                              setState(() {
                                if(language == "fr") {
                                  language = "nl";
                                } else {
                                  language = "fr";
                                }
                                ttsHandler.setVoiceFrOrNl(language, 'female');
                                languagesTextsFile.setNewLanguage(language);
                              });
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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Middle part
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dialog button
                    Container(
                      margin: MediaQuery.of(context).size.height > 600 ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.27) : EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.29),
                      child: AnimatedScale(
                        scale: _buttonAnimations["DIALOG"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["DIALOG"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["DIALOG"] = false;
                            });
                            // BUTTON CODE
                            print("DIALOOOOOOOOOOG");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListDialogsPage(),
                                )).then((_) => initialisation());
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["DIALOG"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(61, 192, 200, 1),
                            textColor: Colors.white,
                            image: 'assets/dialog.png',
                            text: languagesTextsFile.texts["main_dialog"]!,
                            imageScale: 1,
                            scale: MediaQuery.of(context).size.height > 600 ? 1 : 1.2,
                          ),
                        ),
                      ),
                    ),

                    // Relax button
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12),
                      child: AnimatedScale(
                        scale: _buttonAnimations["RELAX"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
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
                            print("RELAAAAAAAAAAAAAX");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["RELAX"] = false;
                            });
                          },
                          child: CustomMenuButton(
                            backgroundColor: const Color.fromRGBO(160, 208, 86, 1),
                            textColor: Colors.white,
                            image: 'assets/beach-chair.png',
                            text: languagesTextsFile.texts["main_relax"]!,
                            imageScale: 1.4,
                            scale: MediaQuery.of(context).size.height > 600 ? 1 : 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

            // Last part
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Row(
                  children: [
                    // Settings
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                      child: AnimatedScale(
                        scale: _buttonAnimations["SETTINGS"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["SETTINGS"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["SETTINGS"] = false;
                            });
                            // BUTTON CODE
                            print("SETTINGGGGGGGGGS");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["SETTINGS"] = false;
                            });
                          },
                          child: CustomShapeMenu(
                            text: languagesTextsFile.texts["main_settings"]!,
                            image: 'assets/profile-user.png',
                            backgroundColor: const Color.fromRGBO(245, 107, 56, 1),
                            textColor: const Color.fromRGBO(35, 55, 79, 1),
                            imageScale: 5,
                            scale: MediaQuery.of(context).size.height > 600 ? 1 : 0.85,
                          ),
                        ),
                      ),
                    ),

                    // Reminders
                    Expanded(
                      child: Center(
                        child: AnimatedScale(
                          scale: _buttonAnimations["REMINDERS"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // Animation management
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["REMINDERS"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["REMINDERS"] = false;
                              });
                              // BUTTON CODE
                              print("REMINNNNNNDERS");
                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["REMINDERS"] = false;
                              });
                            },
                            child: CustomShapeMenu(
                              text: languagesTextsFile.texts["main_reminders"]!,
                              image: 'assets/horloge.png',
                              backgroundColor: Colors.white,
                              textColor: const Color.fromRGBO(224, 106, 109, 1),
                              imageScale: 1,
                              scale: MediaQuery.of(context).size.height > 600 ? 1 : 0.85,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Contacts
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.07),
                      child: AnimatedScale(
                        scale: _buttonAnimations["CONTACTS"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          // Animation management
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["CONTACTS"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["CONTACTS"] = false;
                            });
                            // BUTTON CODE
                            print("CONTACTSSSSS");
                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["CONTACTS"] = false;
                            });
                          },
                          child: CustomShapeMenu(
                            text: languagesTextsFile.texts["main_contacts"]!,
                            image: 'assets/enveloppe.png',
                            backgroundColor: const Color.fromRGBO(12, 178, 255, 1),
                            textColor: const Color.fromRGBO(35, 55, 79, 1),
                            imageScale: 0.9,
                            scale: MediaQuery.of(context).size.height > 600 ? 1 : 0.85,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
