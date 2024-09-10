import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/database/databasemanager.dart';

// Global variables
bool azerty = true; // true: azerty | false: abcde
bool langFR = false;  // true: FR     | false: NL
ValueNotifier<bool> dialogPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard
ValueNotifier<bool> listDialogsPageState = ValueNotifier<bool>(true); // true: list of dialogs | false: list of themes

// Databases
DatabaseManager databaseManager = DatabaseManager();
