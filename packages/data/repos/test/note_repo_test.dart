import 'package:flutter_test/flutter_test.dart';

import 'package:repos/repos.dart';
import 'mocked_database.dart';

void main() {
  test("Create new card and get tags", () async {
    final mockedDatabase = MockedDatabase();
    final deckRepo = DeckRepo(cardApi: mockedDatabase, deckApi: mockedDatabase);
    final noteTemplateRepo = NoteTemplateRepo(
        noteTemplateApi: mockedDatabase, cardTemplateApi: mockedDatabase);
    final noteRepo = NoteRepo(
        noteApi: mockedDatabase,
        noteTemplateApi: mockedDatabase,
        noteTagApi: mockedDatabase);

    noteTemplateRepo.createNewNoteTemplate("noteTemplate1", [
      "field1",
      "field2"
    ], [
      (["field1"], ["field2"]),
    ]);
    deckRepo.createNewDeck("deck1", "deck1");
    final deck = (await deckRepo.getDeckOverviews().first).first;
    final noteTemplate =
        (await noteTemplateRepo.getAllNoteTemplates().first).first;
    await noteRepo.createNote(
      deck.id,
      noteTemplate.id,
      ["value1", "value2"],
      tags: ["tag1"],
    );
    final notes = await noteRepo.getNotesOfDeck(deck.id).first;
    expect(notes.first.fields, [
      ("field1", "value1"),
      ("field2", "value2"),
    ]);
    expect(notes.first.tags, ["tag1"]);
    noteRepo.addTagToNote(
      notes.first.id,
      "tag2",
    );
    final updatedNotes = await noteRepo.getNotesOfDeck(deck.id).first;
    expect(updatedNotes.first.tags.toSet(), {"tag1", "tag2"});
  });
}
