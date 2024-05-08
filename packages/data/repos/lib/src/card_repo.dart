import 'package:repos/src/models/card.dart';
import 'package:uuid/uuid.dart';
import 'package:data_api/data_api.dart' as api;
import 'dart:math';

import 'package:uuid/v4.dart';

class CardRepo {
  final api.CardApi cardApi;
  final api.CardTemplateApi cardTemplateApi;

  CardRepo({required this.cardApi, required this.cardTemplateApi});

  /// Get the next card for review in the deck with the given [deckId].
  /// The card will be the first card in the deck that is due for review.
  Future<Card> nextCardForReview(String deckId) async {
    var cards = await cardApi.getCardsOfDeck(deckId).first;
    Random random = Random();
    var selectedCard = cards[random.nextInt(cards.length)];
    return _cardFromApiCard(selectedCard);
  }

  Card _cardFromApiCard(api.CardDetail card) {
    var front = card.cardTemplate.frontFields
        .map((field) => (
              card.noteTemplate.fields[field.orderNumber].name,
              card.note.fields[field.orderNumber].value,
              true
            ))
        .toList();
    var back = card.cardTemplate.backFields
        .map((field) => (
              card.noteTemplate.fields[field.orderNumber].name,
              card.note.fields[field.orderNumber].value,
              false
            ))
        .toList();
    return Card(
      front: front,
      back: back,
    );
  }

  /// Create a new card with the given [deckId] and [cardTemplateId].
  Stream<List<Card>> getCardsOfDeck(String deckId) {
    return cardApi
        .getCardsOfDeck(deckId)
        .asyncMap((List<api.CardDetail> cards) {
      return cards.map(_cardFromApiCard).toList();
    });
  }
}
