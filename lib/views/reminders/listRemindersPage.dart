// List of reminders Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/database/reminder.dart';
import 'package:parkinson_com_v2/views/reminders/newReminderPage.dart';
import 'package:parkinson_com_v2/models/variables.dart';

import '../../models/popupshandler.dart';


class ListRemindersPage extends StatefulWidget {
  const ListRemindersPage({super.key});

  @override
  State<ListRemindersPage> createState() => _ListRemindersPageState();
}

class _ListRemindersPageState extends State<ListRemindersPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "NEW REMINDER": false,
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

  List<Reminder> _listReminders = [];
  late List<bool> _remindersAnimations;
  late List<bool> _deleteButtonsAnimations;
  final ScrollController _scrollController = ScrollController();

  var battery = Battery();
  int batteryLevel = 0;
  late Timer timer;
  var timeAndDate = DateTime.now();

  /// Function to initialise our variables
  Future<void> initialisation() async {

    batteryLevel = await battery.batteryLevel;

    // We retrieve all the reminders from the database
    _listReminders = await databaseManager.retrieveReminders();
    setState(() {});
    _remindersAnimations = List.filled(_listReminders.length, false);
    _deleteButtonsAnimations = List.filled(_listReminders.length, false);

    // Sorting list with hour
    _listReminders.sort((a, b) => a.hour.compareTo(b.hour));
    setState(() {});

    }

  /// Function to format a [number] into a two format digit, for example '2' becomes '02'
  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Function to retrieve the list of days in the good language
  String listDaysInGoodLanguage(String str){
    List<String> list = str.split(" ");
    String newList = "";
    String day = "";
    int i = 0;
    for(i; i < list.length; i += 1){
      day = languagesTextsFile.texts[list[i]];
      newList += " ${day.substring(0, 3)}";
    }

    return newList;
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

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Used to refresh the UI from the StatefulBuilder
  void _updateParent() {
    setState(() {});
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
                                  child: SizedBox(
                                    height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.07,
                                    child: AutoSizeText(
                                      "${formatWithTwoDigits(timeAndDate.day)}/${formatWithTwoDigits(timeAndDate.month)}/${timeAndDate.year}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 50,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 5,
                                      maxFontSize: 50,
                                    ),
                                  ),
                                ),

                                // Time
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, 0, 0),
                                  child: SizedBox(
                                    height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.07,
                                    child: AutoSizeText(
                                      "${formatWithTwoDigits(timeAndDate.hour)}:${formatWithTwoDigits(timeAndDate.minute)}:${formatWithTwoDigits(timeAndDate.second)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 50,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 5,
                                      maxFontSize: 50,
                                    ),
                                  ),
                                ),
                              ],
                            )),

                        // Title
                        Container(
                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.015, MediaQuery.of(context).size.height / 16, MediaQuery.of(context).size.width * 0.04, 0),
                          child: CustomTitle(
                            text: languagesTextsFile.texts["reminders_title"]!,
                            image: 'assets/horloge.png',
                            imageScale: 0.2,
                            backgroundColor: Colors.white,
                            textColor: const Color.fromRGBO(234, 104, 104, 1),
                            containerWidth: MediaQuery.of(context).size.width * 0.63,
                            containerHeight: MediaQuery.of(context).size.height * 0.12,
                            containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.085, 0, MediaQuery.of(context).size.height * 0.03, 0),
                            circleSize: MediaQuery.of(context).size.height * 0.1875,
                            circlePositionedLeft: MediaQuery.of(context).size.height * 0.1 * -1,
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            alignment: const Alignment(0, 0.3),
                          ),
                        ),
                      ],
                    ),

                    // Button
                    AnimatedScale(
                      scale: _buttonAnimations["NEW REMINDER"] == true ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceOut,
                      child: GestureDetector(
                        // Animation management
                        onTapDown: (_) {
                          setState(() {
                            _buttonAnimations["NEW REMINDER"] = true;
                          });
                        },
                        onTapUp: (_) async {
                          setState(() {
                            _buttonAnimations["NEW REMINDER"] = false;
                          });
                          // Button Code
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewReminderPage(),
                            )
                          ).then((_) => initialisation());

                        },
                        onTapCancel: () {
                          setState(() {
                            _buttonAnimations["NEW REMINDER"] = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025, MediaQuery.of(context).size.height * 0.025, 0, MediaQuery.of(context).size.height * 0.03),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.08,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: Color.fromRGBO(234, 104, 104, 1),
                          ),
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.015),
                          child: Align(
                            alignment: const Alignment(-1, 0),
                            child: AutoSizeText(
                              languagesTextsFile.texts["reminders_new"]!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.045 : MediaQuery.of(context).size.height * 0.05,
                              ),
                              maxLines: 1,
                              minFontSize: 5,
                              maxFontSize: 50,
                            ),
                          ),
                        ),
                      ),
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

            // List of reminders
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
                padding: isThisDeviceATablet ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.11) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.027, MediaQuery.of(context).size.height * 0.11),
                child: Row(
                  children: [
                    // List of reminders
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _listReminders.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                // Reminders
                                AnimatedScale(
                                  scale: _remindersAnimations[index] ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTapDown: (_) {
                                      setState(() {
                                        _remindersAnimations[index] = true;
                                      });
                                    },
                                    onTapUp: (_) {
                                      setState(() {
                                        _remindersAnimations[index] = false;
                                      });
                                      // Button Code
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NewReminderPage(idReminder: _listReminders[index].id_reminder),
                                          )
                                      ).then((_) => initialisation());

                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _remindersAnimations[index] = false;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                      width: MediaQuery.of(context).size.width * 0.81,
                                      height: MediaQuery.of(context).size.width * 0.08,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(60)),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.745,
                                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.03, MediaQuery.of(context).size.width * 0.015),
                                        child: Align(
                                          alignment: const Alignment(-1, 0),
                                          child: AutoSizeText(
                                            "${_listReminders[index].title} - ${_listReminders[index].hour} - ${listDaysInGoodLanguage(_listReminders[index].days)}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.045 : MediaQuery.of(context).size.height * 0.05,
                                            ),
                                            maxLines: 1,
                                            minFontSize: 5,
                                            maxFontSize: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Delete Reminders Buttons
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
                                      // Button Code
                                      setState(() {
                                        _deleteButtonsAnimations[index] = false;
                                      });
                                      //Popup to confirm the deletion
                                      Popups.showPopupYesOrNo(context, text: "${languagesTextsFile.texts["pop_up_delete_reminder"]!}:\n${_listReminders[index].title} ?", textYes: languagesTextsFile.texts["pop_up_yes"]!, textNo: languagesTextsFile.texts["pop_up_no"]!,
                                          functionYes: (p0) async {
                                            await databaseManager.deleteReminder(_listReminders[index].id_reminder);
                                            //Refresh ui
                                            _listReminders.removeAt(index);
                                            _updateParent();
                                            //Close the popup
                                            Navigator.pop(context);
                                      }, functionNo: Popups.functionToQuit);

                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _deleteButtonsAnimations[index] = false;
                                      });
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.width * 0.062,
                                      width: MediaQuery.of(context).size.width * 0.062,
                                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0, 0, MediaQuery.of(context).size.height * 0.023),
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(244, 66, 56, 1),
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
                                margin: isThisDeviceATablet ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.014) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.011),
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

                          // Bot Arrow
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
                                  MediaQuery.of(context).size.height * 0.02,
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
        ));
  }
}
