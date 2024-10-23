// SMS Receiver
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/popupsHandler.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:telephony/telephony.dart';
import 'database/contact.dart';
import 'database/sms.dart';


class SmsReceiver {
  final Telephony _telephony = Telephony.instance; // Instance to detect when a SMS is received
  VoidCallback? onReceiveSMS; // Callback (-> update a state) executed when SMS is received
  bool isAlreadyActive = false;

  //Map<int,int> unreadMessages = {}; // Map  {id_contact : number_of_unread_sms}

  SmsReceiver({this.onReceiveSMS});

  void setCallBack(VoidCallback functionCallback) {
    onReceiveSMS = functionCallback;
  }

  /// Return the number of SMS from the unreadMessages map
  int countNewSMS() {
    int count = 0;
    for(var number in unreadMessages.keys) {
      count += (unreadMessages[number]! as int);
    }
    return count;
  }

  /// Return the number of SMS from unreadMessages map for a specific contact using its [id_contact]
  int countSmsForPhone(int id_contact) {
    if(unreadMessages["$id_contact"] != null) {
      return unreadMessages["$id_contact"]!;
    }
    else {
      return 0;
    }
  }

  Future<void> initReceiver() async {
    // Ask for permissions
    bool? result = await _telephony.requestSmsPermissions;
    if(result != null && result == true) {
      // Start to listen for incoming SMS
      _telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) async {

          // Update the map of the new SMS
          if (message.address != null) {

            // Message addresses are in E.164 Standard : + country_code phone_number
            // Parse the phone number
            PhoneNumber phoneNumber = PhoneNumber.parse(message.address!);
            // Remove the "+ country_code" of the phone number
            String phoneNumberClean = (message.address!).replaceAll("+${phoneNumber.countryCode}", "");

            // Retrieve the contact associate to the phone number
            Contact? contact = await databaseManager.retrieveContactFromPhone(phoneNumberClean);

            if(contact != null) {

              // Increment by 1 in the map for the counter of unread messages
              if(unreadMessages.keys.contains("${contact.id_contact}") && unreadMessages["${contact.id_contact}"] != null ) {
                (unreadMessages["${contact.id_contact}"] = unreadMessages["${contact.id_contact}"] !+ 1);
              }
              else {
                unreadMessages.addAll({"${contact.id_contact}" : 1});
              }

              // Save the unread messages as JSON into the shared preferences
              await preferences?.setString("unreadMessages", jsonEncode(unreadMessages));

              // Format the timestamp of the sms
              DateTime receptionDate = DateTime.fromMillisecondsSinceEpoch(message.date!);
              String receptionHour = "${formatWithTwoDigits(receptionDate.hour)}:${formatWithTwoDigits(receptionDate.minute)}:${formatWithTwoDigits(receptionDate.second)}";

              // Insert the sms into the database
              await databaseManager.insertSms(Sms(
                id_contact: contact.id_contact,
                content: message.body!,
                isReceived: true,
                timeSms: receptionHour,
              ));

              // We only keep the 50 last SMS exchanged with each contact
              List<Sms> listSms = await databaseManager.retrieveSmsFromContact(contact.id_contact);
              if(listSms.length > 50) {
                // Loop for removing multiple SMS (ex : can happen when sending messages to ourself)
                for(int i = 0; i < (listSms.length - 50); i++) {
                  // Remove the older SMS
                  await databaseManager.deleteSms(listSms[i].id_sms);
                }
              }

              // Call back to refresh the UI
              onReceiveSMS!();
            }
          }

        },
        listenInBackground: false,
      );
      isAlreadyActive = true;
    }
  }

  /// Ask for the SMS Permissions listed in the manifest.
  Future<bool> askPermissions(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.sms.status;

    if (!permissionStatus.isGranted) {
      return Popups.showPopupOk(context, text: languagesTextsFile.texts["ask_permissions_sms"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: (p0) async {
        PermissionStatus permissionStatus = await Permission.sms.request();
        if(permissionStatus.isGranted) {
          Navigator.of(p0).pop(true);
        }
        else {
          Navigator.of(p0).pop(false);
        }
      },).then((value) {
        return value ?? false;
      },);
    }
    else {
      return true;
    }

  }


  /// Function to format a [number] into a two format digit, for example '2' becomes '02'
  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

}