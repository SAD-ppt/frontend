import 'package:uuid/uuid.dart';

import 'model/card.dart';

abstract interface class CardApi {
  Stream<List<Card>> getCards();
  Stream<List<Card>> getCardsOfDeck(Uuid deckId);
  Future<Card> getCard(Uuid id);
  Future<Card> getDeck(String id);
  Future<Card> createCard(Card card);
  Future<Card> updateCard(Card card);
  Future<void> deleteCard(String id);
}
