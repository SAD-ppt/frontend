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
  String documentsPath;
  if (Platform.isWindows) {
    documentsPath = (await getDatabasesPath());
  }
  else {
    documentsPath = (await getApplicationDocumentsDirectory()).path;
  }
  String path = join(documentsPath, dbName);
  if (await Directory(dirname(path)).exists()) {
  } else {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      throw 'Error creating directory: $e';
    }
  }
  return path;
}

Future<Database> initializeDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
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
        'CREATE TABLE IF NOT EXISTS NoteField(NoteID TEXT, OrderNumber INTEGER, RichTextData TEXT, PRIMARY KEY(NoteID, OrderNumber), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS CardTemplate(UniqueID TEXT PRIMARY KEY, NoteTemplateID TEXT, Name TEXT, FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS CardTemplateField(CardTemplateID TEXT, OrderNumber INTEGER, Side INTEGER, PRIMARY KEY(CardTemplateID, OrderNumber), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID))');
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
    WidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await initializeDB();
    await initData(db);
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

  Future<void> initData(Database db) async {
    await db.query('Deck').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO Deck (UniqueID, Name, Description) VALUES 
          ('deck1', 'Deck 1', 'Description for Deck 1'),
          ('deck2', 'Deck 2', 'Description for Deck 2'),
          ('deck3', 'Deck 3', 'Description for Deck 3');""");
      }
    });
    await db.query('NoteTemplate').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO NoteTemplate (UniqueID, Name) VALUES 
          ('note_template1', 'Note Template 1'),
          ('note_template2', 'Note Template 2'),
          ('note_template3', 'Note Template 3');""");
      }
    });
    await db.query('NoteTemplateField').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO NoteTemplateField (NoteTemplateID, OrderNumber, Name) VALUES 
          ('note_template1', 0, 'Field 1'),
          ('note_template1', 1, 'Field 2'),
          ('note_template1', 2, 'Field 3'),
          ('note_template2', 0, 'Field 1'),
          ('note_template2', 1, 'Field 2'),
          ('note_template2', 2, 'Field 3'),
          ('note_template3', 0, 'Field 1'),
          ('note_template3', 1, 'Field 2'),
          ('note_template3', 2, 'Field 3');""");
      }
    });
    await db.query('Note').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO Note (UniqueID, NoteTemplateID) VALUES 
          ('note1', 'note_template1'),
          ('note2', 'note_template2'),
          ('note3', 'note_template3');""");
      }
    });
    await db.query('NoteField').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO NoteField (NoteID, OrderNumber, RichTextData) VALUES 
          ('note1', 0, 'Rich Text Data 1'),
          ('note1', 1, 'Rich Text Data 2'),
          ('note1', 2, 'Rich Text Data 3'),
          ('note2', 0, 'Rich Text Data 1'),
          ('note2', 1, 'Rich Text Data 2'),
          ('note2', 2, 'Rich Text Data 3'),
          ('note3', 0, 'Rich Text Data 1'),
          ('note3', 1, 'Rich Text Data 2'),
          ('note3', 2, 'Rich Text Data 3');""");
      }
    });
    await db.query('CardTemplate').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO CardTemplate (UniqueID, NoteTemplateID, Name) VALUES 
          ('card_template1', 'note_template1', 'Card Template 1'),
          ('card_template2', 'note_template2', 'Card Template 2'),
          ('card_template3', 'note_template3', 'Card Template 3');""");
      }
    });
    await db.query('CardTemplateField').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO CardTemplateField (CardTemplateID, OrderNumber, Side) VALUES 
          ('card_template1', 0, 0),
          ('card_template1', 1, 1),
          ('card_template1', 2, 0),
          ('card_template2', 0, 0),
          ('card_template2', 1, 1),
          ('card_template2', 2, 0),
          ('card_template3', 0, 0),
          ('card_template3', 1, 1),
          ('card_template3', 2, 0);""");
      }
    });
    await db.query('Card').then((value) {
      if (value.isEmpty) {
        db.execute("""
        INSERT INTO Card (CardTemplateID, DeckID, NoteID) VALUES 
          ('card_template1', 'deck1', 'note1'),
          ('card_template2', 'deck1', 'note2'),
          ('card_template3', 'deck1', 'note3'),
          ('card_template2', 'deck2', 'note2'),
          ('card_template3', 'deck3', 'note3');""");
      }
    });
  }
}
