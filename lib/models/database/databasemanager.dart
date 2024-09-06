import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
    await insertDefaultThemesAndDialogs(database);
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

  ///Retrieve the list of ThemeObject for a specific [language] from the database
  ///(fr / nl)
  Future<List<ThemeObject>> retrieveThemesFromLanguage(String language) async {
    final List<Map<String, Object?>> queryResult = await db.query('Theme',
    where: "language = ?",
    whereArgs: [language]);
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
    final List<Map<String, Object?>> queryResult = await db.query('Dialog',
      where: "language = ?",
      whereArgs: [language]
    );
    return queryResult.map((e) => DialogObject.fromMap(e)).toList();
  }

  ///Retrieve the list of DialogObject for a specific Theme from the database using the [themeId]
  Future<List<DialogObject>> retrieveDialogsFromTheme(int themeId) async {
    final List<Map<String, Object?>> queryResult = await db.query('Dialog',
        where: "id_theme = ?",
        whereArgs: [themeId]
    );
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

  ///Use the defaultThemesAndDialogs.json file to insert default values into Theme and Dialog tables
  Future<void> insertDefaultThemesAndDialogs(Database database) async {
    Map<String, dynamic> file = jsonDecode(
        await rootBundle.loadString('assets/defaultThemesAndDialogs.json'));
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

  factory DatabaseManager() {
    return _databaseManager;
  }
}
