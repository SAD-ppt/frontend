import 'package:repos/src/models/card.dart';
import 'package:data_api/data_api.dart' as api;
import 'dart:math';

class CardRepo {
  final api.CardApi cardApi;
  final api.LearningStatApi learningStatApi;
  final api.CardTemplateApi cardTemplateApi;
  final Map<String, List<(Card, api.LearningStatDetail)>?> _cardsDueForReview =
      {};

  CardRepo(
      {required this.cardApi,
      required this.cardTemplateApi,
      required this.learningStatApi});

  List<(Card, api.LearningStatDetail)> _getCardNeedReview(
      List<(Card, api.LearningStatDetail)> processedCards) {
    final cardsDueForReview = processedCards.where((pair) {
      var learningStat = pair.$2;
      if (learningStat.results.isEmpty) {
        return true;
      }
      var lastResult = learningStat.results.last;
      var nextReviewTime = lastResult.time.add(
        Duration(days: pow(2, learningStat.results.length - 1).toInt()),
      );
      final now = DateTime.now();
      return now.isAfter(nextReviewTime);
    }).toList();
    return cardsDueForReview;
  }

  Future<void> _updateCardsDueForReview(String deckId) async {
    final cards = await cardApi.getCards(deckId: deckId);
    final cardsWithLearningStats = await Future.wait(cards.map((card) async {
      final cardDetail = _cardFromApiCard(card);
      final key = api.CardKey(
          deckId: deckId,
          noteId: card.card.noteId,
          cardTemplateId: card.card.cardTemplateId);
      var learningStat = await learningStatApi.getLearningStatOfCard(key);
      return (cardDetail, learningStat!);
    }));
    final cardsDueForReview = _getCardNeedReview(cardsWithLearningStats);
    _cardsDueForReview[deckId] = cardsDueForReview;
  }

  /// Get the next card for review in the deck with the given [deckId].
  /// The card will be the first card in the deck that is due for review.
  /// If there are no cards due for review, return null.
  Future<Card?> nextCardForReview(String deckId) async {
    if (_cardsDueForReview[deckId] == null) {
      await _updateCardsDueForReview(deckId);
    }
    var cards = _cardsDueForReview[deckId]!;
    if (cards.isNotEmpty) {
      return cards.first.$1;
    }
    return null;
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

  /// Get all cards in the deck with the given [deckId].
  Future<List<Card>> getCardsOfDeck(String deckId) {
    return cardApi
        .getCards(deckId: deckId)
        .then((cards) => cards.map(_cardFromApiCard).toList());
  }
}
