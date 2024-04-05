import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

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
