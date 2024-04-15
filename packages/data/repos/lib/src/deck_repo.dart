import 'package:data_api/data_api.dart' as api;
import 'package:repos/src/models/deck_overview.dart';

class DeckRepo {
  api.DeckApi deckApi;
  api.CardApi cardApi;
  DeckRepo({required this.deckApi, required this.cardApi});

  Stream<List<DeckOverview>> getDeckOverviews() {
    var stream = deckApi.getDecks();
    return stream.asyncMap((decks) async {
      var cardCounts = await Future.wait(
          decks.map((deck) => cardApi.getNumCardsInDeck(deck.id)));
      return decks.indexed.map((ele) {
        var (index, deck) = ele;
        return DeckOverview(
            id: deck.id,
            name: deck.name,
            description: "TODO: Implement description",
            numberOfCards: cardCounts[index]);
      }).toList();
    });
  }

  Future<void> createNewDeck(String name, String description) async {
    await deckApi.createDeck(name, description);
  }
}
