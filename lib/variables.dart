// Global Variables
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/emailhandler.dart';
import 'package:parkinson_com_v2/models/emergencyRequest.dart';
import 'package:parkinson_com_v2/models/fileHandler.dart';
import 'package:parkinson_com_v2/models/smshandler.dart';
import 'models/notificationHandler.dart';
import 'models/ttshandler.dart';
import 'models/database/databasemanager.dart';

// Global variables
bool azerty = true; // true: azerty | false: abcde
String language = "fr"; // "fr" | "nl"
bool hasSimCard = true; // true: the device has a sim card | false: it doesn't have one
bool isFirstLaunch = false; // true: before user registers | false: after registration
bool isThisDeviceATablet = true; // true: tablet | false: phone

ValueNotifier<bool> dialogPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newThemePageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newReminderPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newContactPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> loginPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> verificationPopUpState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
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

