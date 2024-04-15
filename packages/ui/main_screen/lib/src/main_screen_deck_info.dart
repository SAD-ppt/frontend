import 'package:equatable/equatable.dart';

class DeckInfo extends Equatable {
  final String name;
  final String deckDescription;

  const DeckInfo({required this.name, required this.deckDescription});

  @override
  List<Object> get props => [name, deckDescription];

  DeckInfo copyWith({String? name, String? deckDescription}) {
    return DeckInfo(
      name: name ?? this.name,
      deckDescription: deckDescription ?? this.deckDescription,
    );
  }
}