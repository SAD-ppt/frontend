import '../data_api.dart';

abstract interface class DeckApi {
  Stream<List<Deck>> getDecks();
  Stream<List<(Deck deck, Card card)>> getDecksAndCards();
  Future<Deck> getDeck(String id);
  Future<Deck> getDeckAndCards(String id);
  Future<Deck> createDeck(String name, String description);
  Future<Deck> updateDeck(Deck deck);
  Future<void> deleteDeck(String id);
}
