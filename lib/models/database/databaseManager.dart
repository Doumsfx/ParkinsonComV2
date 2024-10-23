// Database Manager
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'contact.dart';
import 'theme.dart';
import 'dialog.dart';
import 'reminder.dart';
import 'sms.dart';
import 'image.dart';
import 'music.dart';

class DatabaseManager {
  static final DatabaseManager _databaseManager = DatabaseManager._();

  DatabaseManager._();

  late Database db;

  factory DatabaseManager() {
    return _databaseManager;
  }

  /// Initialization of the data base
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, "parkinsoncom2.db"),
      onCreate: _onCreate,
      version: 1,
      onConfigure: _onConfigure,
    );
  }

  /// SQL commands executed after the creation of the database
  Future _onCreate(database, version) async {
    /*Creation of the Theme table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Theme(
            id_theme INTEGER PRIMARY KEY,
            title TEXT,
            language VARCHAR(2)
            );
          """);
    /*Creation of the Dialog table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Dialog(
            id_dialog INTEGER PRIMARY KEY,
            sentence TEXT,
            language VARCHAR(2),
            id_theme INTEGER,
            FOREIGN KEY (id_theme) REFERENCES Theme (id_theme) ON DELETE CASCADE
            );
          """);
    /*Insert Default French and Dutch Themes and Dialogs*/
    await insertDefaultThemesAndDialogs(database);

    /*Creation of the Reminder table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Reminder(
            id_reminder INTEGER PRIMARY KEY,
            title TEXT,
            hour TIME,
            ring BOOL,
            days TEXT
            );
          """);

    /*Creation of the Contact table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Contact(
            id_contact INTEGER PRIMARY KEY,
            last_name TEXT,
            first_name TEXT,
            email TEXT,
            phone TEXT,
            priority INTEGER
            );
          """);

    /*Creation of the Sms table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Sms(
            id_sms INTEGER PRIMARY KEY,
            content TEXT,
            isReceived BOOL,
            timeSms TIME,
            id_contact INTEGER,
            FOREIGN KEY (id_contact) REFERENCES Contact (id_contact) ON DELETE CASCADE
            );
          """);

    /*Creation of the Image table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Image(
            id_image INTEGER PRIMARY KEY,
            path TEXT
            );
          """);

    /*Creation of the Music table*/
    await database.execute("""
            CREATE TABLE IF NOT EXISTS Music(
            id_music INTEGER PRIMARY KEY,
            path TEXT
            );
          """);


  }

  /// Enable Foreign Keys
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Return true if the databse 'parkinsoncom2.db' exists
  Future<bool> doesExist() async {
    String path = await getDatabasesPath();
    if(await databaseExists(join(path,"parkinsoncom2.db"))){
      return true;
    }
    else {
      return false;
    }
  }

  /* CRUD Theme */
  /// Insert a [theme] into the database
  /// (the id_theme will be replaced by the autoincrement)
  Future<int> insertTheme(ThemeObject theme) async {
    int result = await db.insert('Theme', theme.toMap());
    return result;
  }

  /// Update a [theme] of the database (updating requires the right id_theme)
  Future<int> updateTheme(ThemeObject theme) async {
    int result = await db.update(
      'Theme',
      theme.toMap(),
      where: "id_theme = ?",
      whereArgs: [theme.id_theme],
    );
    return result;
  }

  /// Retrieve the list of ThemeObject from the database
  Future<List<ThemeObject>> retrieveThemes() async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme');
    return queryResult.map((e) => ThemeObject.fromMap(e)).toList();
  }

  /// Retrieve a specific ThemeObject from the database using its [id]
  Future<ThemeObject> retrieveThemeFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme', where: "id_theme = ?", whereArgs: [id]);
    return ThemeObject.fromMap(queryResult[0]);
  }

  /// Retrieve the list of ThemeObject for a specific [language] from the database
  /// (fr / nl)
  Future<List<ThemeObject>> retrieveThemesFromLanguage(String language) async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme', where: "language = ?", whereArgs: [language]);
    return queryResult.map((e) => ThemeObject.fromMap(e)).toList();
  }

  /// Delete the theme with the [id] from the database
  Future<void> deleteTheme(int id) async {
    await db.delete(
      'Theme',
      where: "id_theme = ?",
      whereArgs: [id],
    );
  }

  /* CRUD Dialog */
  /// Insert a [dialog] into the database
  /// (the id_dialog will be replaced by the autoincrement)
  Future<int> insertDialog(DialogObject dialog) async {
    int result = await db.insert('Dialog', dialog.toMap());
    return result;
  }

  /// Update a [dialog] of the database (updating requires the right id_dialog)
  Future<int> updateDialog(DialogObject dialog) async {
    int result = await db.update(
      'Dialog',
      dialog.toMap(),
      where: "id_dialog = ?",
      whereArgs: [dialog.id_dialog],
    );
    return result;
  }

  /// Retrieve the list of DialogObject from the database
  Future<List<DialogObject>> retrieveDialogs() async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog');
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  /// Retrieve the list of DialogObject for a specific language from the database
  /// (fr / nl)
  Future<List<DialogObject>> retrieveDialogsFromLanguage(String language) async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog', where: "language = ?", whereArgs: [language]);
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  /// Retrieve the list of DialogObject for a specific Theme from the database using the [themeId]
  Future<List<DialogObject>> retrieveDialogsFromTheme(int themeId) async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog', where: "id_theme = ?", whereArgs: [themeId]);
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  /// Delete the dialog with the [id] from the database
  Future<void> deleteDialog(int id) async {
    await db.delete(
      'Dialog',
      where: "id_dialog = ?",
      whereArgs: [id],
    );
  }

  /// Count the number of dialogs that belong to a theme
  Future<int> countDialogsFromTheme(int idTheme) async {
    List<Map<String, Object?>> queryResult = await db.rawQuery('''
    SELECT COUNT(*) FROM Dialog
    WHERE id_theme = ?;
    ''', [idTheme]);
    return int.parse(queryResult[0]["COUNT(*)"].toString());
  }

  /// Use the defaultThemesAndDialogs.json file to insert default values into Theme and Dialog tables
  Future<void> insertDefaultThemesAndDialogs(Database database) async {
    Map<String, dynamic> file = jsonDecode(await rootBundle.loadString('assets/defaultThemesAndDialogs.json'));
    int idThemeCounter = 0;
    for (var language in file.keys) {
      for (var theme in file[language].keys) {
        await database.insert('Theme', {
          'title': theme,
          'language': language,
        });
        idThemeCounter++;
        for (var dialog in file[language][theme]) {
          await database.insert('Dialog', {
            'sentence': dialog,
            'language': language,
            'id_theme': idThemeCounter,
          });
        }
      }
    }
  }


  /* CRUD Reminder */
  /// Insert a [Reminder] into the database
  /// (the id_reminder  will be replaced by the autoincrement)
  Future<int> insertReminder(Reminder reminder) async {
    int result = await db.insert('Reminder', reminder.toMap());
    return result;
  }

  /// Update a [reminder] of the database (updating requires the right id_reminder)
  Future<int> updateReminder(Reminder reminder) async {
    int result = await db.update(
      'Reminder',
      reminder.toMap(),
      where: "id_reminder = ?",
      whereArgs: [reminder.id_reminder],
    );
    return result;
  }

  /// Retrieve the list of Reminder from the database
  Future<List<Reminder>> retrieveReminders() async {
    final List<Map<String, Object?>> queryResult = await db.query('Reminder');
    return queryResult.map((e) => Reminder.fromMap(e)).toList();
  }

  /// Retrieve a specific Reminder from the database using its [id]
  Future<Reminder> retrieveReminderFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Reminder', where: "id_reminder = ?", whereArgs: [id]);
    return Reminder.fromMap(queryResult[0]);
  }

  /// Delete the Reminder with the [id] from the database
  Future<void> deleteReminder(int id) async {
    await db.delete(
      'Reminder',
      where: "id_reminder = ?",
      whereArgs: [id],
    );
  }

  /* CRUD Contact */
  /// Insert a [Contact] into the database
  /// (the id_contact  will be replaced by the autoincrement)
  Future<int> insertContact(Contact contact) async {
    int result = await db.insert('Contact', contact.toMap());
    return result;
  }

  /// Update a [contact] of the database (updating requires the right id_contact)
  Future<int> updateContact(Contact contact) async {
    int result = await db.update(
      'Contact',
      contact.toMap(),
      where: "id_contact = ?",
      whereArgs: [contact.id_contact],
    );
    return result;
  }

  /// Retrieve the list of Contact from the database
  Future<List<Contact>> retrieveContacts() async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact', where: "id_contact != 0");
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }

  /// Retrieve a specific Contact from the database using its [id]
  Future<Contact> retrieveContactFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact', where: "id_contact = ?", whereArgs: [id]);
    return Contact.fromMap(queryResult[0]);
  }

  /// Retrieve the Contact with a specific [phoneNumber]  from the database
  Future<Contact?> retrieveContactFromPhone(String phoneNumber) async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact', where: "phone LIKE ?", whereArgs: ['%$phoneNumber']);
    if(queryResult.isNotEmpty) {
      return Contact.fromMap(queryResult[0]);
    }
    else {
      return null;
    }
  }

  /// Delete the Contact with the [id] from the database
  Future<void> deleteContact(int id) async {
    await db.delete(
      'Contact',
      where: "id_contact = ?",
      whereArgs: [id],
    );
  }

  /// Count the number of contacts
  Future<int> countContacts() async {
    //id_contact = 0 --> not a contact but the user's info
    List<Map<String, Object?>> queryResult = await db.rawQuery('''
    SELECT COUNT(*) FROM Contact
    WHERE id_contact != 0;
    ''');
    return int.parse(queryResult[0]["COUNT(*)"].toString());
  }

  /// Retrieve a list of Contacts from the database using their [priority] (1 = primary, 2 = secondary, 3 = none)
  Future<List<Contact>> retrieveContactFromPriority(int priority) async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact', where: "priority = ?", whereArgs: [priority]);
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }

  /// Retrieve the User's info from the database
  Future<Contact> retrieveUserInfo() async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact', where: "id_contact = 0");
    return Contact.fromMap(queryResult[0]);
  }


  /* CRUD Sms */
  /// Insert a [Sms] into the database
  /// (the id_sms  will be replaced by the autoincrement)
  Future<int> insertSms(Sms sms) async {
    int result = await db.insert('Sms', sms.toMap());
    return result;
  }

  /// Update a [sms] of the database (updating requires the right id_sms)
  Future<int> updateSms(Sms sms) async {
    int result = await db.update(
      'Sms',
      sms.toMap(),
      where: "id_sms = ?",
      whereArgs: [sms.id_sms],
    );
    return result;
  }

  /// Retrieve the list of Sms from the database
  Future<List<Sms>> retrieveSms() async {
    final List<Map<String, Object?>> queryResult = await db.query('Sms');
    return queryResult.map((e) => Sms.fromMap(e)).toList();
  }

  /// Retrieve a specific Sms from the database using its [id]
  Future<Sms> retrieveSmsFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Sms', where: "id_sms = ?", whereArgs: [id]);
    return Sms.fromMap(queryResult[0]);
  }

  /// Retrieve a list of Sms exchanged with a specific contact using its [id_contact]
  Future<List<Sms>> retrieveSmsFromContact(int id_contact) async {
    final List<Map<String, Object?>> queryResult = await db.query('Sms', where: "id_contact = ?", whereArgs: [id_contact]);
    return queryResult.map((e) => Sms.fromMap(e)).toList();
  }

  /// Delete the Sms with the [id] from the database
  Future<void> deleteSms(int id) async {
    await db.delete(
      'Sms',
      where: "id_sms = ?",
      whereArgs: [id],
    );
  }


  /* CRUD Image */
  /// Insert a [image] into the database
  /// (the id_image will be replaced by the autoincrement)
  Future<int> insertImage(ImageObject image) async {
    int result = await db.insert('Image', image.toMap());
    return result;
  }

  /// Update a [image] of the database (updating requires the right id_image)
  Future<int> updateImage(ImageObject image) async {
    int result = await db.update(
      'Image',
      image.toMap(),
      where: "id_image = ?",
      whereArgs: [image.id_image],
    );
    return result;
  }

  /// Retrieve the list of ImageObject from the database
  Future<List<ImageObject>> retrieveImages() async {
    final List<Map<String, Object?>> queryResult = await db.query('Image');
    return queryResult.map((e) => ImageObject.fromMap(e)).toList();
  }

  /// Delete the image with the [id] from the database
  Future<void> deleteImage(int id) async {
    await db.delete(
      'Image',
      where: "id_image = ?",
      whereArgs: [id],
    );
  }


  /* CRUD Music */
  /// Insert a [music] into the database
  /// (the id_music will be replaced by the autoincrement)
  Future<int> insertMusic(MusicObject music) async {
    int result = await db.insert('Music', music.toMap());
    return result;
  }

  /// Update a [music] of the database (updating requires the right id_music)
  Future<int> updateMusic(MusicObject music) async {
    int result = await db.update(
      'Music',
      music.toMap(),
      where: "id_music = ?",
      whereArgs: [music.id_music],
    );
    return result;
  }

  /// Retrieve the list of MusicObject from the database
  Future<List<MusicObject>> retrieveMusics() async {
    final List<Map<String, Object?>> queryResult = await db.query('Music');
    return queryResult.map((e) => MusicObject.fromMap(e)).toList();
  }

  /// Delete the music with the [id] from the database
  Future<void> deleteMusic(int id) async {
    await db.delete(
      'Music',
      where: "id_music = ?",
      whereArgs: [id],
    );
  }


}
