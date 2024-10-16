
import 'dart:ui';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:telephony/telephony.dart' as tel;
import 'package:permission_handler/permission_handler.dart';


class SmsReceiver {
  final SmsQuery _query = SmsQuery(); // Query to read SMS Conversations
  List<SmsMessage> _messages = [];
  List<SmsMessage> _messagesSent = [];
  List<SmsMessage> _messagesReceived = [];
  final tel.Telephony _telephony = tel.Telephony.instance; // Instance to detect when a SMS is received
  VoidCallback? onReceiveSMS; // Callback (-> update a state) executed when SMS is received

  Map<String,int> newMessages = {};

  SmsReceiver({this.onReceiveSMS});

  void setCallBack(VoidCallback functionCallback) {
    onReceiveSMS = functionCallback;
  }

  List<SmsMessage> getMessages() => _messages;
  List<SmsMessage> getMessagesSent() => _messagesSent;
  List<SmsMessage> getMessagesReceived() => _messagesReceived;

  /*
  /// Convert a [phoneNumber] starting with a 0 into the international phone number format (must be edited in order to add your country code)
  String convertIntoInternational(String phoneNumber, String country) {
    if (phoneNumber.startsWith("0")) {
      var temp = phoneNumber.split("");
      temp[0] = _countryCodes[country] ?? "+33"; // we set at French by default
      return temp.join("");
    }
    else {
      return phoneNumber;
    }
  }

   */

  /// Return the number of SMS from the newMessages map
  int countNewSMS() {
    int count = 0;
    for(var number in newMessages.keys) {
      count += newMessages[number]!;
    }
    return count;
  }

  /// Return the number of SMS from newMessages map for a specific [phone] number
  int getSmsForPhone(String phone) {
    String phoneNumber = phone;
    // If truncated : we only keep the end of the phone number (cut the 0)
    if(phoneNumber.startsWith("0")) {
      phoneNumber = phoneNumber.substring(1);
    }
    // Search for a phone number finishing with our phoneNumber (can start with 0 or +...)
    for(var p in newMessages.keys) {
      if(p.endsWith(phoneNumber)) {
        return newMessages[p]!;
      }
    }
    return 0;
  }

  /// Read the list of exchanged SMS with a contact using his [phoneNumber]
  Future<void> requestPermissionsAndReadSMS(String phoneNumber) async {
    // Request SMS permission
    PermissionStatus status = await Permission.sms.request();
    if (status.isGranted) {
      // Fetch the list of SMS

      List<SmsMessage> messages = await _query.getAllSms;

      for(SmsMessage sms in messages) {

      }

      /*
      // Received
      List<SmsMessage> messagesReceived = await _query.querySms(
          kinds: [SmsQueryKind.inbox],
          address: phoneNumber // International format (+...)
      );
      // Sent
      List<SmsMessage> messagesSent = await _query.querySms(
          kinds: [SmsQueryKind.sent],
          address: phoneNumber // Truncated (0...)
      );

      // If the phone number start with 0 (ex : 06.../07...)
      // We replace it with it international format (ex : +336../+337..)
      // Needed because you can send to a 0..., but you always receive from a +...

      // Check all country codes
      for(var country in _countryCodes.keys) {
        // /!\ If you communicate with a foreign number you must add its country code to the _countryCodes map
        String internationalPhoneNumber = convertIntoInternational(phoneNumber, country);

        // Fetch SMS
        messagesReceived.addAll(await _query.querySms(
          kinds: [SmsQueryKind.inbox],
          address: internationalPhoneNumber
        ));
        messagesSent.addAll(await _query.querySms(
          kinds: [SmsQueryKind.sent],
          address: internationalPhoneNumber
        ));
      }

      // Merge sent and received SMS into a single List in order to sort the SMS based on the timestamp
      List<SmsMessage> messages = [];
      messages.addAll(messagesReceived);
      messages.addAll(messagesSent);

      messages.sort((a, b) {
        if(a.date != null && b.date != null) {
          return (a.date as DateTime).compareTo(b.date as DateTime);
        }
        // One date is null
        else {
          return 1;
        }
      });

      // Set the new values of each list
      _messages = messages;
      _messagesReceived = messagesReceived;
      _messagesSent = messagesSent;

      */

    } else {
      print("SMS permission denied");
    }
  }

  Future<void> initReceiver() async {
    // Ask for permissions
    bool? result = await _telephony.requestSmsPermissions;
    // Permissions granted
    if(result != null && result == true) {
      // Start to listen for incoming SMS
      _telephony.listenIncomingSms(
        onNewMessage: (tel.SmsMessage message) {

          // Update the map of the new SMS
          if (message.address != null) {

            // International phone number format
            String internationalFormat = message.address!;
            if(message.address!.startsWith("0")) {
              //internationalFormat = convertIntoInternational(internationalFormat, language);
            }
            // Increment by 1 in the map
            if(newMessages.keys.contains(message.address) && newMessages[message.address] != null ) {
              (newMessages[message.address!] = newMessages[message.address!] !+ 1);
            }
            else if(newMessages.keys.contains(internationalFormat)) {
              (newMessages[internationalFormat] = newMessages[internationalFormat] !+ 1);
            }
            else {
              newMessages.addAll({message.address! : 1});
            }

            print(newMessages.toString());
          }

          // Callback function (refresh UI)
          if(onReceiveSMS != null) {
            onReceiveSMS!();
          }

          print("Message reçu : ${message.body}");
        },
        listenInBackground: false,
      );
    }
  }

}