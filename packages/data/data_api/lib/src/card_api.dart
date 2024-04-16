import 'package:uuid/uuid.dart';

import 'model/card.dart';
import 'model/note.dart';

abstract interface class CardApi {
  Stream<List<CardDetail>> getCardsOfDeck(Uuid deckId);
  Future<CardDetail> getCard(Uuid id);
  Future<CardDetail> getDeck(String id);
  Future<Card> createCard(Card card);
  Future<Card> updateCard(Card card);
  Future<void> deleteCard(Uuid id);
  Future<int> getNumCardsInDeck(Uuid id);
}
