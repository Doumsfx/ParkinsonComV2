// List of dialogs filtered by themes Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/customRemindersTitle.dart';
import 'package:parkinson_com_v2/models/database/reminder.dart';
import 'package:parkinson_com_v2/variables.dart';


class ListContactsPage extends StatefulWidget {
  const ListContactsPage({super.key});

  @override
  State<ListContactsPage> createState() => _ListContactsPageState();
}

class _ListContactsPageState extends State<ListContactsPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "RELAX": false,
    "TOP ARROW": false,
    "BOT ARROW": false,
    "POPUP NO": false,
    "POPUP YES": false,
    "ADD": false,
    "SAVE": false,
  };

  List<Reminder> _listReminders = [];
  String selectedThemeTitle = "";
  late List<bool> _contactsAnimations;
  late List<bool> _primaryContacts;
  late List<bool> _secondaryContacts;
  late List<bool> _deleteButtonsAnimations;
  late List<bool> _modifyButtonsAnimations;
  final ScrollController _scrollController = ScrollController();

  Future<void> initialisation() async {
    _listReminders = await databaseManager.retrieveReminders();
    setState(() {});
    _contactsAnimations = List.filled(_listReminders.length, false);
    _deleteButtonsAnimations = List.filled(_listReminders.length, false);
    _modifyButtonsAnimations = List.filled(_listReminders.length, false);
    _primaryContacts = List.filled(_listReminders.length, false);
    _secondaryContacts = List.filled(_listReminders.length, false);

    // Sorting list with hour
    _listReminders.sort((a, b) => a.hour.compareTo(b.hour));
    setState(() {});

  }

  /// Function to update all values of primaryContacts
  void updateAllPrimaryContacts(bool value) {
    _primaryContacts.fillRange(0, _primaryContacts.length, value);
  }

  /// Function to update all values of secondaryContacts
  void updateAllSecondaryContacts(bool value) {
    _secondaryContacts.fillRange(0, _primaryContacts.length, value);
  }

  String listDaysInGoodLanguage(String str){
    List<String> list = str.split(" ");
    //print(list);
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
    // Initialisation de nos variables
    initialisation();
  }

  @override
  void dispose() {
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

                        // Back Arrow + Texts
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

                                // Contacts
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.02, 0),
                                  child: Center(
                                    child: Text(
                                      languagesTextsFile.texts["contact_list_contacts"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                // Principal + Secondary
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.21,
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.1,
                                        child: Center(
                                          child: Text(
                                            languagesTextsFile.texts["contact_list_principal"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.1,
                                        child: Center(
                                          child: Text(
                                            languagesTextsFile.texts["contact_list_secondary"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )

                              ],
                            )),

                        // Title
                        Container(
                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.060, MediaQuery.of(context).size.height / 16, MediaQuery.of(context).size.width * 0.125, 0),
                          child: CustomRemindersTitle(
                            text: languagesTextsFile.texts["contact_list_title"]!,
                            image: 'assets/enveloppe.png',
                            imageScale: 0.15,
                            backgroundColor: const Color.fromRGBO(12, 178, 255, 1),
                            textColor: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.50,
                            fontWeight: FontWeight.w600,
                            alignment: const Alignment(-0.2, 0.6),
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
                padding: MediaQuery.of(context).size.height > 600 ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.09) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.027, MediaQuery.of(context).size.height * 0.08),
                child: Row(
                  children: [
                    // List of contacts
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _listReminders.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.21,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // First checkbox
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.1,
                                        height: MediaQuery.of(context).size.width * 0.05,
                                        child: Center(
                                          child:
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                            child: Transform.scale(
                                              scale: MediaQuery.of(context).size.width * 0.0025,
                                              child: Checkbox(
                                                value: _primaryContacts[index],
                                                shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                checkColor: Colors.indigo,
                                                activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                onChanged: (value) {
                                                  print('changement');
                                                  print(value);
                                                  setState(() {
                                                    updateAllPrimaryContacts(false);
                                                    _primaryContacts[index] = true;
                                                    _secondaryContacts[index] = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),

                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.1,
                                        height: MediaQuery.of(context).size.width * 0.05,
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                            child: Transform.scale(
                                              scale: MediaQuery.of(context).size.width * 0.0025,
                                              child: Checkbox(
                                                value: _secondaryContacts[index],
                                                shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                checkColor: const Color.fromRGBO(61, 191, 199, 1),
                                                activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                onChanged: (value) {
                                                  print('changement');
                                                  print(value);
                                                  setState(() {
                                                    if(!_primaryContacts[index]){
                                                      _secondaryContacts[index] = !_secondaryContacts[index];
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ),

                                    ],
                                  ),
                                ),

                                // Contact
                                Expanded(
                                  child: AnimatedScale(
                                    scale: _contactsAnimations[index] ? 1.05 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      // Animation management
                                      onTapDown: (_) {
                                        setState(() {
                                          _contactsAnimations[index] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _contactsAnimations[index] = false;
                                        });
                                        // BUTTON CODE
                                        /*
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewReminderPage(idReminder: _listReminders[index].id_reminder),
                                            )
                                        ).then((_) => initialisation());
                                        */
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _contactsAnimations[index] = false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                        height: MediaQuery.of(context).size.width * 0.08,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(60)),
                                          color: Color.fromRGBO(61, 191, 199, 1),
                                        ),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.745,
                                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.015),
                                          child: Align(
                                            alignment: const Alignment(-1, 0),
                                            child: Text(
                                              "${_listReminders[index].title} - ${_listReminders[index].hour} - ${listDaysInGoodLanguage(_listReminders[index].days)}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Delete Contact Buttons
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
                                      // BUTTON CODE
                                      setState(() {
                                        _deleteButtonsAnimations[index] = false;
                                      });
                                      //Popup to confirm the deletion
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Use StatefulBuilder to manage the state inside the dialog
                                            return StatefulBuilder(builder: (context, setState) {
                                              double screenHeight = MediaQuery.of(context).size.height;
                                              double screenWidth = MediaQuery.of(context).size.width;

                                              return Dialog(
                                                backgroundColor: Colors.black87,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0), // Optional padding for aesthetics
                                                  child: Column(
                                                      mainAxisSize: MainAxisSize.min, // Ensures the dialog is as small as needed
                                                      children: [
                                                        SizedBox(height: screenHeight * 0.1),
                                                        //Suppression warning
                                                        Text(
                                                          "${languagesTextsFile.texts["pop_up_delete_reminder"]!}:\n${_listReminders[index].title} ?",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
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
                                                                  await databaseManager.deleteReminder(_listReminders[index].id_reminder);
                                                                  //Refresh ui
                                                                  _listReminders.removeAt(index);
                                                                  _updateParent();
                                                                  //Close the popup
                                                                  Navigator.pop(context); // Close the dialog
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
                                                      ]),
                                                ),
                                              );
                                            });
                                          });
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
                                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.005, MediaQuery.of(context).size.height * 0.02),
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

                                // Modify Contact Buttons
                                AnimatedScale(
                                  scale: _modifyButtonsAnimations[index] ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    onTapDown: (_) {
                                      setState(() {
                                        _modifyButtonsAnimations[index] = true;
                                      });
                                    },
                                    onTapUp: (_) {
                                      // BUTTON CODE
                                      setState(() {
                                        _modifyButtonsAnimations[index] = false;
                                      });
                                      //Popup to confirm the deletion
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Use StatefulBuilder to manage the state inside the dialog
                                            return StatefulBuilder(builder: (context, setState) {
                                              double screenHeight = MediaQuery.of(context).size.height;
                                              double screenWidth = MediaQuery.of(context).size.width;

                                              return Dialog(
                                                backgroundColor: Colors.black87,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0), // Optional padding for aesthetics
                                                  child: Column(
                                                      mainAxisSize: MainAxisSize.min, // Ensures the dialog is as small as needed
                                                      children: [
                                                        SizedBox(height: screenHeight * 0.1),
                                                        //Suppression warning
                                                        Text(
                                                          "${languagesTextsFile.texts["pop_up_delete_reminder"]!}:\n${_listReminders[index].title} ?",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
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
                                                                  await databaseManager.deleteReminder(_listReminders[index].id_reminder);
                                                                  //Refresh ui
                                                                  _listReminders.removeAt(index);
                                                                  _updateParent();
                                                                  //Close the popup
                                                                  Navigator.pop(context); // Close the dialog
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
                                                      ]),
                                                ),
                                              );
                                            });
                                          });
                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _modifyButtonsAnimations[index] = false;
                                      });
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.width * 0.062,
                                      width: MediaQuery.of(context).size.width * 0.062,
                                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.001),
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                      color: Colors.transparent,
                                      child: Image.asset(
                                        "assets/edit.png",
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
                                margin: MediaQuery.of(context).size.height > 600 ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.014) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.011),
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

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Add button
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

                      },
                      onTapCancel: () {
                        setState(() {
                          _buttonAnimations["ADD"] = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height:MediaQuery.of(context).size.height * 0.1,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color.fromRGBO(61, 192, 200, 1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                        child: Center(
                          child: AutoSizeText(
                            languagesTextsFile.texts["contact_list_add"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 5,
                            maxFontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Save button
                Container(
                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.025),
                  child: AnimatedScale(
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

                      },
                      onTapCancel: () {
                        setState(() {
                          _buttonAnimations["SAVE"] = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color.fromRGBO(61, 192, 200, 1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                        child: Center(
                          child: AutoSizeText(
                            languagesTextsFile.texts["contact_list_save"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 5,
                            maxFontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        ));
  }
}
