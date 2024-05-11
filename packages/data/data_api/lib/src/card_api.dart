import '../data_api.dart';

abstract interface class CardApi {
  /// Get stream of cards in the deck. Optionally filter by deckId or tagId.
  Stream<List<CardDetail>> getCardsStream(
          {String? deckId, List<String>? tags}) =>
      throw NotSupportedError();

  /// Get list of cards in the deck. Optionally filter by deckId or tagId.
  Future<List<CardDetail>> getCards({String? deckId, List<String>? tags});

  /// Get card with the given key.
  Future<CardDetail> getCard(CardKey key);

  /// Create a new card.
  Future<Card> createCard(Card card);

  /// Update the card with the given key.
  Future<int?> getNumCardsInDeck(String deckId);
}
