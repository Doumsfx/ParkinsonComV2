// E-mail Handler Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:parkinson_com_v2/keyboardPhoneNumber.dart';
import 'package:parkinson_com_v2/models/popupshandler.dart';

import '../variables.dart';

class EmailHandler {
  late SmtpServer _smtpServer;

  EmailHandler() {
    _smtpServer = SmtpServer("mail.infomaniak.com", username: dotenv.env["EMAIL_USERNAME"], password: dotenv.env["EMAIL_PASSWORD"]);
  }

  ///Send an e-mail to the [recipient] with a specific [content].
  ///Return 0 if it is a success, -1 if there is an error with the e-mail, -2 if there is an error with the SMTP connection.
  Future<int> sendMessage(String recipient, String content) async {
    try {
      //Create the message
      final message = Message()
        ..from = const Address("recherche@parkinsoncom.eu","ParkinsonCom")
        ..recipients.add(recipient)
        ..subject = languagesTextsFile.texts["mail_title"]!
        ..text = content
      ;
      //Send the message
      try {
        final sendReport = await send(message, _smtpServer, timeout: const Duration(seconds: 10));
        print('Message sent: $sendReport');
        return 1;
      } on MailerException catch (e) {
        print('Message not sent. : $e');
        return -1;
      }
    } on SocketException catch (e) {
      print('SMTP request failed, check your network restrictions : $e');
      return -2;
    }
  }

  ///Send a code to the [userMail] and display a popup asking for the verification code.
  ///Return true if the code is right, and false if it is wrong or if the e-mail couldn't be sent.
  Future<bool> checkCode(BuildContext context, String userMail) async {
    TextEditingController controller = TextEditingController();

    //Popup displayed when trying to send the e-mail
    showDialog(
        context: context,
        barrierDismissible: false,
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
                    SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.3),
                    Text(
                      languagesTextsFile.texts["sending_code_mail"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.3),
                  ],
                ),
              ),
            );
          });
        });

    //Generate and send the code
    int newCode = Random(DateTime.now().millisecondsSinceEpoch).nextInt(100000);
    String contentMail = "${languagesTextsFile.texts["mail_code_check"]} $newCode";
    int resultSendMail = await sendMessage(userMail, contentMail);
    //Close the previous popup
    Navigator.of(context).pop();

    //If the e-mail sending is successful
    if (resultSendMail >= 0) {
      bool resultCode = await showDialog(context: context, barrierDismissible: false, builder: (context) {
        Map<String, bool> _buttonAnimations = {
          "POPUP OK": false,
          "POPUP CANCEL": false,
        };

        return StatefulBuilder(builder: (context, setState) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;
          return ValueListenableBuilder(
            valueListenable: verificationPopUpState,
            builder: (context, value, child) {
              if(!value){
                return Dialog(
                  backgroundColor: Colors.black87,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.06),
                        Text(
                          (languagesTextsFile.texts["input_code_mail"] as String).replaceAll("...", userMail),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        //TextField for code input
                        SizedBox(
                          width: screenWidth*0.35,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(50, 50, 50, 1),
                              overflow: TextOverflow.ellipsis,
                            ),

                            //focusNode: _focusNode,
                            controller: controller,
                            readOnly: true,
                            showCursor: true,
                            enableInteractiveSelection: true,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,

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
                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                  ),
                                ),
                                hintText: languagesTextsFile.texts["hint_input_code"],
                                hintStyle: const TextStyle(
                                  color: Color.fromRGBO(147, 147, 147, 1),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19,
                                )
                            ),

                            onTap: () {
                              setState(() {
                                verificationPopUpState.value = true;
                              });
                              print("TOUCHEEEEEEEEEEEEEEE");
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        //Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Button to cancel
                            AnimatedScale(
                              scale: _buttonAnimations["POPUP CANCEL"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                // Animation management
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["POPUP CANCEL"] = true;
                                  });
                                },
                                onTapUp: (_) async {
                                  setState(() {
                                    _buttonAnimations["POPUP CANCEL"] = false;
                                  });
                                  //BUTTON CODE
                                  Navigator.of(context).pop(false);
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _buttonAnimations["POPUP CANCEL"] = false;
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(60)),
                                    color: Colors.red,
                                  ),
                                  padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 8.0, screenWidth * 0.1, 8.0),
                                  child: Text(
                                    languagesTextsFile.texts["pop_up_cancel"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenHeight*0.1),
                            //Button Check code
                            AnimatedScale(
                              scale: _buttonAnimations["POPUP OK"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                // Animation management
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["POPUP OK"] = true;
                                  });
                                },
                                onTapUp: (_) async {
                                  setState(() {
                                    _buttonAnimations["POPUP OK"] = false;
                                  });
                                  //BUTTON CODE
                                  if(newCode.toString() == controller.text) {
                                    //Right code
                                    Navigator.of(context).pop(true);
                                  }
                                  else {
                                    //Wrong code
                                    Navigator.of(context).pop(false);
                                    Popups.showPopupOk(context, text: languagesTextsFile.texts["invalid_code"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                                  }
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
                                    languagesTextsFile.texts["pop_up_check"],
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
              }
              else{
                return Stack(children: [

                  Dialog(
                    backgroundColor: Colors.black87,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.08),
                          //TextField for code input
                          SizedBox(
                            width: screenWidth*0.35,
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color.fromRGBO(50, 50, 50, 1),
                                overflow: TextOverflow.ellipsis,
                              ),

                              //focusNode: _focusNode,
                              controller: controller,
                              readOnly: true,
                              showCursor: true,
                              enableInteractiveSelection: true,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.center,

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
                                      Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                    ),
                                  ),
                                  hintText: languagesTextsFile.texts["hint_input_code"],
                                  hintStyle: const TextStyle(
                                    color: Color.fromRGBO(147, 147, 147, 1),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19,
                                  )
                              ),

                              onTap: () {
                                setState(() {

                                });
                                print("TOUCHEEEEEEEEEEEEEEE");
                              },
                            ),
                          ),
                          const Expanded(child: SizedBox())
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,

                      child: Builder(builder: (context) {
                    return CustomKeyboardPhoneNumber(controller: controller,);
                  },))

                ],
                );
              }
            },
          );
        });
      },).then((value) {
        //Return the bool, or false by default if the user succeed in closing the dialog without clicking on any buttons
        return value ?? false;
      },);
      return resultCode;
    }
    //E-mail sending failed
    else {
      return await Popups.showPopupOk(context, text: languagesTextsFile.texts["error_sending_mail"], textOk: languagesTextsFile.texts["pop_up_ok"], dismissible: false,
        functionOk: (p0) {
        Navigator.of(p0).pop(false);
      },).then((value) {
        //Return the bool, or false by default if the user succeed in closing the dialog without clicking on any buttons
        return value ?? false;
      },);
    }
  }


}