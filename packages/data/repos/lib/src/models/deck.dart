import 'package:data_api/data_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Deck extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<Card> cards;

  const Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.cards,
  });

  @override
  List<Object> get props => [id, name, cards, description];
}
