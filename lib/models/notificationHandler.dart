// Notification Handler
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parkinson_com_v2/models/popupsHandler.dart';

import 'variables.dart';
import 'database/reminder.dart';

class NotificationHandler {
  // Variables
  bool buttonAnimation = false;
  List<Reminder> _listReminders = [];
  late Timer timer;
  var timeAndDate = DateTime.now();
  List<String> days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
  AudioPlayer audioPlayer = AudioPlayer();



  /// Function that push a notification with the [text] on the device
  Future<void> _showNotification(String text, String title, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    // Details of the android notification
    var androidDetails = const AndroidNotificationDetails(
      'channelId', // Canal ID
      'Alerte Médicament', // Canal name
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,

    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    // Show the Pop Up
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      title, // Titre
      text, // Contenu
      generalNotificationDetails, // Paramètres de notification
    );
  }

  /// Dispose the Audio Player
  void dispose(){
    audioPlayer.dispose();
  }

  /// Reformat the number in 2 digits, example with '2' that becomes '02'
  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Start the music in loop
  Future<void> startMusic() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource('alarm.wav'));
  }

  /// Stop the music
  Future<void> stopMusic() async {
    await audioPlayer.stop();
  }

  /// Pause the music
  Future<void> pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Resume the music
  Future<void> resumeMusic() async {
    await audioPlayer.resume();
  }

  /// Set the volume to [nb]
  Future<void> setVolume(double nb) async{
    audioPlayer.setVolume(nb);
  }

  /// Check if the audio player is already playing music
  bool isMusicPlaying() {
    PlayerState playerState = audioPlayer.state;
    return playerState == PlayerState.playing;
  }

  /// This function check every minutes if one of the reminders is at the current time, if yes he plays music, pop up and notification
  void startCheck(BuildContext context, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin){
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      DateTime newTimeAndDate = DateTime.now();
      timeAndDate = newTimeAndDate;

      if(timeAndDate.second == 0){
        //Check the reminders only if the database has been created (avoid checks when on login page)
        if(await databaseManager.doesExist()) {
          // Update our list of reminders
          _listReminders = await databaseManager.retrieveReminders();

          // Checking if it's not empty
          if(_listReminders.isNotEmpty){
            // Getting current time and current day
            String currentTime = "${formatWithTwoDigits(timeAndDate.hour)}:${formatWithTwoDigits(timeAndDate.minute)}";
            String currentDay = days[timeAndDate.weekday - 1];
            int i = 0;
            for(i; i < _listReminders.length; i += 1){
              if(_listReminders[i].hour == currentTime){
                if(_listReminders[i].days.contains(currentDay)){
                  //Popup
                  //_showReminderPopUp(context, "${languagesTextsFile.texts["notification_text"]}:\n ${_listReminders[i].title}");
                  Popups.showPopupOk(context, text: "${languagesTextsFile.texts["notification_text"]}:\n ${_listReminders[i].title}", textOk: languagesTextsFile.texts["pop_up_ok"]!, functionOk: (p0) {
                    stopMusic();
                    Navigator.pop(context);
                  },);
                  //Device notification
                  _showNotification("${languagesTextsFile.texts["notification_text"]} ${_listReminders[i].title}",languagesTextsFile.texts["notification_title"], flutterLocalNotificationsPlugin);
                  if(_listReminders[i].ring && !isMusicPlaying()){
                    startMusic();
                  }
                }
              }
            }
          }
        }
      }
    });
  }

}
