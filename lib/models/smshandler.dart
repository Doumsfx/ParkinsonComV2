// SMS Handler Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2


import 'package:flutter/services.dart';
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

  ///Check if a SIM card is present or not using MethodChannel.
  Future<bool> checkSim() async {
    const platform = MethodChannel('sim_info_channel');
    var permission = await Permission.phone.status;
    if (permission.isDenied) {
      permission = await Permission.phone.request();
    }
    if(permission.isGranted) {
      try {
        final bool simPresent = await platform.invokeMethod('isSimPresent');
        if (simPresent) {
          print("SIM présente");
          return true;
        } else {
          print("SIM absente");
          return false;
        }
      } on PlatformException catch (e) {
        print("Failed to get SIM info: '${e.message}'");
        return false;
      }
    }
    return false;
  }


}


