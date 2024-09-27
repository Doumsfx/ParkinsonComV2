


import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';


class SmsHandler {

  SmsHandler();

  ///Send a SMS to a list of [recipients] if the user gives the permission to send sms.
  ///Return 1 if the message is sent successfully, -1 if the sms encounters an error, -2 if the permission is denied.
  Future<int> checkPermissionAndSendSMS(String message, List<String> recipients) async {
    var permission = await Permission.sms.status;

    if (permission.isDenied) {
      // Request permission if not already granted
      permission = await Permission.sms.request();
    }

    if (permission.isGranted) {
      try {
        String result = await sendSMS(
          message: message,
          recipients: recipients,
          sendDirect: true, //false : open the SMS App
        );
        print("result : $result");
        if(result == "SMS Sent!") return 1;
        else {
          return -1;
        }
      } catch (error) {
        print(error);
        return -1;
      }
    } else {
      print("SMS permission denied");
      return -2;
    }
  }


}


