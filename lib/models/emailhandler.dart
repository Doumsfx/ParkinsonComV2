// E-mail Handler Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
    //todo check si cette fonction marche

    TextEditingController controller = TextEditingController();

    int newCode = Random(DateTime.now().millisecondsSinceEpoch).nextInt(100000);
    int resultSendMail = await sendMessage(userMail, "Code de vérification : $newCode");

    if (resultSendMail >= 0) {
      bool resultCode = await showDialog(context: context, barrierDismissible: false, builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Column(
              children: [
                const Text("Entrez votre code :"), //todo
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                ),
                const SizedBox(height: 10),
                TextButton(onPressed: () {
                  if(newCode.toString() == controller.text) {
                    //Right code
                    Navigator.of(context).pop(true);
                  }
                  else {
                    //Wrong code
                    Navigator.of(context).pop(false);
                  }
                }, child: const Text("Vérifier")) //todo
              ],
            ),
          );
        },);
      },);
      return resultCode;
    }
    else {
      return false;
    }
  }


}