import 'package:uuid/uuid.dart';

import 'model/card.dart';

abstract interface class CardApi {
  Stream<List<CardDetail>> getCardsOfDeck(Uuid deckId);
  Future<CardDetail> getCard(Uuid id);
  Future<Card> createCard(Card card);
  Future<Card> updateCard(Card card);
  Future<void> deleteCard(Uuid id);
  Future<int> getNumCardsInDeck(Uuid id);
}
