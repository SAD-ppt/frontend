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
  api.CardApi cardApi;
  DeckRepo({required this.deckApi, required this.cardApi});

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
