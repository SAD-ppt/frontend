import 'package:flutter_test/flutter_test.dart';

import 'package:repos/repos.dart';
import 'mocked_database.dart';

Future<MockedDatabase> makeDb() async {
  final mockedDatabase = MockedDatabase();
  final deckRepo = DeckRepo(cardApi: mockedDatabase, deckApi: mockedDatabase);
  final noteTemplateRepo = NoteTemplateRepo(
      noteTemplateApi: mockedDatabase, cardTemplateApi: mockedDatabase);
  final noteRepo = NoteRepo(
      cardTemplateApi: mockedDatabase,
      cardApi: mockedDatabase,
      noteApi: mockedDatabase,
      noteTemplateApi: mockedDatabase,
      noteTagApi: mockedDatabase);

  noteTemplateRepo.createNewNoteTemplate("noteTemplate1", [
    "field1",
    "field2"
  ], [
    (["field1"], ["field2"]),
  ]);

  noteRepo.createNewTag("tag1");
  noteRepo.createNewTag("tag2");
  noteRepo.createNewTag("tag3");

  deckRepo.createNewDeck("deck1", "deck1's description");

  final deck = (await deckRepo.getDeckOverviews()).first;
  final noteTemplate = (await noteTemplateRepo.getAllNoteTemplates()).first;
  await noteRepo.createNewTag("tag1");
  await noteRepo.createNewTag("tag2");
  await noteRepo.createNote(
    deck.id,
    noteTemplate.id,
    ["value1", "value2"],
    tags: ["tag1"],
  );

  await noteRepo.createNote(
    deck.id,
    noteTemplate.id,
    ["value3", "value4"],
    tags: ["tag2"],
  );

  await noteRepo.createNote(
    deck.id,
    noteTemplate.id,
    ["value5", "value6"],
    tags: ["tag3"],
  );

  return Future.value(mockedDatabase);
}

void main() {
  test("Learn card", () async {
    final mockedDatabase = await makeDb();
    final cardRepo = CardRepo(
        cardApi: mockedDatabase,
        cardTemplateApi: mockedDatabase,
        learningStatApi: mockedDatabase);

    final nextCard = await cardRepo.nextCardForReview("deck1");
    expect(nextCard, isNotNull);
    await cardRepo.learnCard(nextCard!, "good");
    final nextCard2 = await cardRepo.nextCardForReview("deck1");
  });
  test("Create new card and get tags", () async {
    final mockedDatabase = MockedDatabase();
    final deckRepo = DeckRepo(cardApi: mockedDatabase, deckApi: mockedDatabase);
    final noteTemplateRepo = NoteTemplateRepo(
        noteTemplateApi: mockedDatabase, cardTemplateApi: mockedDatabase);
    final noteRepo = NoteRepo(
        cardTemplateApi: mockedDatabase,
        cardApi: mockedDatabase,
        noteApi: mockedDatabase,
        noteTemplateApi: mockedDatabase,
        noteTagApi: mockedDatabase);

    final cardRepo = CardRepo(
        cardApi: mockedDatabase,
        cardTemplateApi: mockedDatabase,
        learningStatApi: mockedDatabase);

    noteTemplateRepo.createNewNoteTemplate("noteTemplate1", [
      "field1",
      "field2"
    ], [
      (["field1"], ["field2"]),
    ]);
    deckRepo.createNewDeck("deck1", "deck1");
    final deck = (await deckRepo.getDeckOverviews()).first;
    final noteTemplate = (await noteTemplateRepo.getAllNoteTemplates()).first;
    await noteRepo.createNewTag("tag1");
    await noteRepo.createNewTag("tag2");
    await noteRepo.createNote(
      deck.id,
      noteTemplate.id,
      ["value1", "value2"],
      tags: ["tag1"],
    );
    final notes = await noteRepo.getNotesOfDeck(deck.id);
    expect(notes.first.fields, [
      ("field1", "value1"),
      ("field2", "value2"),
    ]);
    expect(notes.first.tags, ["tag1"]);
    noteRepo.addTagToNote(
      notes.first.id,
      "tag2",
    );
    final updatedNotes = await noteRepo.getNotesOfDeck(deck.id);
    expect(updatedNotes.first.tags.toSet(), {"tag1", "tag2"});

    final cards = await cardRepo.getCardsOfDeck(deck.id);
    expect(cards.length, 1);
    expect(cards.first.front, [
      ("field1", "value1", true),
    ]);
    expect(cards.first.back, [
      ("field2", "value2", false),
    ]);
  });
}
