import 'package:uuid/uuid.dart';

import 'model/deck.dart';

abstract interface class DeckApi {
  Stream<List<Deck>> getDecks();
  Future<Deck> getDeck(Uuid id);
  Future<Deck> createDeck(Deck deck);
  Future<Deck> updateDeck(Deck deck);
  Future<void> deleteDeck(Uuid id);
}
