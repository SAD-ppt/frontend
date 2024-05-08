import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// A deck overview is a summary of a deck that includes the deck's id, name,
/// description, and the number of cards in the deck. Used to display a list of
/// decks to the user.
@immutable
class DeckOverview extends Equatable {
  final String id;
  final String name;
  final String description;
  final int? numberOfCards;

  const DeckOverview({
    required this.id,
    required this.name,
    required this.description,
    this.numberOfCards,
  });

  @override
  List<Object> get props => [id, name, description];
}
