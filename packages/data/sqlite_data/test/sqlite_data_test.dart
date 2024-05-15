import 'dart:io';

import 'package:data_api/data_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite_data/sqlite_data.dart';

String filename = 'anki_clone.db';

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
    await deleteDBFile(filename);
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
    await deleteDBFile(filename);
  });
  test("Note Template API test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new note template
    var noteTemplate1Name = 'Note Template 1';
    var note1FieldNames = ['Field 1', 'Field 2', 'Field 3'];
    var noteTemplate1 = await sqlDB.noteTemplateApiHandler
        .createNoteTemplate(noteTemplate1Name, note1FieldNames);
    // get note template
    await sqlDB.noteTemplateApiHandler
        .getNoteTemplate(
      noteTemplate1.noteTemplate.id,
    )
        .then((value) {
      expect(value.noteTemplate.id, noteTemplate1.noteTemplate.id);
      expect(value.noteTemplate.name, noteTemplate1Name);
      expect(value.fields.length, note1FieldNames.length);
      for (int i = 0; i < note1FieldNames.length; i++) {
        expect(value.fields[i].name, note1FieldNames[i]);
      }
    });
    // update note template
    await sqlDB.noteTemplateApiHandler.updateNoteTemplate(
      NoteTemplate(
        id: noteTemplate1.noteTemplate.id,
        name: 'Note Template 1 Updated',
      ),
    );
    // get note template
    await sqlDB.noteTemplateApiHandler
        .getNoteTemplate(
      noteTemplate1.noteTemplate.id,
    )
        .then((value) {
      expect(value.noteTemplate.id, noteTemplate1.noteTemplate.id);
      expect(value.noteTemplate.name, 'Note Template 1 Updated');
      expect(value.fields.length, note1FieldNames.length);
      for (int i = 0; i < note1FieldNames.length; i++) {
        expect(value.fields[i].name, note1FieldNames[i]);
      }
    });
    // delete note template
    await sqlDB.noteTemplateApiHandler.deleteNoteTemplate(
      noteTemplate1.noteTemplate.id,
    );
    // get all note templates
    var noteTemplates = await sqlDB.noteTemplateApiHandler.getNoteTemplates();
    expect(noteTemplates.length, 3);
    print(noteTemplates[0].fields);
    expect(noteTemplates[0].fields.length, 2);
    print(noteTemplates[1].fields);
    expect(noteTemplates[1].fields.length, 2);
    print(noteTemplates[2].fields);
    expect(noteTemplates[2].fields.length, 2);
    await sqlDB.close();
    await deleteDBFile(filename);
  });
  test("Note API Test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new note
    var note1 = await sqlDB.noteApiHandler.createNote(
      'deck1',
      'template1',
      ['Text for Note 1 Field 1', 'Text for Note 1 Field 2'],
    );
    // get note
    await sqlDB.noteApiHandler
        .getNote(
      note1.id,
    )
        .then((value) {
      expect(value.note.id, note1.id);
      expect(value.note.noteTemplateId, 'template1');
      expect(value.fields.length, 2);
      expect(value.fields[0].value, 'Text for Note 1 Field 1');
      expect(value.fields[1].value, 'Text for Note 1 Field 2');
    });
    // update note field
    await sqlDB.noteApiHandler.updateNoteField(
      note1.id,
      1,
      'Text for Note 1 Field 2 Updated',
    );
    // get note
    await sqlDB.noteApiHandler
        .getNote(
      note1.id,
    )
        .then((value) {
      expect(value.note.id, note1.id);
      expect(value.note.noteTemplateId, 'template1');
      expect(value.fields.length, 2);
      expect(value.fields[0].value, 'Text for Note 1 Field 1');
      expect(value.fields[1].value, 'Text for Note 1 Field 2 Updated');
    });
    // update note fields
    await sqlDB.noteApiHandler.updateNoteFields(
      note1.id,
      [
        NoteField(
          noteId: note1.id,
          orderNumber: 1,
          value: 'Text for Note 1 Field 2 Updated 2nd Time',
        ),
        NoteField(
          noteId: note1.id,
          orderNumber: 0,
          value: 'Text for Note 1 Field 1 Updated',
        ),
      ],
    );
    // get note
    await sqlDB.noteApiHandler
        .getNote(
      note1.id,
    )
        .then((value) {
      expect(value.note.id, note1.id);
      expect(value.note.noteTemplateId, 'template1');
      expect(value.fields.length, 2);
      expect(value.fields[0].value, 'Text for Note 1 Field 1 Updated');
      expect(value.fields[1].value, 'Text for Note 1 Field 2 Updated 2nd Time');
    });
    // delete note
    await sqlDB.noteApiHandler.deleteNote(
      note1.id,
    );
    // get all notes raw
    var notes = await sqlDB.noteApiHandler.getNotes();
    expect(notes.length, 3);
    // get notes for deck1
    notes = await sqlDB.noteApiHandler.getNotes(deckId: 'deck1');
    expect(notes.length, 1);
    // get notes for tag Tag1
    notes = await sqlDB.noteApiHandler.getNotes(tags: ['Tag1']);
    expect(notes.length, 1);
    // get notes for tags Tag1, Tag2 and Tag3
    notes = await sqlDB.noteApiHandler.getNotes(tags: ['Tag1', 'Tag2', 'Tag3']);
    expect(notes.length, 1);
    // get notes with Tag1 and deck2
    notes =
        await sqlDB.noteApiHandler.getNotes(deckId: 'deck2', tags: ['Tag1']);
    expect(notes.length, 0);
    await sqlDB.close();
    await deleteDBFile(filename);
  });
  test("Card Template API Test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new card template
    var cardTemplate1 =
        await sqlDB.cardTemplateApiHandler.createNewCardTemplate(
      'template1',
      'Card Template 1',
      [
        (CardSide.front, 1),
        (CardSide.back, 2),
      ],
    );
    // get card template
    await sqlDB.cardTemplateApiHandler
        .getCardTemplate(
      cardTemplate1.id,
    )
        .then((value) {
      expect(value?.cardTemplate.id, cardTemplate1.id);
      expect(value?.cardTemplate.noteTemplateId, 'template1');
      expect(value?.cardTemplate.name, 'Card Template 1');
      expect(value?.frontFields.length, 1);
      expect(value?.backFields.length, 1);
    });
    // add new field to card template
    await sqlDB.cardTemplateApiHandler
        .addNewFieldToCardTemplate(
      cardTemplate1.id,
      3,
      CardSide.back,
    )
        .then(
      (value) {
        expect(value.cardTemplateId, cardTemplate1.id);
        expect(value.orderNumber, 3);
        expect(value.side, CardSide.back);
      },
    );
    // get card template
    await sqlDB.cardTemplateApiHandler
        .getCardTemplate(
      cardTemplate1.id,
    )
        .then((value) {
      expect(value?.cardTemplate.id, cardTemplate1.id);
      expect(value?.cardTemplate.noteTemplateId, 'template1');
      expect(value?.cardTemplate.name, 'Card Template 1');
      expect(value?.frontFields.length, 1);
      expect(value?.backFields.length, 2);
    });
    // update field order
    await sqlDB.cardTemplateApiHandler
        .updateFieldOrder(cardTemplate1.id, 3, 4, CardSide.back);
    // get all card templates
    var cardTemplates = await sqlDB.cardTemplateApiHandler.getCardTemplates(
      'template1',
    );
    expect(cardTemplates.length, 2);
    // delete card template
    await sqlDB.cardTemplateApiHandler.deleteCardTemplate(
      cardTemplate1.id,
    );
    // get all card templates
    cardTemplates = await sqlDB.cardTemplateApiHandler.getCardTemplates(
      'template1',
    );
    expect(cardTemplates.length, 1);
    await sqlDB.close();
    await deleteDBFile(filename);
  });
  test("Card API Test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new card
    var card1 = await sqlDB.cardApiHandler.createCard(
      const Card(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
    );
    CardKey key = CardKey(
      deckId: card1.deckId,
      noteId: card1.noteId,
      cardTemplateId: card1.cardTemplateId,
    );
    // get card
    await sqlDB.cardApiHandler
        .getCard(
      key,
    )
        .then((value) {
      expect(value.card.deckId, 'deck1');
      expect(value.card.noteId, 'note2');
      expect(value.card.cardTemplateId, 'card_template2');
      expect(value.noteTemplateFields.length, 2);
      expect(value.cardTemplateFields.length, 2);
      expect(value.noteFields.length, 2);
    });
    // create another card
    await sqlDB.cardApiHandler.createCard(
      const Card(
        deckId: 'deck1',
        noteId: 'note3',
        cardTemplateId: 'card_template3',
      ),
    );
    // get number of cards in deck1
    await sqlDB.cardApiHandler.getNumCardsInDeck('deck1').then((value) {
      expect(value, 3);
    });
    // get all cards
    var cards = await sqlDB.cardApiHandler.getCards();
    expect(cards.length, 5);
    // get cards in deck1
    cards = await sqlDB.cardApiHandler.getCards(deckId: 'deck1');
    expect(cards.length, 3);
    // get cards have Tag1
    cards = await sqlDB.cardApiHandler.getCards(tags: ['Tag1']);
    expect(cards.length, 1);
    // get cards have Tag2
    cards = await sqlDB.cardApiHandler.getCards(tags: ['Tag2']);
    expect(cards.length, 3);
    // get cards have Tag1, Tag2 and Tag3
    cards = await sqlDB.cardApiHandler.getCards(tags: ['Tag1', 'Tag2', 'Tag3']);
    // get cards in deck1 have Tag2
    cards =
        await sqlDB.cardApiHandler.getCards(deckId: 'deck1', tags: ['Tag2']);
    expect(cards.length, 2);
    await sqlDB.close();
    await deleteDBFile(filename);
  });
  test("NoteTag API Test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new tag
    await sqlDB.noteTagApiHandler.createTag(
      'Tag4',
      color: 'Yellow',
    );
    // get tags
    var tags = await sqlDB.noteTagApiHandler.getTags(null);
    expect(tags.length, 4);
    // get tags for note1
    tags = await sqlDB.noteTagApiHandler.getTags('note1');
    expect(tags.length, 3);
    // get nums of tags for note1
    var numTags = await sqlDB.noteTagApiHandler.getNumTagsOfNote('note1');
    expect(numTags, 3);
    // add Tag4 to note1
    await sqlDB.noteTagApiHandler.addTagToNote(
      'note1',
      'Tag4',
    );
    // get tags for note1
    tags = await sqlDB.noteTagApiHandler.getTags('note1');
    expect(tags.length, 4);
    // update Tag4 color to Orange
    await sqlDB.noteTagApiHandler.updateTag(
      const NoteTag(name: "Tag4", noteId: "note1", color: "Orange"),
    );
    // get tags for note1
    tags = await sqlDB.noteTagApiHandler.getTags('note1');
    expect(tags.length, 4);
    expect(tags[3].color, 'Orange');
    // delete Tag4 from note1
    await sqlDB.noteTagApiHandler.removeTagFromNote(
      'note1',
      'Tag4',
    );
    // get tags for note1
    tags = await sqlDB.noteTagApiHandler.getTags('note1');
    expect(tags.length, 3);
    await sqlDB.close();
    await deleteDBFile(filename);
  });
  test("Learning Stat API Test", () async {
    SqliteDB sqlDB = SqliteDB();
    await sqlDB.init();
    await createMockData(sqlDB);
    // create new learning result
    await sqlDB.learningStatApiHandler.addLearningResult(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
      'Pass',
      time: DateTime.parse('2024-05-10 10:00:00'),
    );
    // create new learning stat
    await sqlDB.learningStatApiHandler.createLearningStat(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
    );
    // get learning stat
    await sqlDB.learningStatApiHandler
        .getLearningStatOfCard(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
    )
        .then((value) {
      expect(value?.learningStat.cardId.deckId, 'deck1');
      expect(value?.learningStat.cardId.noteId, 'note2');
      expect(value?.learningStat.cardId.cardTemplateId, 'card_template2');
      expect(value?.results.length, 1);
    });
    // create another learning result
    await sqlDB.learningStatApiHandler.addLearningResult(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
      'Fail',
      time: DateTime.parse('2024-05-10 10:30:00'),
    );
    // get learning result
    await sqlDB.learningStatApiHandler
        .getLearningStatOfCard(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
    )
        .then((value) {
      expect(value?.learningStat.cardId.deckId, 'deck1');
      expect(value?.learningStat.cardId.noteId, 'note2');
      expect(value?.learningStat.cardId.cardTemplateId, 'card_template2');
      expect(value?.results.length, 2);
    });
    // delete learning stat
    await sqlDB.learningStatApiHandler.deleteLearningStat(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
    );
    // get learning stat
    await sqlDB.learningStatApiHandler
        .getLearningStatOfCard(
      const CardKey(
        deckId: 'deck1',
        noteId: 'note2',
        cardTemplateId: 'card_template2',
      ),
    )
        .then((value) {
      expect(value, null);
    });
    await sqlDB.close();
    await deleteDBFile(filename);
  });
}

Future<void> deleteDBFile(String filename) async {
  final dbFile = join(await getDatabasesPath(), filename);
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

INSERT INTO NoteField (NoteID, OrderNumber, RichTextData) VALUES 
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

INSERT INTO CardTemplateField (CardTemplateID, OrderNumber, Side) VALUES 
    ('card_template1', 1, 1),
    ('card_template1', 2, 1),
    ('card_template2', 1, 1),
    ('card_template2', 2, 1),
    ('card_template3', 1, 1),
    ('card_template3', 2, 1);

INSERT INTO Card (CardTemplateID, DeckID, NoteID) VALUES 
    ('card_template1', 'deck1', 'note1'),
    ('card_template2', 'deck2', 'note2'),
    ('card_template3', 'deck3', 'note3');

INSERT INTO NoteTag (Name, NoteID, Color) VALUES 
    ('Tag1', 'note1', 'Blue'),
    ('Tag2', 'note1', 'Red'),
    ('Tag3', 'note1', 'Green'),
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
