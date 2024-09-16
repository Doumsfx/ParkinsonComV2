
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped}

class TtsHandler {
  late FlutterTts flutterTts;
  String? language; //Selected language
  String? voice; //Selected voice
  String? engine; //Selected engine (ex: com.google.android.tts / com.samsung.SMT / etc)
  double _volume = 0.5; // Voice volume [0; 1]
  double _pitch = 1.0; // Voice pitch [0.5; 2]
  double _rate = 0.5; // Voice speed rate [0; 1]

  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  Future<List<String>>? _languagesList;

  //Get State (don't need paused or continued for our usage)
  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;

  //Get Platform
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  TtsHandler();

  ///Initialization of the TTS
  dynamic initTts() async {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    //Functions to know the state of the TTS Player
    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
    });
    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
    });
    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState = TtsState.stopped;
    });
    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      ttsState = TtsState.stopped;
    });

    if (isAndroid) {
      //Set up the Google Engine for the tts (if available, else it will be the default engine of the device)
      if((await flutterTts.getEngines).contains('com.google.android.tts')) {
        flutterTts.setEngine('com.google.android.tts');
      } else {
        _getDefaultEngine();
      }
      //Set the voice to the device's default one
      _getDefaultVoice();

      //Retrieve the list of languages available on the device
      _languagesList = _getLanguages();
    }
  }

  ///Default Engine
  Future<void> _getDefaultEngine() async => await flutterTts.getDefaultEngine;
  ///Default Voice
  Future<void> _getDefaultVoice() async => await flutterTts.getDefaultVoice;

  ///Function to start the voice
  Future<void> speak() async {
    await flutterTts.setVolume(_volume);
    await flutterTts.setSpeechRate(_rate);
    await flutterTts.setPitch(_pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  ///Function to set the await speak completion to true (the tts will wait to finish before starting saying another text)
  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  ///Function to stop the tts when speaking
  Future<void> stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  ///Retrieve a list of languages available on the device (using the ISO 639)
  Future<List<String>> _getLanguages() async {
    List<String> languages = await flutterTts.getLanguages;
    return languages;
  }

  ///Set the new text to be said
  void setText(String text) {
    _newVoiceText = text;
  }

  ///Set pitch : [0.5; 2]
  void setPitch(double value) {
    _pitch = value;
  }

  ///Set volume : [0; 1]
  void setVolume(double value) {
    _volume = value;
  }

  ///Set speed rate : [0; 1]
  void setRate(double value) {
    _rate = value;
  }

}