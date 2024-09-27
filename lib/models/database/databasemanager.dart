// Database Manager
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:parkinson_com_v2/models/database/reminder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'contact.dart';
import 'theme.dart';
import 'dialog.dart';

class DatabaseManager {
  static final DatabaseManager _databaseManager = DatabaseManager._();

  DatabaseManager._();

  late Database db;

  ///Initialization of the data base
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, "parkinsoncom2.db"),
      onCreate: _onCreate,
      version: 1,
      onConfigure: _onConfigure,
    );
  }

  ///SQL commands executed after the creation of the database
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

    //todo delete this
    await _insertContacts(database);
  }

  ///Enable Foreign Keys
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /* CRUD Theme */
  ///Insert a [theme] into the database
  ///(the id_theme will be replaced by the autoincrement)
  Future<int> insertTheme(ThemeObject theme) async {
    int result = await db.insert('Theme', theme.toMap());
    return result;
  }

  ///Update a [theme] of the database (updating requires the right id_theme)
  Future<int> updateTheme(ThemeObject theme) async {
    int result = await db.update(
      'Theme',
      theme.toMap(),
      where: "id_theme = ?",
      whereArgs: [theme.id_theme],
    );
    return result;
  }

  ///Retrieve the list of ThemeObject from the database
  Future<List<ThemeObject>> retrieveThemes() async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme');
    return queryResult.map((e) => ThemeObject.fromMap(e)).toList();
  }

  ///Retrieve a specific ThemeObject from the database using its [id]
  Future<ThemeObject> retrieveThemeFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme', where: "id_theme = ?", whereArgs: [id]);
    return ThemeObject.fromMap(queryResult[0]);
  }

  ///Retrieve the list of ThemeObject for a specific [language] from the database
  ///(fr / nl)
  Future<List<ThemeObject>> retrieveThemesFromLanguage(String language) async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme', where: "language = ?", whereArgs: [language]);
    return queryResult.map((e) => ThemeObject.fromMap(e)).toList();
  }

  ///Delete the theme with the [id] from the database
  Future<void> deleteTheme(int id) async {
    await db.delete(
      'Theme',
      where: "id_theme = ?",
      whereArgs: [id],
    );
  }

  /* CRUD Dialog */
  ///Insert a [dialog] into the database
  ///(the id_dialog will be replaced by the autoincrement)
  Future<int> insertDialog(DialogObject dialog) async {
    int result = await db.insert('Dialog', dialog.toMap());
    return result;
  }

  ///Update a [dialog] of the database (updating requires the right id_dialog)
  Future<int> updateDialog(DialogObject dialog) async {
    int result = await db.update(
      'Dialog',
      dialog.toMap(),
      where: "id_dialog = ?",
      whereArgs: [dialog.id_dialog],
    );
    return result;
  }

  ///Retrieve the list of DialogObject from the database
  Future<List<DialogObject>> retrieveDialogs() async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog');
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  ///Retrieve the list of DialogObject for a specific language from the database
  ///(fr / nl)
  Future<List<DialogObject>> retrieveDialogsFromLanguage(String language) async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog', where: "language = ?", whereArgs: [language]);
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  ///Retrieve the list of DialogObject for a specific Theme from the database using the [themeId]
  Future<List<DialogObject>> retrieveDialogsFromTheme(int themeId) async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog', where: "id_theme = ?", whereArgs: [themeId]);
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  ///Delete the dialog with the [id] from the database
  Future<void> deleteDialog(int id) async {
    await db.delete(
      'Dialog',
      where: "id_dialog = ?",
      whereArgs: [id],
    );
  }

  ///Count the number of dialogs that belong to a theme
  Future<int> countDialogsFromTheme(int idTheme) async {
    List<Map<String, Object?>> queryResult = await db.rawQuery('''
    SELECT COUNT(*) FROM Dialog
    WHERE id_theme = ?;
    ''', [idTheme]);
    return int.parse(queryResult[0]["COUNT(*)"].toString());
  }

  ///Use the defaultThemesAndDialogs.json file to insert default values into Theme and Dialog tables
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
  ///Insert a [Reminder] into the database
  ///(the id_reminder  will be replaced by the autoincrement)
  Future<int> insertReminder(Reminder reminder) async {
    int result = await db.insert('Reminder', reminder.toMap());
    return result;
  }

  ///Update a [reminder] of the database (updating requires the right id_reminder)
  Future<int> updateReminder(Reminder reminder) async {
    int result = await db.update(
      'Reminder',
      reminder.toMap(),
      where: "id_reminder = ?",
      whereArgs: [reminder.id_reminder],
    );
    return result;
  }

  ///Retrieve the list of Reminder from the database
  Future<List<Reminder>> retrieveReminders() async {
    final List<Map<String, Object?>> queryResult = await db.query('Reminder');
    return queryResult.map((e) => Reminder.fromMap(e)).toList();
  }

  ///Retrieve a specific Reminder from the database using its [id]
  Future<Reminder> retrieveReminderFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Reminder', where: "id_reminder = ?", whereArgs: [id]);
    return Reminder.fromMap(queryResult[0]);
  }

  ///Delete the Reminder with the [id] from the database
  Future<void> deleteReminder(int id) async {
    await db.delete(
      'Reminder',
      where: "id_reminder = ?",
      whereArgs: [id],
    );
  }

  /* CRUD Contact */
  ///Insert a [Contact] into the database
  ///(the id_contact  will be replaced by the autoincrement)
  Future<int> insertContact(Contact contact) async {
    int result = await db.insert('Contact', contact.toMap());
    return result;
  }

  ///Update a [contact] of the database (updating requires the right id_contact)
  Future<int> updateContact(Contact contact) async {
    int result = await db.update(
      'Contact',
      contact.toMap(),
      where: "id_contact = ?",
      whereArgs: [contact.id_contact],
    );
    return result;
  }

  ///Retrieve the list of Contact from the database
  Future<List<Contact>> retrieveContacts() async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact');
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }

  ///Retrieve a specific Contact from the database using its [id]
  Future<Contact> retrieveContactFromId(int id) async {
    final List<Map<String, Object?>> queryResult = await db.query('Contact', where: "id_contact = ?", whereArgs: [id]);
    return Contact.fromMap(queryResult[0]);
  }

  ///Delete the Contact with the [id] from the database
  Future<void> deleteContact(int id) async {
    await db.delete(
      'Contact',
      where: "id_contact = ?",
      whereArgs: [id],
    );
  }

  factory DatabaseManager() {
    return _databaseManager;
  }


  //todo delete this
  Future<void> _insertContacts(Database database) async {
  }
}
