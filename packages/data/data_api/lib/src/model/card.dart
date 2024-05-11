import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'card_template.dart';
import 'note_template.dart';
import 'note.dart';

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

@immutable
class Card extends Equatable {
  final String deckId;
  final String noteId;
  final String cardTemplateId;

  const Card({
    required this.deckId,
    required this.noteId,
    required this.cardTemplateId,
  });

  @override
  List<Object> get props => [noteId, deckId, cardTemplateId];
}

@immutable
class CardDetail extends Equatable {
  final Card card;
  final List<NoteTemplateField> noteTemplateFields;
  final List<CardTemplateField> cardTemplateFields;
  final List<NoteField> noteFields;

  const CardDetail({
    required this.card,
    required this.noteTemplateFields,
    required this.cardTemplateFields,
    required this.noteFields,
  });

  @override
  List<Object> get props =>
      [card, noteTemplateFields, cardTemplateFields, noteFields];
}
