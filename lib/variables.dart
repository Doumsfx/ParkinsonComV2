import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/database/databasemanager.dart';

// Global variables
bool azerty = true; // true: azerty | false: abcde
bool langFR = true;  // true: FR     | false: NL
ValueNotifier<bool> dialogPageState = ValueNotifier<bool>(false);

//Databases
DatabaseManager databaseManager = DatabaseManager();
