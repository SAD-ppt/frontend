import 'package:data_api/data_api.dart' as api;
import 'package:flutter/src/material/card.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repos/repos.dart';

import 'mocked_database.dart';

void main() {
  test("Create a new deck", () {
    final mockedDatabase = MockedDatabase();
    final deckRepo = DeckRepo(deckApi: mockedDatabase, cardApi: mockedDatabase);
    deckRepo.createNewDeck("deck1", "deck1 description");
    deckRepo.createNewDeck("deck2", "deck2 description");
    deckRepo.getDeckOverviews().then((value) {
      expect(value.length, 2);
    });
  });
}
