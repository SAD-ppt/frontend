import 'package:data_api/data_api.dart';
import 'package:sqlite_data/sqlite_data.dart';

void main() {
  test("Test Init Database", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    // create new deck
    Deck deck = const Deck(
      id: '1',
      name: 'Deck 1',
      description: 'Deck 1 Description',
    );
    var deckCreated = await sqlDB.deckApiHandler.createDeck(deck.name, deck.description);
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
    // create new deck
    Deck deck = const Deck(
      id: '1',
      name: 'Deck 1',
      description: 'Deck 1 Description',
    );
    var deckCreated = await sqlDB.deckApiHandler.createDeck(deck.name, deck.description);
    // get deck
    await sqlDB.deckApiHandler.getDeck(deckCreated.id).then((value) {
      expect(value.id, deckCreated.id);
      expect(value.name, deck.name);
      expect(value.description, deck.description);
    });
    // update deck
    Deck updatedDeck = Deck(
      id: deckCreated.id,
      name: 'Deck 1 Updated',
      description: 'Deck 1 Description Updated',
    );
    await sqlDB.deckApiHandler.updateDeck(updatedDeck);
    // get deck
    await sqlDB.deckApiHandler.getDeck(updatedDeck.id).then((value) {
      expect(value.id, updatedDeck.id);
      expect(value.name, updatedDeck.name);
      expect(value.description, updatedDeck.description);
    });
    // create deck 2 and get all decks
    Deck deck2 = const Deck(
      id: '2',
      name: 'Deck 2',
      description: 'Deck 2 Description',
    );
    var deck2Created = await sqlDB.deckApiHandler.createDeck(deck2.name, deck2.description);
    await sqlDB.deckApiHandler.getDecks().then((value) {
      expect(value.length, 2);
      expect(value[0].id, updatedDeck.id);
      expect(value[0].name, updatedDeck.name);
      expect(value[0].description, updatedDeck.description);
      expect(value[1].id, deck2Created.id);
      expect(value[1].name, deck2.name);
      expect(value[1].description, deck2.description);
    });
    // delete deck 2
    await sqlDB.deckApiHandler.deleteDeck(deck2Created.id);
    // get all decks
    await sqlDB.deckApiHandler.getDecks().then((value) {
      expect(value.length, 1);
      expect(value[0].id, updatedDeck.id);
      expect(value[0].name, updatedDeck.name);
      expect(value[0].description, updatedDeck.description);
    });
    await sqlDB.close();
    await deleteDBFile();
  });

  test("Note Template API test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    // create new note template
    var noteTemplate1Name = 'Note Template 1';
    var note1FieldNames = ['Field 1', 'Field 2', 'Field 3'];
    var noteTemplate1 = await sqlDB.noteTemplateApiHandler.createNoteTemplate(noteTemplate1Name, note1FieldNames);
    // get note template
    var noteTemplateDetail = await sqlDB.noteTemplateApiHandler.getNoteTemplate(noteTemplate1.noteTemplate.id);
    expect(noteTemplateDetail.noteTemplate.id, noteTemplate1.noteTemplate.id);
    expect(noteTemplateDetail.noteTemplate.name, noteTemplate1Name);
    expect(noteTemplateDetail.fields.length, note1FieldNames.length);
    for (int i = 0; i < note1FieldNames.length; i++) {
      expect(noteTemplateDetail.fields[i].name, note1FieldNames[i]);
    }
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
