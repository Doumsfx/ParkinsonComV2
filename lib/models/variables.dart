// Global Variables
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/emailHandler.dart';
import 'package:parkinson_com_v2/models/emergencyRequest.dart';
import 'package:parkinson_com_v2/models/fileHandler.dart';
import 'package:parkinson_com_v2/models/smsHandler.dart';
import 'package:parkinson_com_v2/models/smsReceiver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notificationHandler.dart';
import 'ttsHandler.dart';
import 'database/databaseManager.dart';

SharedPreferencesWithCache? preferences;

// Global variables
late bool azerty; // true: azerty | false: abcde
late String language; // "fr" | "nl"
late bool hasSimCard; // true: the device has a sim card | false: it doesn't have one
late bool wantPhoneFunctionality; // true: user want to send SMS | false: user don't want to send SMS
late bool isFirstLaunch; // true: before user registers | false: after registration
bool isThisDeviceATablet = true; // true: tablet | false: phone
double screenRatio = 0;
late double ttsVolume; // Voice volume [0; 1]
late double ttsRate; // Voice pitch [0.5; 2]
late double ttsPitch; // Voice speed rate [0; 1]
late String ttsGender;

ValueNotifier<bool> dialogPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newThemePageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newReminderPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newContactPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> loginPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> verificationPopUpState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> conversationPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> userSettingsPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard

Map<String,dynamic> unreadMessages = <String,dynamic>{}; // Map  {"id_contact" : number_of_unread_sms}

final Map<String, int> idDialogWithoutTheme = {
  "fr": 1,
  "nl": 13,
};


// Database
DatabaseManager databaseManager = DatabaseManager();

// TTS
TtsHandler ttsHandler = TtsHandler();

// Internet Checker
ValueNotifier<bool> isConnected = ValueNotifier<bool>(true);

// Texts Manager
FileHandler languagesTextsFile = FileHandler();

// Notification Handler
NotificationHandler notificationHandler = NotificationHandler();

// E-Mail Handler
EmailHandler emailHandler = EmailHandler();

// SMS Handler
SmsHandler smsHandler = SmsHandler();

// Emergency Requester
EmergencyRequest emergencyRequest = EmergencyRequest();

// SMS Receiver
SmsReceiver smsReceiver = SmsReceiver();
