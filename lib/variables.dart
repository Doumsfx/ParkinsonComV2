import 'package:flutter/material.dart';
import 'models/database/databasemanager.dart';

// Global variables
bool azerty = true; // true: azerty | false: abcde
bool langFR = true;  // true: FR     | false: NL
ValueNotifier<bool> dialogPageState = ValueNotifier<bool>(false); // true: keyboard page | false: page without keyboard

// Databases
DatabaseManager databaseManager = DatabaseManager();
