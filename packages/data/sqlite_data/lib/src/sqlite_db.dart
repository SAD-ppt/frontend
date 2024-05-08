import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite_data/src/card_api_handler.dart';
import 'package:sqlite_data/src/card_template_api_handler.dart';
import 'package:sqlite_data/src/deck_api_handler.dart';
import 'package:sqlite_data/src/learning_stat_api_handler.dart';
import 'package:sqlite_data/src/note_api_handler.dart';
import 'package:sqlite_data/src/note_tag_api_handler.dart';
import 'package:sqlite_data/src/note_template_api_handler.dart';

Future<Database> initializeDB() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return openDatabase(join(await getDatabasesPath(), 'data.db'), version: 1,
      onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Deck(UniqueID TEXT PRIMARY KEY, Name TEXT, Description TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteTemplate(UniqueID TEXT PRIMARY KEY, Name TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteTemplateField(NoteTemplateID TEXT, OrderNumber INTEGER, Name TEXT, PRIMARY KEY(NoteTemplateID, OrderNumber), FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Note(UniqueID TEXT PRIMARY KEY, NoteTemplateID TEXT, FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS NoteField(NoteID TEXT, OrderNumber INTEGER, RichDataText TEXT, PRIMARY KEY(NoteID, OrderNumber), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID)), FOREIGN KEY(OrderNumber) REFERENCES NoteTemplateField(OrderNumber))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS CardTemplate(UniqueID TEXT PRIMARY KEY, NoteTemplateID TEXT, Name TEXT, FOREIGN KEY(NoteTemplateID) REFERENCES NoteTemplate(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS CardTemplateField(CardTemplateID TEXT, OrderNumber INTEGER, NoteTemplateFieldID TEXT, Side INTEGER, PRIMARY KEY(CardTemplateID, OrderNumber), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID), FOREIGN KEY(NoteTemplateFieldID) REFERENCES NoteTemplateField(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Card(CardTemplateID TEXT, DeckID TEXT, NoteID TEXT, PRIMARY KEY(CardTemplateID, DeckID, NoteID), FOREIGN KEY(CardTemplateID) REFERENCES CardTemplate(UniqueID), FOREIGN KEY(DeckID) REFERENCES Deck(UniqueID), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Tag(Name TEXT, NoteID TEXT, Color TEXT, PRIMARY KEY(Name, NoteID), FOREIGN KEY(NoteID) REFERENCES Note(UniqueID)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS LearningResult(CardID TEXT, Time TEXT, Result TEXT, PRIMARY KEY(CardID, Time), FOREIGN KEY(CardID) REFERENCES Card(UniqueID))');
  });
}

class SqliteDB {
  late Database _db;
  late CardApiHandler cardApiHandler;
  late CardTemplateApiHandler cardTemplateApiHandler;
  late DeckApiHandler deckApiHandler;
  late NoteApiHandler noteApiHandler;
  late NoteTemplateApiHandler noteTemplateApiHandler;
  late LearningStatApiHandler learningStatApiHandler;
  late NoteTagApiHandler noteTagApiHandler;

  Future<void> init() async {
    _db = await initializeDB();
    cardApiHandler = CardApiHandler(db: _db);
    cardTemplateApiHandler = CardTemplateApiHandler(db: _db);
    deckApiHandler = DeckApiHandler(db: _db);
    noteApiHandler = NoteApiHandler(db: _db);
    noteTemplateApiHandler = NoteTemplateApiHandler(db: _db);
    learningStatApiHandler = LearningStatApiHandler(db: _db);
    noteTagApiHandler = NoteTagApiHandler(db: _db);
  }
}
