// Internet Alert Popup
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'variables.dart';

class InternetAlert {
  //This key is used to know when the popup is already displayed or not, because we only close the popup when it is displayed
  //the popup can be closed by several causes (button to close it, back button, click outside of the popup, get internet back)
  final GlobalKey _alertKey = GlobalKey();
  late StreamSubscription<InternetStatus> _listener;
  bool buttonAnimation = false;

  void startCheckInternet(BuildContext context) {
    //Instance to check internet (try to connect to https://www.google.com/, can be changed to other website(s) )
    InternetConnection connection = InternetConnection.createInstance(
      useDefaultOptions: false, //Remove the check of the default websites of the package
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse('https://www.google.com/'), timeout: const Duration(seconds: 5)),
        //Can add more website to check here
      ],
    );
    //Listener to detect changes and send the alert
    _listener = connection.onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          // The internet is now connected
          isConnected.value = true;
          _closeAlert(context);
          break;
        case InternetStatus.disconnected:
          // The internet is now disconnected
          isConnected.value = false;
          //We don't replace this popup with the Popups Class because of the global key that it uses.
          _showNoInternetAlert(context);
          break;
      }
    });
  }

  void _showNoInternetAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              key: _alertKey,
              backgroundColor: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.13, width: screenWidth * 0.95),
                    Text(
                      languagesTextsFile.texts["pop_up_internet"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    //Button to close the popup
                    AnimatedScale(
                      scale: buttonAnimation ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceOut,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        // Animation management
                        onTapDown: (_) {
                          setState(() {
                            buttonAnimation = true;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            buttonAnimation = false;
                          });
                          // BUTTON CODE
                          _closeAlert(context);
                        },
                        onTapCancel: () {
                          setState(() {
                            buttonAnimation = false;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: Colors.lightGreen,
                          ),
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 8.0, screenWidth * 0.1, 8.0),
                          child: Text(
                            languagesTextsFile.texts["pop_up_continue_without_internet"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _closeAlert(BuildContext context) {
    if (_alertKey.currentContext != null) {
      Navigator.pop(context);
    }
  }

  void dispose() {
    _listener.cancel();
  }
}
