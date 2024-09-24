// E-mail Handler Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailHandler {
  late final SmtpServer smtpServer;

  EmailHandler() {
    smtpServer = SmtpServer("mail.infomaniak.com", username: dotenv.env["USERNAME"], password: dotenv.env["PASSWORD"]);
  }

  Future<void> sendMessage(String recipient ,String content) async {
    try {
      final message = Message()
        ..from = const Address("recherche@parkinsoncom.eu","ParkinsonCom")
        ..recipients.add(recipient)
        ..subject = 'Mail de ParkinsonCom v2'
        ..text = content;

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    } on SocketException catch (e) {
      print('SMTP request failed, check your network restrictions : $e');
    }
  }

}