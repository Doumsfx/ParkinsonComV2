// Home Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parkinson_com_v2/views/customWidgets/customHomePageTitle.dart';
import 'package:parkinson_com_v2/views/customWidgets/customMenuButton.dart';
import 'package:parkinson_com_v2/views/contacts/listContactsPage.dart';
import 'package:parkinson_com_v2/views/dialogs/listDialogsPage.dart';
import 'package:parkinson_com_v2/views/reminders/listRemindersPage.dart';
import 'package:parkinson_com_v2/loginPage.dart';
import 'package:parkinson_com_v2/CustomShape.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:battery_plus/battery_plus.dart';

import 'models/internetAlert.dart';

void main() async {
  // We put the game in full screen mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Detect if it is the first time we are launching the app using the existence of the database or not
  isFirstLaunch = !(await databaseManager.doesExist()); // first time <=> no database existing

  // Initialization of the TTS handler when launching the app
  ttsHandler.initTts();

  if(!isFirstLaunch) {
    // Initialization of the database manager when launching the app (create or open the database)
    databaseManager.initDB();
  }

  // Set the texts to the default language
  languagesTextsFile.setNewLanguage("fr");

  // Load .env variables
  loadEnvVariables();

  // We ensure that the phone preserve the landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
  ]).then((_) {

  // Launch the app
  runApp(const MyApp());});
}

/// Load Environment Variables from the .env file
Future<void> loadEnvVariables() async {
  await dotenv.load(fileName: ".env");
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  // Useful variables
  late InternetAlert internetAlert;
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
  var isMusicPaused = false;

  /// Function to initialise our variables
  Future<void> initialisation() async {
    batteryLevel = await battery.batteryLevel;
  }

  /// Function to format a [number] into a two format digit, for example '2' becomes '02'
  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Function to check if the device is a tablet or not, true: tablet, false: phone
  bool isTablet() {
    // The threshold is generally set at 600 to separate phones from tablets.
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  void initState() {
    super.initState();
    // Initialization of the variables
    initialisation();
    WidgetsBinding.instance.addObserver(this);

    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      int newBatteryLevel = await battery.batteryLevel;
      DateTime newTimeAndDate = DateTime.now();

      // Updates of our variables
      setState(() {
        batteryLevel = newBatteryLevel;
        timeAndDate = newTimeAndDate;
      });

    });

    // Internet Checker
    internetAlert = InternetAlert();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      internetAlert.startCheckInternet(context);
    });

    // Initialization of our Notifications for Android
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Initialisation of our Notification Handler
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationHandler.startCheck(context, flutterLocalNotificationsPlugin);

      if(isTablet()){
        isThisDeviceATablet = true;
      }
      else{
        isThisDeviceATablet = false;
      }
    });

  }


  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    notificationHandler.dispose();
    super.dispose();
  }

  /// Method to monitor application lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive){
      // If the app is minimized or put in the background, we stop the music if it's playing
      if(notificationHandler.isMusicPlaying()){
        notificationHandler.pauseMusic();
        isMusicPaused = true;
      }

      // Otherwise we put the volume at 0
      else{
        notificationHandler.setVolume(0);
      }

    } else if (state == AppLifecycleState.resumed) {
      // If the application returns to the foreground, we restart the music if it was paused
      if(isMusicPaused){
        notificationHandler.setVolume(1);
        notificationHandler.resumeMusic();
        isMusicPaused = false;
      }

      // Otherwise we just put the volume at 1
      else{
        notificationHandler.setVolume(1);
        isMusicPaused = false;
      }
    }
  }

  void _handleLoginSuccess() {
    setState(() {
      isFirstLaunch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if(isFirstLaunch){
        return LoginPage(onLoginSuccess: _handleLoginSuccess);
      }
      else{
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
                                            // Button Code
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
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.08, MediaQuery.of(context).size.height * 0.04, MediaQuery.of(context).size.height * 0.019, 0),
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
                                        margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, MediaQuery.of(context).size.width * 0.010, 0),
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
                          margin: isThisDeviceATablet ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.27) : EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.29),
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
                                // Button Code
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
                                scale: isThisDeviceATablet ? 1 : 1.2,
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
                                // Button Code
                                print("RELAAAAAAAAAAAAAX");

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
                                  _buttonAnimations["RELAX"] = false;
                                });
                              },
                              child: CustomMenuButton(
                                backgroundColor: const Color.fromRGBO(160, 208, 86, 1),
                                textColor: Colors.white,
                                image: 'assets/beach-chair.png',
                                text: languagesTextsFile.texts["main_relax"]!,
                                imageScale: 1.4,
                                scale: isThisDeviceATablet ? 1 : 1.2,
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
                                // Button Code
                                print("SETTINGGGGGGGGGS");


                              },
                              onTapCancel: () {
                                setState(() {
                                  _buttonAnimations["SETTINGS"] = false;
                                });
                              },
                              child: CustomShape(
                                text: languagesTextsFile.texts["main_settings"]!,
                                image: 'assets/profile-user.png',
                                backgroundColor: const Color.fromRGBO(245, 107, 56, 1),
                                textColor: const Color.fromRGBO(35, 55, 79, 1),
                                imageScale: 3,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                containerWidth: MediaQuery.of(context).size.width * 0.23,
                                containerHeight: MediaQuery.of(context).size.width * 0.05,
                                containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.035, 0),
                                circlePositionedRight: MediaQuery.of(context).size.width * 0.001 * -1,
                                circleSize: MediaQuery.of(context).size.width * 0.085,
                                sizedBoxHeight: MediaQuery.of(context).size.width * 0.085,
                                sizedBoxWidth: MediaQuery.of(context).size.width * 0.2725,
                                scale: isThisDeviceATablet ? 1 : 0.85,



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
                                  // Button Code
                                  print("REMINNNNNNDERS");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ListRemindersPage(),
                                      )).then((_) => initialisation());
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["REMINDERS"] = false;
                                  });
                                },
                                child: CustomShape(
                                  text: languagesTextsFile.texts["main_reminders"]!,
                                  image: 'assets/horloge.png',
                                  backgroundColor: Colors.white,
                                  textColor: const Color.fromRGBO(224, 106, 109, 1),
                                  imageScale: 1.1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  containerWidth: MediaQuery.of(context).size.width * 0.23,
                                  containerHeight: MediaQuery.of(context).size.width * 0.05,
                                  containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.035, 0),
                                  circlePositionedRight: MediaQuery.of(context).size.width * 0.001 * -1,
                                  circleSize: MediaQuery.of(context).size.width * 0.085,
                                  sizedBoxHeight: MediaQuery.of(context).size.width * 0.085,
                                  sizedBoxWidth: MediaQuery.of(context).size.width * 0.2725,
                                  scale: isThisDeviceATablet ? 1 : 0.85,
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
                                // Button Code
                                print("CONTACTSSSSS");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListContactsPage(),
                                    )).then((_) => initialisation());
                              },
                              onTapCancel: () {
                                setState(() {
                                  _buttonAnimations["CONTACTS"] = false;
                                });
                              },
                              child: CustomShape(
                                text: languagesTextsFile.texts["main_contacts"]!,
                                image: 'assets/enveloppe.png',
                                backgroundColor: const Color.fromRGBO(12, 178, 255, 1),
                                textColor: const Color.fromRGBO(35, 55, 79, 1),
                                imageScale: 0.9,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                containerWidth: MediaQuery.of(context).size.width * 0.23,
                                containerHeight: MediaQuery.of(context).size.width * 0.05,
                                containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.035, 0),
                                circlePositionedRight: MediaQuery.of(context).size.width * 0.001 * -1,
                                circleSize: MediaQuery.of(context).size.width * 0.085,
                                sizedBoxHeight: MediaQuery.of(context).size.width * 0.085,
                                sizedBoxWidth: MediaQuery.of(context).size.width * 0.2725,
                                scale: isThisDeviceATablet ? 1 : 0.85,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ));
      }

    },);
  }
}
