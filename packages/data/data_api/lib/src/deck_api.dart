import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'model/deck.dart';

abstract interface class DeckApi {
  Stream<List<Deck>> getDecks();
  Stream<List<(Deck deck, Card card)>> getDecksAndCards();
  Future<Deck> getDeck(Uuid id);
  Future<Deck> getDeckAndCards(Uuid id);
  Future<Deck> createDeck(Deck deck);
  Future<Deck> updateDeck(Deck deck);
  Future<void> deleteDeck(Uuid id);
}
