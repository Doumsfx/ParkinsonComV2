// Internet Alert Popup
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../variables.dart';


class InternetAlert {
  //This key is used to know when the popup is already displayed or not, because we only close the popup when it is displayed
  //the popup can be closed by several causes (button to close it, back button, click outside of the popup, get internet back)
  GlobalKey _alertKey = GlobalKey();
  late StreamSubscription<InternetStatus> _listener;


  void startCheckInternet(BuildContext context) {
    _listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
          switch (status) {
            case InternetStatus.connected:
            // The internet is now connected
              isConnected.value = true;
              _closeAlert(context);
              break;
            case InternetStatus.disconnected:
            // The internet is now disconnected
              isConnected.value = false;
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
                  Text(langFR ?
                    "Vous n'avez pas de connexion internet.\nCela peut désactiver certaines fonctionnalités\n(autocomplétion, e-mail, etc).\nMerci de réactiver internet\nsi vous souhaitez utiliser ces fonctionnalités."
                    : "U heeft geen internetverbinding.\nDit kan sommige functies uitschakelen\n(automatisch aanvullen, e-mail, enz.).\nReactiveer internet\n als u deze functies wilt gebruiken.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize:20,
                        fontWeight:
                        FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                  //Button to close the popup
                  GestureDetector(
                    onTapUp: (_) {
                      _closeAlert(context);
                    },
                    child: Container(
                      decoration:
                      const BoxDecoration(
                        borderRadius: BorderRadius
                            .all(Radius
                            .circular(
                            60)),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets
                          .fromLTRB(
                          screenWidth *
                              0.1,
                          8.0,
                          screenWidth *
                              0.1,
                          8.0),
                      child: Text(
                        langFR
                            ? "Continuer sans internet"
                            : "Ga verder zonder internet",
                        style: const TextStyle(
                          color: Colors
                              .white,
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize:20,
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
  }

  void _closeAlert(BuildContext context) {
    if(_alertKey.currentContext != null) {
      Navigator.pop(context);
    }
  }

  void dispose() {
    _listener.cancel();
  }
}
