import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/v4.dart';

import 'card_template.dart';
import 'note_template.dart';
import 'note.dart';

@immutable
class Card extends Equatable {
  final String deckId;
  final String id;
  final String cardTemplateId;
  final DateTime lastReviewed;
  final DateTime nextReview;

  const Card({
    required this.deckId,
    required this.id,
    required this.cardTemplateId,
    required this.lastReviewed,
    required this.nextReview,
  });

  @override
  List<Object> get props =>
      [id, deckId, cardTemplateId, lastReviewed, nextReview];
}

@immutable
class CardDetail extends Equatable {
  final Card card;
  final CardTemplateDetail cardTemplate;
  final NoteDetail note;
  final NoteTemplateDetail noteTemplate;

  get id => card.id;

  const CardDetail({
    required this.card,
    required this.cardTemplate,
    required this.note,
    required this.noteTemplate,
  });

  @override
  List<Object> get props => [card, cardTemplate, note, noteTemplate];
}
