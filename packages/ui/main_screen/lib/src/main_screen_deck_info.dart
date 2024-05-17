import 'package:equatable/equatable.dart';

class DeckInfo extends Equatable {
  final String id;
  final String name;
  final String deckDescription;

  const DeckInfo(
      {required this.id, required this.name, required this.deckDescription});

  @override
  List<Object> get props => [name, deckDescription];

  DeckInfo copyWith({String? id, String? name, String? deckDescription}) {
    return DeckInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      deckDescription: deckDescription ?? this.deckDescription,
    );
  }
}

