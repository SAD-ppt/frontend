import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_data/src/card_api_handler.dart';
import 'package:sqlite_data/src/card_template_api_handler.dart';
import 'package:sqlite_data/src/deck_api_handler.dart';
import 'package:sqlite_data/src/note_api_handler.dart';
import 'package:sqlite_data/src/note_template_api_handler.dart';

class SqliteDB {
  Database? db;
  CardApiHandler? cardApiHandler;
  CardTemplateApiHandler? cardTemplateApiHandler;
  DeckApiHandler? deckApiHandler;
  NoteApiHandler? noteApiHandler;
  NoteTemplateApiHandler? noteTemplateApiHandler;

  SqliteDB() {
    _open();
    cardApiHandler = CardApiHandler(db: db!);
    cardTemplateApiHandler = CardTemplateApiHandler(db: db!);
    deckApiHandler = DeckApiHandler(db: db!);
    noteApiHandler = NoteApiHandler(db: db!);
    noteTemplateApiHandler = NoteTemplateApiHandler(db: db!);
  }
  Future<SqliteDB> _open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'data.db'),
        version: 1, onCreate: (db, version) async {
      // Create the tables if they don't exist
    });
    return SqliteDB();
  }
}
