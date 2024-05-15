import 'package:equatable/equatable.dart';
import 'package:main_screen/src/main_screen_deck_info.dart';

enum MainScreenStatus {
  initial,
  loading,
  loaded,
  error,
}

enum MainScreenStep {
  mainScreen,
  addButtonPressed,
  addNewDeckPopup,
  addNewCardPopup,
  addNewTemplatePopup,
}

class MainScreenState extends Equatable {
  final MainScreenStatus status;
  final MainScreenStep currentStep;
  final List<DeckInfo> decks;
  final List<DeckInfo> filteredDecks;

  const MainScreenState({
    this.decks = const [],
    this.filteredDecks = const [],
    this.status = MainScreenStatus.initial,
    this.currentStep = MainScreenStep.mainScreen,
  });

  @override
  List<Object> get props => [decks, filteredDecks, currentStep, status];

  MainScreenState copyWith({
    MainScreenStatus? status,
    MainScreenStep? currentStep,
    List<DeckInfo>? decks,
    List<DeckInfo>? filteredDecks,
  }) {
    return MainScreenState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      decks: decks ?? this.decks,
      filteredDecks: filteredDecks ?? this.filteredDecks,
    );
  }

  MainScreenState addDeck(DeckInfo deck) {
    return copyWith(decks: [...decks, deck]);
  }
}
