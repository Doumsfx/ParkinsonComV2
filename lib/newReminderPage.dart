// List of dialogs filtered by themes Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/customTitle.dart';
import 'package:parkinson_com_v2/keyboard.dart';
import 'package:parkinson_com_v2/keyboardHour.dart';
import 'package:parkinson_com_v2/models/database/reminder.dart';
import 'package:parkinson_com_v2/variables.dart';


class NewReminderPage extends StatefulWidget {
  final int idReminder;
  const NewReminderPage({super.key, this.idReminder = -1});

  @override
  State<NewReminderPage> createState() => _NewReminderPageState();
}

class _NewReminderPageState extends State<NewReminderPage> {
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
    "POPUP OK": false,
  };

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  late Reminder reminder;
  bool alarmRing = false;
  bool everydayAlarm = false;
  bool boolFirstController = true;

  final List<String> days = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"];
  final Map<String, bool> daysAlarm = {
    "monday": false,
    "tuesday": false,
    "wednesday": false,
    "thursday": false,
    "friday": false,
    "saturday": false,
    "sunday": false,
  };

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  // Function to update all values
  void updateAllAlarms(bool value) {
    daysAlarm.updateAll((key, oldValue) => value);
  }

  var battery = Battery();
  int batteryLevel = 0;
  late Timer timer;
  var timeAndDate = DateTime.now();

  Future<void> initialisation() async {

    batteryLevel = await battery.batteryLevel;

    // If it's not a new reminder, we adjust the interface
    if(widget.idReminder != -1){
      reminder = await databaseManager.retrieveReminderFromId(widget.idReminder);
      setState(() {});

      setState(() {
        _firstController.text = reminder.title;
        _secondController.text = reminder.hour;
        alarmRing = reminder.ring;
        List<String> listDays = reminder.days.split(" ");
        int i = 0;
        for(i; i < listDays.length; i += 1){
          daysAlarm[listDays[i]] = true;
        }
        if(listDays.length == 7){
          everydayAlarm = true;
        }
      });
    }
  }

  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Generic popup to display a specific [text] from the JSON and with an "OK" button
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

  @override
  void initState() {
    super.initState();
    // Initialisation of our variables
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      FocusScope.of(context).requestFocus(_focusNode2);
    });

  }

  @override
  void dispose() {
    timer.cancel();
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: ValueListenableBuilder(
            valueListenable: newReminderPageState,
            builder: (context, value, child) {
              if(!value){
                return Column(
                  children: [
                    // First part
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Back Arrow + Date + Time
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.24,
                                child: Column(
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

                                            // Button code
                                            Navigator.pop(
                                              context,
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
                            Container(
                              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, MediaQuery.of(context).size.height / 16, MediaQuery.of(context).size.width * 0.17, 0),
                              child: CustomTitle(
                                text: languagesTextsFile.texts["new_reminder_title"]!,
                                image: 'assets/horloge.png',
                                imageScale: 0.2,
                                backgroundColor: Colors.white,
                                textColor: const Color.fromRGBO(234, 104, 104, 1),
                                containerWidth: MediaQuery.of(context).size.width * 0.5,
                                containerHeight: MediaQuery.of(context).size.height * 0.12,
                                containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.085, 0, MediaQuery.of(context).size.height * 0.03, 0),
                                circleSize: MediaQuery.of(context).size.height * 0.1875,
                                circlePositionedLeft: MediaQuery.of(context).size.height * 0.1 * -1,
                                fontSize: MediaQuery.of(context).size.height > 600 ? 30 : 26,
                                fontWeight: FontWeight.w700,
                                alignment: const Alignment(0, 0.3),
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

                    // Suite
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
                        padding: MediaQuery.of(context).size.height > 600 ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.0) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.027, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // List of dialogs
                            Column(
                              children: [
                                // List
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // First TextField
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          height: MediaQuery.of(context).size.height * 0.14,
                                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context).size.width * 0.02,
                                              0,
                                              MediaQuery.of(context).size.width * 0.02,
                                              0,
                                            ),
                                            child: Center(
                                              child: TextField(
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromRGBO(50, 50, 50, 1),
                                                  overflow: TextOverflow.ellipsis,
                                                ),

                                                controller: _firstController,
                                                readOnly: true,
                                                showCursor: true,
                                                enableInteractiveSelection: true,
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                textAlignVertical: TextAlignVertical.bottom,

                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    iconColor: Colors.white,
                                                    focusColor: Colors.white,
                                                    hoverColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                      ),
                                                    ),
                                                    hintText: languagesTextsFile.texts["new_reminder_hint_name"],
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromRGBO(147, 147, 147, 1),
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: 22,
                                                    )
                                                ),

                                                onTap: () {
                                                  setState(() {
                                                    newReminderPageState.value = true;
                                                    boolFirstController = true;
                                                  });
                                                  print("TOUCHEEEEEEEEEEEEEEE");
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Second TextField
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          height: MediaQuery.of(context).size.height * 0.14,
                                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.025, 0, 0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context).size.width * 0.02,
                                              0,
                                              MediaQuery.of(context).size.width * 0.02,
                                              0,
                                            ),
                                            child: Center(
                                              child: TextField(
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromRGBO(50, 50, 50, 1),
                                                  overflow: TextOverflow.ellipsis,
                                                ),

                                                controller: _secondController,
                                                readOnly: true,
                                                showCursor: true,
                                                enableInteractiveSelection: true,
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                textAlignVertical: TextAlignVertical.bottom,

                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    iconColor: Colors.white,
                                                    focusColor: Colors.white,
                                                    hoverColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                      ),
                                                    ),
                                                    hintText: languagesTextsFile.texts["new_reminder_hint_hour"],
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromRGBO(147, 147, 147, 1),
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: 22,
                                                    )
                                                ),

                                                onTap: () {
                                                  setState(() {
                                                    newReminderPageState.value = true;
                                                    boolFirstController = false;
                                                  });
                                                  print("TOUCHEEEEEEEEEEEEEEE");
                                                },
                                              ),
                                            ),
                                          ),
                                        ),


                                        // Ring
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            height: MediaQuery.of(context).size.height * 0.1,
                                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.03, 0, 0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(234, 104, 104, 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                // Text
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0, 0, 0),
                                                  child: Text(
                                                    languagesTextsFile.texts["new_reminder_ring"]!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),

                                                // Space between
                                                const Expanded(child: SizedBox()),

                                                // Checkbox
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.03, 0),
                                                  child: Transform.scale(
                                                    scale: MediaQuery.of(context).size.height * 0.004,
                                                    child: Checkbox(
                                                      value: alarmRing,
                                                      shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                      checkColor: const Color.fromRGBO(234, 104, 104, 1),
                                                      activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                      onChanged: (value) {
                                                        print('changement');
                                                        print(value);
                                                        setState(() {
                                                          alarmRing = !alarmRing;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),

                                        // Text
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            height: MediaQuery.of(context).size.height * 0.1,
                                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.03, 0, 0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                // Text
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0, 0, 0),
                                                  child: Text(
                                                    languagesTextsFile.texts["new_reminder_repeat"]!,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(234, 104, 104, 1),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),

                                        // Everyday
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            height: MediaQuery.of(context).size.height * 0.1,
                                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.03, 0, 0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(234, 104, 104, 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                // Text
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0, 0, 0),
                                                  child: Text(
                                                    languagesTextsFile.texts["new_reminder_everyday"]!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),

                                                // Space between
                                                const Expanded(child: SizedBox()),

                                                // Checkbox
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.03, 0),
                                                  child: Transform.scale(
                                                    scale: MediaQuery.of(context).size.height * 0.004,
                                                    child: Checkbox(
                                                      value: everydayAlarm,
                                                      shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                      checkColor: const Color.fromRGBO(234, 104, 104, 1),
                                                      activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                      onChanged: (value) {
                                                        print('changement');
                                                        print(value);
                                                        setState(() {
                                                          everydayAlarm = !everydayAlarm;
                                                          updateAllAlarms(everydayAlarm);

                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),

                                        // Days of the week
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.13 * 7,
                                          width: MediaQuery.of(context).size.width * 0.71,
                                          child: ListView.builder(
                                            itemCount: 7,
                                            controller: ScrollController(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                  height: MediaQuery.of(context).size.height * 0.1,
                                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.03, 0, 0),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(234, 104, 104, 1),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      // Text
                                                      Container(
                                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0, 0, 0),
                                                        child: Text(
                                                          "- ${languagesTextsFile.texts[days[index]]!}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),

                                                      // Space between
                                                      const Expanded(child: SizedBox()),

                                                      // Checkbox
                                                      Container(
                                                        margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.03, 0),
                                                        child: Transform.scale(
                                                          scale: MediaQuery.of(context).size.height * 0.004,
                                                          child: Checkbox(
                                                            value: daysAlarm[days[index]],
                                                            shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                            checkColor: const Color.fromRGBO(234, 104, 104, 1),
                                                            activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                            onChanged: (value) {
                                                              setState(() {
                                                                daysAlarm[days[index]] = !daysAlarm[days[index]]!;

                                                                // We check if all the days are checked
                                                                bool allTrue = daysAlarm.values.every((value) => value);

                                                                if(allTrue){
                                                                  everydayAlarm = true;
                                                                }
                                                                else{
                                                                  everydayAlarm = false;
                                                                }

                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              );
                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                // Add Button
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.025),
                                  child: AnimatedScale(
                                    scale: _buttonAnimations["ADD"] == true ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      // Animation management
                                      onTapDown: (_) {
                                        setState(() {
                                          _buttonAnimations["ADD"] = true;
                                        });
                                      },
                                      onTapUp: (_) async {
                                        setState(() {
                                          _buttonAnimations["ADD"] = false;
                                        });
                                        // BUTTON CODE

                                        int i = 0;
                                        String daysString = "";
                                        for(i; i < 7; i += 1){
                                          if(daysAlarm[days[i]]!){
                                            daysString = "$daysString ${days[i]}";
                                          }
                                        }

                                        if(_firstController.text.isEmpty){
                                          _showGenericPopupOK(languagesTextsFile.texts["new_reminder_error_name"]);
                                        }
                                        else if(_secondController.text.isEmpty){
                                          _showGenericPopupOK(languagesTextsFile.texts["new_reminder_error_time_empty"]);
                                        }
                                        else if(daysString.isEmpty){
                                          _showGenericPopupOK(languagesTextsFile.texts["new_reminder_error_days"]);
                                        }
                                        else{
                                          if(widget.idReminder == -1){
                                            // Adding the reminder in the database
                                            await databaseManager.insertReminder(Reminder(
                                              title: _firstController.text,
                                              hour: _secondController.text,
                                              ring: alarmRing,
                                              days: daysString.trim(),
                                            ));
                                            Navigator.pop(context);
                                          }

                                          // Updating the old reminder
                                          else{
                                            await databaseManager.updateReminder(Reminder(
                                              title: _firstController.text,
                                              hour: _secondController.text,
                                              ring: alarmRing,
                                              days: daysString.trim(),
                                              id_reminder: widget.idReminder
                                            ));
                                            Navigator.pop(context);
                                          }

                                        }



                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _buttonAnimations["ADD"] = false;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          color: Color.fromRGBO(61, 192, 200, 1),
                                        ),
                                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.01),
                                        child: Text(
                                          widget.idReminder == -1 ? languagesTextsFile.texts["new_reminder_add"] : languagesTextsFile.texts["new_reminder_modify"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Expanded(child: SizedBox()),

                            // ScrollWidgets
                            Container(
                              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                  Expanded(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.01875,
                                        margin: MediaQuery.of(context).size.height > 600 ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.05) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.035, 0, MediaQuery.of(context).size.height * 0.035),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: const Color.fromRGBO(66, 89, 109, 1),
                                        ),
                                      )),
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
                                          MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.07,
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
                );
              }
              else{
                return Column(
                  children: [
                    // First part
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date + Time
                        Column(
                          children: [
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
                        ),
                        
                        // Space between
                        const Expanded(child: SizedBox()),

                        // Button at the right
                        Container(
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.015),
                          child: AnimatedScale(
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
                        ),
                      ],
                    ),

                    // TextField
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.14,
                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.04, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(MediaQuery.of(context).size.width * 0.045),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.02,
                          0,
                          MediaQuery.of(context).size.width * 0.02,
                          0,
                        ),
                        child: Center(
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(50, 50, 50, 1),
                              overflow: TextOverflow.ellipsis,
                            ),

                            focusNode: boolFirstController ? _focusNode : _focusNode2,
                            controller: boolFirstController ? _firstController : _secondController,
                            readOnly: true,
                            showCursor: true,
                            enableInteractiveSelection: true,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.bottom,

                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                iconColor: Colors.white,
                                focusColor: Colors.white,
                                hoverColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                  ),
                                ),
                                hintText: boolFirstController ? languagesTextsFile.texts["new_reminder_hint_name"] : languagesTextsFile.texts["new_reminder_hint_hour"],
                                hintStyle: const TextStyle(
                                  color: Color.fromRGBO(147, 147, 147, 1),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 22,
                                )
                            ),

                            onTap: () {
                              setState(() {

                              });
                              print("TOUCHEEEEEEEEEEEEEEE");
                            },
                          ),
                        ),
                      ),
                    ),

                    const Expanded(child: SizedBox()),

                    Builder(builder: (context) {
                      if(boolFirstController){
                        return CustomKeyboard(controller: _firstController, textPredictions: isConnected, forcedPredictionsOff: true,);
                      }
                      else{
                        return CustomKeyboardHour(controller: _secondController);
                      }
                    },)


                  ],
                );
              }

            },));
  }
}
