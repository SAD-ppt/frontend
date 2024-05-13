import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite_data/src/card_api_handler.dart';
import 'package:sqlite_data/src/card_template_api_handler.dart';
import 'package:sqlite_data/src/deck_api_handler.dart';
import 'package:sqlite_data/src/learning_stat_api_handler.dart';
import 'package:sqlite_data/src/note_api_handler.dart';
import 'package:sqlite_data/src/note_tag_api_handler.dart';
import 'package:sqlite_data/src/note_template_api_handler.dart';

Future<String> checkPath(String dbName) async {
  String documentsPath = (await getApplicationDocumentsDirectory()).path;
  String path = join(documentsPath, dbName);
  if (await Directory(dirname(path)).exists()) {
  } else {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}

Future<Database> initializeDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;

  String dbPath = await checkPath('anki_clone.db');

  return await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Deck(UniqueID TEXT PRIMARY KEY, Name TEXT, Description TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteTemplate(UniqueID TEXT PRIMARY KEY, Name TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteTemplateField(NoteTemplateID TEXT, OrderNumber INTEGER, Name TEXT, PRIMARY KEY(NoteTemplateID, OrderNumber), FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Note(UniqueID TEXT PRIMARY KEY, NoteTemplateID TEXT, FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteField(NoteID TEXT, OrderNumber INTEGER, RichTextData TEXT, PRIMARY KEY(NoteID, OrderNumber), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID), FOREIGN KEY(OrderNumber) REFERENCES NoteTemplateField(OrderNumber))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS CardTemplate(UniqueID TEXT PRIMARY KEY, NoteTemplateID TEXT, Name TEXT, FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS CardTemplateField(CardTemplateID TEXT, OrderNumber INTEGER, Side INTEGER, PRIMARY KEY(CardTemplateID, OrderNumber), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID), FOREIGN KEY(OrderNumber) REFERENCES NoteTemplateField(OrderNumber))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Card(CardTemplateID TEXT, DeckID TEXT, NoteID TEXT, PRIMARY KEY(CardTemplateID, DeckID, NoteID), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID), FOREIGN KEY(DeckID) REFERENCES Deck(UniqueID), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteTag(Name TEXT, NoteID TEXT, Color TEXT, PRIMARY KEY(Name, NoteID), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS LearningResult(DeckID TEXT, NoteID TEXT, CardTemplateID TEXT, Time TEXT, Result TEXT, PRIMARY KEY(DeckID, NoteID, CardTemplateID, Time), FOREIGN KEY(DeckID) REFERENCES Deck(UniqueID), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS LearningStat(DeckID TEXT, NoteID TEXT, CardTemplateID TEXT, PRIMARY KEY(DeckID, NoteID, CardTemplateID), FOREIGN KEY(DeckID) REFERENCES Deck(UniqueID), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID))');
  });
}

class SqliteDB {
  late Database db;
  late CardApiHandler cardApiHandler;
  late CardTemplateApiHandler cardTemplateApiHandler;
  late DeckApiHandler deckApiHandler;
  late NoteApiHandler noteApiHandler;
  late NoteTemplateApiHandler noteTemplateApiHandler;
  late LearningStatApiHandler learningStatApiHandler;
  late NoteTagApiHandler noteTagApiHandler;

  Future<void> init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();
    db = await initializeDB();
    cardApiHandler = CardApiHandler(db: db);
    cardTemplateApiHandler = CardTemplateApiHandler(db: db);
    deckApiHandler = DeckApiHandler(db: db);
    noteApiHandler = NoteApiHandler(db: db);
    noteTemplateApiHandler = NoteTemplateApiHandler(db: db);
    learningStatApiHandler = LearningStatApiHandler(db: db);
    noteTagApiHandler = NoteTagApiHandler(db: db);
  }

  Future<void> close() async {
    await db.close();
  }
}
