import 'package:equatable/equatable.dart';

sealed class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}

class MainScreenAddButtonPressed extends MainScreenEvent {
  const MainScreenAddButtonPressed();
}

class MainScreenInitial extends MainScreenEvent {
  const MainScreenInitial();
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
