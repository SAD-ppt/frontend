import 'package:repos/repos.dart';
import 'package:repos/src/models/card.dart';
import 'package:data_api/data_api.dart' as api;
import 'dart:math';

class CardRepo {
  final api.CardApi cardApi;
  final api.NoteApi noteApi;
  final api.LearningStatApi learningStatApi;
  final api.CardTemplateApi cardTemplateApi;
  final Map<String, List<(Card, api.LearningStatDetail?)>?> _cardsDueForReview =
      {};

  CardRepo(
      {required this.cardApi,
      required this.noteApi,
      required this.cardTemplateApi,
      required this.learningStatApi});

  List<(Card, api.LearningStatDetail?)> _getCardNeedReview(
      List<(Card, api.LearningStatDetail?)> processedCards) {
    final cardsDueForReview = processedCards.where((pair) {
      final learningStat = pair.$2;
      if (learningStat == null) {
        return true;
      }
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
      final cardDetail = card.toCard();
      final key = api.CardKey(
          deckId: deckId,
          noteId: card.card.noteId,
          cardTemplateId: card.card.cardTemplateId);
      try {
        final learningStat = await learningStatApi.getLearningStatOfCard(key);
        return (cardDetail, learningStat);
      } catch (e) {
        return (cardDetail, null);
      }
    }));
    final cardsDueForReview = _getCardNeedReview(cardsWithLearningStats);
    _cardsDueForReview[deckId] = cardsDueForReview;
  }

  Future<void> learnCard(Card card, String result, {DateTime? time}) async {
    final key = api.CardKey(
        deckId: card.key.deckId,
        noteId: card.key.noteId,
        cardTemplateId: card.key.cardTemplateId);
    // First check if the learning stat exists, if not create it.
    try {
      await learningStatApi.getLearningStatOfCard(key);
    } catch (e) {
      await learningStatApi.createLearningStat(key);
      await learningStatApi.getLearningStatOfCard(key);
    }
    await learningStatApi.addLearningResult(key, result,
        time: time ?? DateTime.now());
    await _updateCardsDueForReview(card.key.deckId);
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

  /// Get all cards in the deck with the given [deckId].
  Future<List<Card>> getCardsOfDeck(String deckId) {
    return cardApi
        .getCards(deckId: deckId)
        .then((cards) => cards.map((cd) => cd.toCard()).toList());
  }

  /// Get all card overviews. Optionally filter using [cardTemplateName] and [tags].
  Future<List<CardOverview>> getCardOverviews(
      {String? cardTemplateName, List<String>? tags}) async {
    final cards = await cardApi.getCards(tags: tags);
    return await Future.wait(cards.map((card) async {
      final cardTemplate =
          await cardTemplateApi.getCardTemplate(card.card.cardTemplateId);
      if (cardTemplate == null) {
        throw Exception('Card template not found');
      }
      final note = await noteApi.getNote(card.card.noteId);
      if (note == null) {
        throw Exception('Note not found');
      }
      final tags = note.tags.map((t) => t.name).toList();
      return CardOverview(
        id: CardKey(
            deckId: card.card.deckId,
            noteId: card.card.noteId,
            cardTemplateId: card.card.cardTemplateId),
        cardTemplateName: cardTemplate.cardTemplate.name,
        tags: tags,
      );
    }));
  }

  /// Get all CardOverviews of the deck with the given [deckId].
  Future<List<CardOverview>> getCardOverviewsOfDeck(String deckId) async {
    final cards = await cardApi.getCards(deckId: deckId);
    return await Future.wait(cards.map((card) async {
      final cardTemplate =
          await cardTemplateApi.getCardTemplate(card.card.cardTemplateId);
      if (cardTemplate == null) {
        throw Exception('Card template not found');
      }
      final note = await noteApi.getNote(card.card.noteId);
      if (note == null) {
        throw Exception('Note not found');
      }
      final tags = note.tags.map((t) => t.name).toList();
      return CardOverview(
        id: CardKey(
            deckId: card.card.deckId,
            noteId: card.card.noteId,
            cardTemplateId: card.card.cardTemplateId),
        cardTemplateName: cardTemplate.cardTemplate.name,
        tags: tags,
      );
    }));
  }
}
