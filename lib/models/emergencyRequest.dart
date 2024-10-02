// Emergency Requester
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/variables.dart';

import 'database/contact.dart';

class EmergencyRequest {
  final Map<String, bool> _buttonAnimations = {
    "POPUP OK": false,
    "POPUP YES": false,
    "POPUP NO": false,
  };

  void sendEmergencyRequest(BuildContext contextPage) async {
    if ((await databaseManager.countContacts()) > 0) {
      Contact primaryContact = (await databaseManager.retrieveContactFromPriority(1))[0];
      List<Contact> secondaryContacts = (await databaseManager.retrieveContactFromPriority(2));
      secondaryContacts.sort((a, b) => a.last_name.compareTo(b.last_name));

      showDialog(
          context: contextPage,
          builder: (BuildContext context) {
            double screenHeight = MediaQuery.of(context).size.height;
            double screenWidth = MediaQuery.of(context).size.width;

            Timer? _timer;
            int _start = 90; // Countdown starts from 90 seconds

            return StatefulBuilder(builder: (context, setState) {
              // Timer logic
              void startTimer() {
                const oneSec = Duration(seconds: 1);
                _timer = Timer.periodic(oneSec, (Timer timer) {
                  if (_start == 0) {
                    setState(() {
                      timer.cancel();
                    });
                    Navigator.of(context).pop();
                    _sendEmergencyRequestPrimary(primaryContact, contextPage, context, secondaryContacts);


                  } else {
                    if (context.mounted) {
                      setState(() {
                        _start--;
                      });
                    } else {
                      timer.cancel();
                    }
                  }
                });
              }

              // Start the timer when the dialog is built
              if (_timer == null) {
                startTimer();
              }

              // Dispose of the timer when the dialog is closed
              void stopTimer() {
                if (_timer != null) {
                  _timer!.cancel();
                }
              }

              return Dialog(
                backgroundColor: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.13),
                      Text(
                        "${languagesTextsFile.texts["emergency_ask_1"]!}\n${primaryContact.last_name} ${primaryContact.first_name}\n${languagesTextsFile.texts["emergency_ask_2"]!}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.08),
                      //Timer
                      Text(
                        "${languagesTextsFile.texts["emergency_timer_1"]!} ${formatDuration(_start)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.08),
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
                                stopTimer();
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
                                Navigator.of(context).pop();
                                setState(() {
                                  _buttonAnimations["POPUP YES"] = false;
                                });
                                stopTimer();

                                _sendEmergencyRequestPrimary(primaryContact, contextPage, context, secondaryContacts);
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
    } else {
      //No contact
      _showGenericPopupOK(languagesTextsFile.texts["pop_up_contact_empty"]!, contextPage);
    }
  }

  ///Generic popup to display a specific [text] from the JSON and with an "OK" button
  void _showGenericPopupOK(String text, BuildContext context) {
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

  ///
  Future<void> _sendEmergencyRequestPrimary(Contact primaryContact, BuildContext contextPage, BuildContext context, List<Contact> secondaryContacts ) async {
    int result = 0;
    //If the primary contact has an email
    if (primaryContact.email != null) {
      String content =
          "${languagesTextsFile.texts["mail_body_1"]!} TOCHANGE{account.name}, TOCHANGE{account.email}\n\n${languagesTextsFile.texts["emergency_message"]!}\n\n${languagesTextsFile.texts["mail_body_2"]!} TOCHANGE{account.email} ${languagesTextsFile.texts["mail_body_3"]!}";
      result = await emailHandler.sendMessage(primaryContact.email as String, content);
    }
    //Or if the primary contact has a phone number
    else if (primaryContact.phone != null) {
      result = await smsHandler.checkPermissionAndSendSMS(languagesTextsFile.texts["emergency_message"]!, [primaryContact.phone as String]);
    }

    //Check if the context from where we clicked on the emergency button still exist
    if (contextPage.mounted) {
      //Error encountered
      if (result < 0) {
        _showGenericPopupOK(languagesTextsFile.texts["popup_message_send_fail"]!, contextPage);
      }
      //Ask for each of the secondary contacts
      else {
        _sendEmergencyRequestSecondary(secondaryContacts, contextPage);
      }
    }
  }


  /// Send emergency request to the contacts from a [contactsList]
  void _sendEmergencyRequestSecondary(List<Contact> contactsList, BuildContext contextPage) {
    bool forceStop = false;

    /// Popup
    Future<bool> _showEmergencyRequestDialog(Contact contact, BuildContext contextPage) async {
      return await showDialog(
        context: contextPage,
        barrierDismissible: false, // Prevent dismissal by tapping outside
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;

          Timer? _timer;
          int _start = 90; // Countdown starts from 90 seconds

          return StatefulBuilder(
            builder: (context, setState) {
              // Timer logic
              void startTimer() {
                const oneSec = Duration(seconds: 1);
                _timer = Timer.periodic(oneSec, (Timer timer) {
                  if (_start == 0) {
                    setState(() {
                      timer.cancel();
                      //Automatically send message to contact
                      Navigator.of(context).pop(true);
                    });
                  } else {
                    if (context.mounted) {
                      setState(() {
                        _start--;
                      });
                    }
                  }
                });
              }

              // Start the timer when the dialog is built
              if (_timer == null) {
                startTimer();
              }

              // Dispose of the timer when the dialog is closed
              void stopTimer() {
                if (_timer != null) {
                  _timer!.cancel();
                }
              }

              return Dialog(
                backgroundColor: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.13),
                      Text(
                        "${languagesTextsFile.texts["emergency_ask_1.2"]!}\n${contact.last_name} ${contact.first_name}\n${languagesTextsFile.texts["emergency_ask_2"]!}", // Display contact info
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.08),
                      // Countdown timer
                      Text(
                        "${languagesTextsFile.texts["emergency_timer_1"]!} ${formatDuration(_start)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.08),
                      // Buttons for Yes/No
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancel button
                          AnimatedScale(
                            scale: _buttonAnimations["POPUP NO"]! ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceOut,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _buttonAnimations["POPUP NO"] = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _buttonAnimations["POPUP NO"] = false;
                                });
                                stopTimer(); // Stop the timer
                                Navigator.pop(context, false); // Return false for NO
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
                          SizedBox(width: screenWidth * 0.15),
                          // Yes button
                          AnimatedScale(
                            scale: _buttonAnimations["POPUP YES"]! ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceOut,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _buttonAnimations["POPUP YES"] = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _buttonAnimations["POPUP YES"] = false;
                                });
                                stopTimer(); // Stop the timer
                                Navigator.of(context).pop(true); // Return true for YES
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
            },
          );
        },
      );
    }

    ///Send message to a contact
    Future<void> _sendMessageToContact(Contact contact, BuildContext contextPage) async {
      int result = 0;

      // Send message via email or SMS
      if (contact.email != null) {
        //todo update info sender
        String content =
            "${languagesTextsFile.texts["mail_body_1"]!} TOCHANGE{account.name}, TOCHANGE{account.email}\n\n${languagesTextsFile.texts["emergency_message"]!}\n\n${languagesTextsFile.texts["mail_body_2"]!} TOCHANGE{account.email} ${languagesTextsFile.texts["mail_body_3"]!}";
        result = await emailHandler.sendMessage(contact.email as String, content);
      } else if (contact.phone != null) {
        result = await smsHandler.checkPermissionAndSendSMS(languagesTextsFile.texts["emergency_message"]!, [contact.phone as String]);
      }

      // Error -> show a failure message and stop
      if (result < 0) {
        forceStop = true;
        if (contextPage.mounted) {
          _showGenericPopupOK(languagesTextsFile.texts["popup_message_send_fail"]!, contextPage);
        }
      }
    }

    ///Loop for the emergency message for each contacts of the list
    Future<void> _handleContactRequests(List<Contact> contactsList, BuildContext contextPage) async {
      while (contactsList.isNotEmpty && !forceStop) {
        if (contextPage.mounted) {
          Contact currentContact = contactsList.first;

          // Show dialog and wait for the user's decision (Yes/No)
          bool? userChoice = await _showEmergencyRequestDialog(currentContact, contextPage);

          if (userChoice == true && !forceStop) {
            // Send message to the current contact
            await _sendMessageToContact(currentContact, contextPage);

            // No error -> continue with the next contact
            if (!forceStop) {
              contactsList.removeAt(0);
            }
          } else {
            // User pressed NO or error encountered -> stop everything
            forceStop = true;
          }
        } else {
          //Page no more displayed -> stop the popups
          forceStop = true;
        }
      }
    }

    // Start the emergency request process
    if (contactsList.isNotEmpty) {
      _handleContactRequests(contactsList, contextPage);
    }
  }

  ///Convert a [totalSeconds] to "mm:ss" format
  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}
