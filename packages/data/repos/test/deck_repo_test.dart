import 'package:flutter_test/flutter_test.dart';

import 'package:repos/repos.dart';

import 'mocked_database.dart';

void main() {
  test("Create new deck", () async {
    final mockedDatabase = MockedDatabase();
    final deckRepo = DeckRepo(deckApi: mockedDatabase, cardApi: mockedDatabase);
    deckRepo.createNewDeck("deck1", "description1");
    await deckRepo.getDeckOverviews().then((value) {
      expect(value.length, 1);
      expect(value[0].name, "deck1");
      expect(value[0].description, "description1");
      expect(value[0].numberOfCards, null);
    });
  });

  test("Create new deck with empty name", () {
    final mockedDatabase = MockedDatabase();
    final deckRepo = DeckRepo(deckApi: mockedDatabase, cardApi: mockedDatabase);
    expect(
        () => deckRepo.createNewDeck("", "description1"), throwsArgumentError);
  });

  test("Create multiple decks", () async {
    final mockedDatabase = MockedDatabase();
    final deckRepo = DeckRepo(deckApi: mockedDatabase, cardApi: mockedDatabase);
    deckRepo.createNewDeck("deck1", "description1");
    deckRepo.createNewDeck("deck2", "description2");
    await deckRepo.getDeckOverviews().then((value) {
      expect(value.length, 2);
      final names = {"deck1", "deck2"};
      final descriptions = {"description1", "description2"};
      for (var deck in value) {
        expect(names.contains(deck.name), true);
        expect(descriptions.contains(deck.description), true);
      }
    });
  });
}
