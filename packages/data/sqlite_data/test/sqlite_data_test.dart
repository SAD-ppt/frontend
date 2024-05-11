import 'dart:io';

import 'package:data_api/data_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite_data/sqlite_data.dart';

void main() async {
  test("Test Init Database", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    Deck deck = const Deck(
      id: '1',
      name: 'Deck 1',
      description: 'Deck 1 Description',
    );
    var deckCreated =
        await sqlDB.deckApiHandler.createDeck(deck.name, deck.description);
    // get deck
    await sqlDB.deckApiHandler.getDeck(deckCreated.id).then((value) {
      expect(value.id, deckCreated.id);
      expect(value.name, deck.name);
      expect(value.description, deck.description);
    });
    await sqlDB.close();
    await deleteDBFile();
  });
  test("Deck API test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new deck
    Deck deck = const Deck(
      id: '1',
      name: 'Manual Deck 1',
      description: 'Manual Deck 1 Description',
    );
    var deckCreated =
        await sqlDB.deckApiHandler.createDeck(deck.name, deck.description);
    // get deck
    await sqlDB.deckApiHandler.getDeck(deckCreated.id).then((value) {
      expect(value.id, deckCreated.id);
      expect(value.name, deck.name);
      expect(value.description, deck.description);
    });
    // update deck
    var deckUpdated = await sqlDB.deckApiHandler.updateDeck(
      Deck(
        id: deckCreated.id,
        name: 'Manual Deck 1 Updated',
        description: 'Manual Deck 1 Description Updated',
      ),
    );
    // get deck
    await sqlDB.deckApiHandler.getDeck(deckUpdated.id).then((value) {
      expect(value.id, deckUpdated.id);
      expect(value.name, 'Manual Deck 1 Updated');
      expect(value.description, 'Manual Deck 1 Description Updated');
    });
    // delete deck
    await sqlDB.deckApiHandler.deleteDeck(deckCreated.id);
    // get all decks
    var decks = await sqlDB.deckApiHandler.getDecks();
    expect(decks.length, 3);
    await sqlDB.close();
    await deleteDBFile();
  });
  
}

Future<void> deleteDBFile() async {
  final dbFile = join(await getDatabasesPath(), 'data.db');
  if (File(dbFile).existsSync()) {
    File(dbFile).deleteSync();
  }
}

// Create mock data
Future<void> createMockData(SqliteDB sqliteDB) {
  return sqliteDB.db.execute("""
INSERT INTO Deck (UniqueID, Name, Description) VALUES 
    ('deck1', 'Deck 1', 'Description for Deck 1'),
    ('deck2', 'Deck 2', 'Description for Deck 2'),
    ('deck3', 'Deck 3', 'Description for Deck 3');

INSERT INTO NoteTemplate (UniqueID, Name) VALUES 
    ('template1', 'Template 1'),
    ('template2', 'Template 2'),
    ('template3', 'Template 3');

INSERT INTO NoteTemplateField (NoteTemplateID, OrderNumber, Name) VALUES 
    ('template1', 1, 'Field 1'),
    ('template1', 2, 'Field 2'),
    ('template2', 1, 'Field 1'),
    ('template2', 2, 'Field 2'),
    ('template3', 1, 'Field 1'),
    ('template3', 2, 'Field 2');

INSERT INTO Note (UniqueID, NoteTemplateID) VALUES 
    ('note1', 'template1'),
    ('note2', 'template2'),
    ('note3', 'template3');

INSERT INTO NoteField (NoteID, OrderNumber, RichDataText) VALUES 
    ('note1', 1, 'Text for Note 1 Field 1'),
    ('note1', 2, 'Text for Note 1 Field 2'),
    ('note2', 1, 'Text for Note 2 Field 1'),
    ('note2', 2, 'Text for Note 2 Field 2'),
    ('note3', 1, 'Text for Note 3 Field 1'),
    ('note3', 2, 'Text for Note 3 Field 2');

INSERT INTO CardTemplate (UniqueID, NoteTemplateID, Name) VALUES 
    ('card_template1', 'template1', 'Card Template 1'),
    ('card_template2', 'template2', 'Card Template 2'),
    ('card_template3', 'template3', 'Card Template 3');

INSERT INTO CardTemplateField (CardTemplateID, OrderNumber, NoteTemplateFieldID, Side) VALUES 
    ('card_template1', 1, 'template1_field1', 1),
    ('card_template1', 2, 'template1_field2', 1),
    ('card_template2', 1, 'template2_field1', 1),
    ('card_template2', 2, 'template2_field2', 1),
    ('card_template3', 1, 'template3_field1', 1),
    ('card_template3', 2, 'template3_field2', 1);

INSERT INTO Card (CardTemplateID, DeckID, NoteID) VALUES 
    ('card_template1', 'deck1', 'note1'),
    ('card_template2', 'deck2', 'note2'),
    ('card_template3', 'deck3', 'note3');

INSERT INTO Tag (Name, NoteID, Color) VALUES 
    ('Tag1', 'note1', 'Blue'),
    ('Tag2', 'note2', 'Red'),
    ('Tag3', 'note3', 'Green');

INSERT INTO LearningResult (DeckID, NoteID, CardTemplateID, Time, Result) VALUES 
    ('deck1', 'note1', 'card_template1', '2024-05-10 10:00:00', 'Pass'),
    ('deck2', 'note2', 'card_template2', '2024-05-10 11:00:00', 'Fail'),
    ('deck3', 'note3', 'card_template3', '2024-05-10 12:00:00', 'Pass');

INSERT INTO LearningStat (DeckID, NoteID, CardTemplateID) VALUES 
    ('deck1', 'note1', 'card_template1'),
    ('deck2', 'note2', 'card_template2'),
    ('deck3', 'note3', 'card_template3');
  """);
}
