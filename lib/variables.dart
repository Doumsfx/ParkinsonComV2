import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/fileHandler.dart';
import 'models/ttshandler.dart';
import 'models/database/databasemanager.dart';

// Global variables
bool azerty = true; // true: azerty | false: abcde
bool langFR = true; // true: FR     | false: NL
ValueNotifier<bool> dialogPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> newThemePageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard

// Databases
DatabaseManager databaseManager = DatabaseManager();

//TTS
TtsHandler ttsHandler = TtsHandler();

//Internet Checker
ValueNotifier<bool> isConnected = ValueNotifier<bool>(true);

//Texts Manager
FileHandler languagesTextsFile = FileHandler();
