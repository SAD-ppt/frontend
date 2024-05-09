import 'package:data_api/data_api.dart' as api;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CardKey extends Equatable {
  final String deckId;
  final String noteId;
  final String cardTemplateId;

  const CardKey({
    required this.deckId,
    required this.noteId,
    required this.cardTemplateId,
  });

  @override
  List<Object> get props => [deckId, noteId, cardTemplateId];
}

extension ToCardKey on api.CardKey {
  CardKey toCardKey() {
    return CardKey(
      deckId: deckId,
      noteId: noteId,
      cardTemplateId: cardTemplateId,
    );
  }
}

extension ToCard on api.CardDetail {
  Card toCard() {
    return Card(
      key: CardKey(
          deckId: card.deckId,
          noteId: card.noteId,
          cardTemplateId: card.cardTemplateId),
      front: cardTemplate.frontFields
          .map((field) => (
                noteTemplate.fields[field.orderNumber].name,
                note.fields[field.orderNumber].value,
                true
              ))
          .toList(),
      back: cardTemplate.backFields
          .map((field) => (
                noteTemplate.fields[field.orderNumber].name,
                note.fields[field.orderNumber].value,
                false
              ))
          .toList(),
    );
  }
}

@immutable
class Card extends Equatable {
  final CardKey key;
  final List<(String name, String data, bool isFront)> front;
  final List<(String name, String data, bool isFront)> back;

  const Card({
    required this.key,
    required this.front,
    required this.back,
  });

  @override
  List<Object> get props => [front, back];
}
