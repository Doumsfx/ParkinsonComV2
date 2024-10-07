

import 'dart:convert';

import 'package:flutter/services.dart';

class FileHandler {
  late Map<String,dynamic> texts;

  FileHandler() {
    texts = {};
    setNewLanguage("fr"); //load the french version by default
  }

  ///Load the texts for a specific [language] (available by default : FR and NL)
  Future<void> setNewLanguage(String language) async {
    try {
      //Open file
      Map<String, dynamic> file = jsonDecode(await rootBundle.loadString('assets/languages.json'));
      //Check if language is available in the file, and if it is not empty
      if(file.keys.contains(language) && file[language] != null) {
        texts = file[language]!;
      }
      else {
        texts = file["fr"]!; //Reset by default to French
        throw Exception("Language is unknown or empty: $language");
      }
    }
    catch (e) {
      throw Exception("Error loading file: $e");
    }
  }

}