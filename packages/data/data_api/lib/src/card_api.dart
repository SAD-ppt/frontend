import '../data_api.dart';

abstract interface class CardApi {
  Stream<List<CardDetail>> getCardsStream({String? deckId, String? tagId}) =>
      throw NotSupportedError();
  Future<List<CardDetail>> getCards({String? deckId, String? tagId});
  Future<CardDetail> getCard(CardKey key);
  Future<Card> createCard(Card card);
  Future<Card> updateCard(Card card);
  Future<void> deleteCard(CardKey key);
  Future<int> getNumCardsInDeck(String deckId);
}
