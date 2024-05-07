import 'model/card.dart';

abstract interface class CardApi {
  Stream<List<CardDetail>> getCardsOfDeck(String deckId);
  Future<CardDetail> getCard(String id);
  Future<Card> createCard(Card card);
  Future<Card> updateCard(Card card);
  Future<void> deleteCard(String id);
  Future<int> getNumCardsInDeck(String id);
  Future<List<CardDetail>> getCardsOfDeckByTag(String deckId, String tagId);
}
