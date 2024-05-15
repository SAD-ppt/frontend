import 'package:equatable/equatable.dart';
import 'package:repos/repos.dart';

sealed class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}

class MainScreenDeckSelected extends MainScreenEvent {
  final String deckId;

  const MainScreenDeckSelected(this.deckId);

  @override
  List<Object> get props => [deckId];
}

class MainScreenAddButtonPressed extends MainScreenEvent {
  const MainScreenAddButtonPressed();
}

class MainScreenInitial extends MainScreenEvent {
  const MainScreenInitial();
}

class MainScreenDecksUpdated extends MainScreenEvent {
  final List<DeckOverview> decks;

  const MainScreenDecksUpdated(this.decks);

  @override
  List<Object> get props => [decks];
}

class MainScreenAddNewDeck extends MainScreenEvent {}
class MainScreenAddNewDeckSubmit extends MainScreenEvent {
  final String deckName;
  final String deckDescription;

  const MainScreenAddNewDeckSubmit({
    required this.deckName,
    required this.deckDescription,
  });

  @override
  List<Object> get props => [deckName, deckDescription];
}

class MainScreenAddNewDeckCancel extends MainScreenEvent {
  const MainScreenAddNewDeckCancel();
}

class MainScreenSearch extends MainScreenEvent {
  final String query;

  const MainScreenSearch(this.query);

  @override
  List<Object> get props => [query];
}
