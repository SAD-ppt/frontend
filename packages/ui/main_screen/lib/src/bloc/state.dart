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

  const MainScreenState({
    this.decks = const [
      DeckInfo(name: 'Deck 1', deckDescription: 'Deck 1 description'),
      DeckInfo(name: 'Deck 2', deckDescription: 'Deck 2 description'),
      DeckInfo(name: 'Deck 3', deckDescription: 'Deck 3 description'),
    ],
    this.status = MainScreenStatus.initial,
    this.currentStep = MainScreenStep.mainScreen,
  });

  @override
  List<Object> get props => [decks, currentStep, status];

  MainScreenState copyWith({
    MainScreenStatus? status,
    MainScreenStep? currentStep,
    List<DeckInfo>? decks,
  }) {
    return MainScreenState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      decks: decks ?? this.decks,
    );
  }

  MainScreenState addDeck(DeckInfo deck) {
    return copyWith(decks: [...decks, deck]);
  }
}
