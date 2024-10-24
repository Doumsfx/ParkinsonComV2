// App Settings Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2


import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/views/customWidgets/customMenuButton.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/variables.dart';


class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "SAVE": false,
    "TOP ARROW": false,
    "BOT ARROW": false,
    "TTS": false,
  };
  final ScrollController _scrollController = ScrollController();
  bool checkboxAzerty = azerty;
  bool checkboxAbcde = !azerty;

  final List<bool> checkboxIconsAndTexts = [false, false, false];

  bool checkboxFR = language == "fr" ? true : false;
  bool checkboxNL = language == "nl" ? true : false;

  bool checkboxMan = ttsGender == "male" ? true : false;
  bool checkboxWoman = ttsGender == "male" ? false : true;

  double currentTone = ttsTone;
  double currentSpeed = ttsSpeed * 2;
  double currentVolume = ttsVolume * 2;

  @override
  void initState() {
    super.initState();
    checkboxIconsAndTexts[customMenuButtonType - 1] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: Stack(
          children: [
            // The page
            Column(
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

                                    // Updating the TTSHandler
                                    ttsHandler.setVoiceFrOrNl(language, ttsGender);
                                    ttsHandler.setPitch(ttsTone);
                                    ttsHandler.setRate(ttsSpeed);
                                    ttsHandler.setVolume(ttsVolume);

                                    Navigator.pop(context);

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
                                  text: languagesTextsFile.texts["app_settings_title"]!,
                                  image: 'assets/profile-user.png',
                                  imageScale: 1,
                                  backgroundColor: const Color.fromRGBO(244, 107, 55, 1),
                                  textColor: Colors.white,
                                  containerWidth: MediaQuery.of(context).size.width * 0.50,
                                  containerHeight: MediaQuery.of(context).size.height * 0.12,
                                  containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.01, 0, 0),
                                  fontSize: MediaQuery.of(context).size.height * 0.07,
                                  circleSize: MediaQuery.of(context).size.height * 0.1875,
                                  circlePositionedLeft: MediaQuery.of(context).size.height * 0.0625 * -1,
                                  fontWeight: FontWeight.w600,
                                  alignment: const Alignment(0.07, 0),
                                  sizedBoxWidth: MediaQuery.of(context).size.width * 0.35,

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

                // SingleChildScrollView
                Expanded(
                  child: RawScrollbar(
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
                    padding: isThisDeviceATablet ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.28) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.027, MediaQuery.of(context).size.height * 0.34),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List of dialogs
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          child: Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title 1
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0, 0, MediaQuery.of(context).size.height * 0.01),
                                  child: Text(
                                    languagesTextsFile.texts["app_settings_text1"],
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Widgets for keyboard
                                Row(
                                  children: [
                                    // Azerty Container
                                    GestureDetector(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.15,
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.035, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(72, 69, 78, 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.width * 0.015),
                                          ),
                                          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.height * 0.005),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "AZERTY",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,

                                            ),
                                          ),
                                        ),

                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxAbcde = false;
                                          checkboxAzerty = true;
                                        });
                                      },
                                    ),

                                    // Azerty Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxAzerty,
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value) {
                                          setState(() {
                                            checkboxAbcde = false;
                                            checkboxAzerty = true;
                                          });
                                        },
                                      ),
                                    ),

                                    // Abcde Container
                                    GestureDetector(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.15,
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(72, 69, 78, 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.width * 0.015),
                                          ),
                                          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.height * 0.005),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "ABCDE",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,

                                            ),
                                          ),
                                        ),

                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxAbcde = true;
                                          checkboxAzerty = false;
                                        });
                                      },
                                    ),

                                    // Abcde Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxAbcde,
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value) {
                                          setState(() {
                                            checkboxAbcde = true;
                                            checkboxAzerty = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Title 2
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.01),
                                  child: Text(
                                    languagesTextsFile.texts["app_settings_text2"],
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Widgets for Icons and Texts
                                Row(
                                  children: [
                                    // Full Icon + Text Container
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        child: CustomMenuButton(
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          image: 'assets/image.png',
                                          text: "Aa",
                                          imageScale: 1.4,
                                          scale: 0.6,
                                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                                          sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                                          type: 1,
                                        ),
                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxIconsAndTexts[0] = true;
                                          checkboxIconsAndTexts[1] = false;
                                          checkboxIconsAndTexts[2] = false;
                                        });
                                      },
                                    ),

                                    // Full Icon + Text Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxIconsAndTexts[0],
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value) {
                                          setState(() {
                                            checkboxIconsAndTexts[0] = true;
                                            checkboxIconsAndTexts[1] = false;
                                            checkboxIconsAndTexts[2] = false;
                                          });
                                        },
                                      ),
                                    ),

                                    // Icon Only Container
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        child: CustomMenuButton(
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          image: 'assets/image.png',
                                          text: "Aa",
                                          imageScale: 1.4,
                                          scale: 0.6,
                                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                                          sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                                          type: 2,
                                        ),
                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxIconsAndTexts[0] = false;
                                          checkboxIconsAndTexts[1] = true;
                                          checkboxIconsAndTexts[2] = false;
                                        });
                                      },
                                    ),

                                    // Icon Only Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxIconsAndTexts[1],
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value){
                                          setState(() {
                                            checkboxIconsAndTexts[0] = false;
                                            checkboxIconsAndTexts[1] = true;
                                            checkboxIconsAndTexts[2] = false;
                                          });
                                        },
                                      ),
                                    ),

                                    // Text Only Container
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        child: CustomMenuButton(
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          image: 'assets/image.png',
                                          text: "Aa",
                                          imageScale: 1.4,
                                          scale: 0.6,
                                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.012),
                                          sizedBoxHeight: MediaQuery.of(context).size.height * 0.058,
                                          type: 3,
                                        ),
                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxIconsAndTexts[0] = false;
                                          checkboxIconsAndTexts[1] = false;
                                          checkboxIconsAndTexts[2] = true;
                                        });
                                      },
                                    ),


                                    // Text Only Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxIconsAndTexts[2],
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value){
                                          setState(() {
                                            checkboxIconsAndTexts[0] = false;
                                            checkboxIconsAndTexts[1] = false;
                                            checkboxIconsAndTexts[2] = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Title 3
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.01),
                                  child: Text(
                                    languagesTextsFile.texts["app_settings_text3"],
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Widgets for languages
                                Row(
                                  children: [
                                    // Full Icon + Text Container
                                    GestureDetector(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.09,
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.035, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(72, 69, 78, 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.width * 0.015),
                                          ),
                                          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.height * 0.005),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "FR",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,

                                            ),
                                          ),
                                        ),

                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxFR = true;
                                          checkboxNL = false;
                                        });
                                      },
                                    ),

                                    // Full Icon + Text Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxFR,
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value) {
                                          setState(() {
                                            checkboxFR = true;
                                            checkboxNL = false;
                                          });
                                        },
                                      ),
                                    ),

                                    // Icon Only Container
                                    GestureDetector(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.09,
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(72, 69, 78, 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.width * 0.015),
                                          ),
                                          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.height * 0.005),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "NL",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,

                                            ),
                                          ),
                                        ),

                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxFR = false;
                                          checkboxNL = true;
                                        });
                                      },
                                    ),

                                    // Icon Only Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxNL,
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value){
                                          setState(() {
                                            checkboxFR = false;
                                            checkboxNL = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Title 4 + TTS
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0, 0, MediaQuery.of(context).size.height * 0.01),
                                  child: Row(
                                    children: [
                                      // Title
                                      Text(
                                        languagesTextsFile.texts["app_settings_text4"],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height * 0.04,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),

                                      // Spacing
                                      const Expanded(child: SizedBox()),

                                      // TTS
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

                                              // TTS
                                              ttsHandler.setText("Test de la synthèse vocale");
                                              ttsHandler.setVolume(currentVolume / 2);
                                              ttsHandler.setRate(currentSpeed / 2);
                                              ttsHandler.setPitch(currentTone);
                                              ttsHandler.setVoiceFrOrNl(checkboxFR ? "fr" : "nl", checkboxMan ? "male" : "female");
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
                                            height: MediaQuery.of(context).size.height * 0.11,
                                            width: MediaQuery.of(context).size.height * 0.11,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Spacing
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.1,),

                                    ],
                                  ),
                                ),

                                // Gender of the voice
                                Row(
                                  children: [
                                    // Gender of the voice
                                    Container(
                                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
                                      child: Text(
                                        languagesTextsFile.texts["app_settings_gender"],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height * 0.04,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    // Spacing
                                    const Expanded(child: SizedBox()),

                                    // Man Container
                                    GestureDetector(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.067,
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.035, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(72, 69, 78, 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.width * 0.015),
                                          ),
                                          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.height * 0.005),
                                        ),
                                        child: Center(
                                          child: Text(
                                            languagesTextsFile.texts["app_settings_man"],
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,

                                            ),
                                          ),
                                        ),

                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxMan = true;
                                          checkboxWoman = false;
                                        });
                                      },
                                    ),

                                    // Man Checkbox
                                    Transform.scale(
                                      scale: MediaQuery.of(context).size.height * 0.004,
                                      child: Checkbox(
                                        value: checkboxMan,
                                        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                        side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                        onChanged: (value) {
                                          setState(() {
                                            checkboxMan = true;
                                            checkboxWoman = false;
                                          });
                                        },
                                      ),
                                    ),

                                    // Woman Container
                                    GestureDetector(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.067,
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, 0, MediaQuery.of(context).size.width * 0.015, 0),
                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(72, 69, 78, 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.width * 0.015),
                                          ),
                                          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.height * 0.005),
                                        ),
                                        child: Center(
                                          child: Text(
                                            languagesTextsFile.texts["app_settings_woman"],
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                      ),

                                      onTap: () {
                                        setState(() {
                                          checkboxMan = false;
                                          checkboxWoman = true;
                                        });
                                      },
                                    ),

                                    // Woman Checkbox
                                    Container(
                                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.14),
                                      child: Transform.scale(
                                        scale: MediaQuery.of(context).size.height * 0.004,
                                        child: Checkbox(
                                          value: checkboxWoman,
                                          shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                          side: BorderSide(color: Colors.white, width: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.0025 : MediaQuery.of(context).size.height * 0.0045),

                                          onChanged: (value){
                                            setState(() {
                                              checkboxMan = false;
                                              checkboxWoman = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Tone of the voice
                                Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Row(
                                    children: [
                                      // Tone of the voice
                                      Container(
                                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
                                        child: Text(
                                          languagesTextsFile.texts["app_settings_tone"],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Spacing
                                      const Expanded(child: SizedBox()),

                                      // Current Tone
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.05,
                                        child: Center(
                                          child: Text(
                                            currentTone.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Tone Slider
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.105),
                                        child: Slider(
                                          value: currentTone,
                                          max: 2,
                                          min: 0.5,
                                          thumbColor: Colors.blue,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),

                                          onChanged: (value) {
                                            setState(() {
                                              currentTone = value;
                                            });
                                          },
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                                // Speed of the voice
                                Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Row(
                                    children: [
                                      // Speed of the voice
                                      Container(
                                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
                                        child: Text(
                                          languagesTextsFile.texts["app_settings_speed"],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Spacing
                                      const Expanded(child: SizedBox()),

                                      // Current Speed
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.05,
                                        child: Center(
                                          child: Text(
                                            currentSpeed.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Speed Slider
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.105),
                                        child: Slider(
                                          value: currentSpeed,
                                          max: 2,
                                          min: 0.01 ,
                                          thumbColor: Colors.blue,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),

                                          onChanged: (value) {
                                            setState(() {
                                              currentSpeed = value;
                                            });
                                          },
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                                // Volume of the voice
                                Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Row(
                                    children: [
                                      // Volume of the voice
                                      Container(
                                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
                                        child: Text(
                                          languagesTextsFile.texts["app_settings_volume"],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Spacing
                                      const Expanded(child: SizedBox()),

                                      // Current Volume
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.05,
                                        child: Center(
                                          child: Text(
                                            currentVolume.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Volume Slider
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.105),
                                        child: Slider(
                                          value: currentVolume,
                                          max: 2,
                                          min: 0,
                                          thumbColor: Colors.blue,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),

                                          onChanged: (value) {
                                            setState(() {
                                              currentVolume = value;
                                            });
                                          },
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                                // Spacing
                                SizedBox(height: MediaQuery.of(context).size.height * 0.1,)

                              ],
                            ),
                          ),
                        ),

                        const Expanded(child: SizedBox()),

                        // ScrollWidgets
                        Container(
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top Arrow
                              AnimatedScale(
                                scale: _buttonAnimations["TOP ARROW"]! ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceOut,
                                child: GestureDetector(
                                  // Animation management
                                  onTap: () {
                                    _scrollController.animateTo(
                                      _scrollController.offset - 120,
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

                              // Container for when the scrollbar is empty
                              Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.01875,
                                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.02),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromRGBO(66, 89, 109, 1),
                                    ),
                                  )
                              ),

                              // Bottom Arrow
                              AnimatedScale(
                                scale: _buttonAnimations["BOT ARROW"]! ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceOut,
                                child: GestureDetector(
                                  // Animation management
                                  onTap: () {
                                    _scrollController.animateTo(
                                      _scrollController.offset + 120,
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
                                    margin: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      0,
                                      MediaQuery.of(context).size.width * 0.115,
                                    ),
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
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),

            // Save Icon
            Positioned(
              bottom: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: AnimatedScale(
                scale: _buttonAnimations["SAVE"]! ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceOut,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _buttonAnimations["SAVE"] = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _buttonAnimations["SAVE"] = false;
                    });
                    // Button Code
                    print("SAVEEEEEEEEEEEEEEEEE");

                    // TODO Afficher une pop up disant que c'est bon c'est enregistré

                    setState(() {
                      // Keyboard
                      azerty = checkboxAzerty ? true : false;

                      // Icons and Texts
                      customMenuButtonType = checkboxIconsAndTexts[0] ? 1 : checkboxIconsAndTexts[1] ? 2 : 3;

                      // Languages
                      language = checkboxFR ? "fr" : "nl";

                      // TTS
                      ttsGender = checkboxMan ? "male" : "female";
                      ttsTone = currentTone;
                      ttsSpeed = currentSpeed / 2; // Because it's between 0 and 1
                      ttsVolume = currentVolume / 2; // Because it's between 0 and 1

                      // Updating the TTSHandler
                      ttsHandler.setVoiceFrOrNl(language, ttsGender);
                      ttsHandler.setPitch(ttsTone);
                      ttsHandler.setRate(ttsSpeed);
                      ttsHandler.setVolume(ttsVolume);
                    });

                    Navigator.pop(context);


                  },
                  onTapCancel: () {
                    setState(() {
                      _buttonAnimations["SAVE"] = false;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.085,
                    width: MediaQuery.of(context).size.width * 0.085,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(74, 239, 221, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/save.png",
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
