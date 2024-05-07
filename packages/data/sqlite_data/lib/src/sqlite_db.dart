import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite_data/src/card_api_handler.dart';
import 'package:sqlite_data/src/card_template_api_handler.dart';
import 'package:sqlite_data/src/deck_api_handler.dart';
import 'package:sqlite_data/src/note_api_handler.dart';
import 'package:sqlite_data/src/note_template_api_handler.dart';

Future<Database> initializeDB() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return openDatabase(join(await getDatabasesPath(), 'data.db'), version: 1,
      onCreate: (db, version) async {
    // Create the tables if they don't exist
  });
}

class SqliteDB {
  Future<Database>? _db;
  CardApiHandler? cardApiHandler;
  CardTemplateApiHandler? cardTemplateApiHandler;
  DeckApiHandler? deckApiHandler;
  NoteApiHandler? noteApiHandler;
  NoteTemplateApiHandler? noteTemplateApiHandler;

  SqliteDB() {
    _db = initializeDB();
    cardApiHandler = CardApiHandler(db: _db!);
    cardTemplateApiHandler = CardTemplateApiHandler(db: _db!);
    deckApiHandler = DeckApiHandler(db: _db!);
    noteApiHandler = NoteApiHandler(db: _db!);
    noteTemplateApiHandler = NoteTemplateApiHandler(db: _db!);
  }
}
