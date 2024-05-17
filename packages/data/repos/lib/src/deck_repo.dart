import 'package:data_api/data_api.dart' as api;
import 'package:repos/src/models/deck_overview.dart';

extension DeckOverviewFromDeck on api.Deck {
  DeckOverview toDeckOverview() {
    return DeckOverview(
      id: id,
      name: name,
      description: description,
    );
  }
}

class DeckRepo {
  api.DeckApi deckApi;
  api.CardTemplateApi cardTemplateApi;
  api.CardApi cardApi;
  api.NoteApi noteApi;
  DeckRepo(
      {required this.deckApi,
      required this.cardApi,
      required this.cardTemplateApi,
      required this.noteApi});

  /// Should be called after the user has finished learning (review or test).
  Future<void> cleanDeckAfterLearningSession(String deckId) async {
    print("DECK ID" + deckId);
    if (deckId == "test") {
      await cardApi.deleteCards(deckId: deckId);
      await deckApi.deleteDeck(deckId);
    }
  }

  /// Create a test deck with all notes and card templates.
  Future<String> createTestDeck(
      String deckId, List<String> tags, List<String> cardTemplateIds) async {
    if (deckId == "test") {
      throw ArgumentError('Deck id "test" is reserved for testing.');
    }

    await deckApi.createDeck("Test Deck", "", deckId: "test");

    var cardTemplates = await cardTemplateApi.getCardTemplates(null);
    if (cardTemplateIds.isNotEmpty) {
      cardTemplates = cardTemplates
          .where(
              (template) => cardTemplateIds.contains(template.cardTemplate.id))
          .toList();
    }

    var notes = tags.isEmpty
        ? await noteApi.getNotes()
        : await noteApi.getNotes(tags: tags);
    for (var note in notes) {
      var noteId = note.note.id;
      for (var template in cardTemplates) {
        if (template.cardTemplate.noteTemplateId != note.note.noteTemplateId) {
          continue;
        }
        var card = api.Card(
          noteId: noteId,
          deckId: "test",
          cardTemplateId: template.cardTemplate.id,
        );
        await cardApi.createCard(card);
        print("CARD" + card.toString());
      }
    }
    print("NOTE" + notes.toString());
    return "test";
  }

  Future<List<DeckOverview>> getDeckOverviews() async {
    var stream = deckApi.getDecks();
    return stream
        .then((decks) => decks.map((deck) => deck.toDeckOverview()).toList());
  }

  Future<void> createNewDeck(String name, String description) async {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    await deckApi.createDeck(name, description);
  }
}
