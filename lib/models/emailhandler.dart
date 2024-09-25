// E-mail Handler Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
        ..subject = 'Mail de ParkinsonCom v2'
        ..text = content;
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

}