import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:repos/repos.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  DeckRepo deckRepo;

  MainScreenBloc({required this.deckRepo}) : super(const MainScreenState()) {
    deckRepo.getDeckOverviews().then((decks) {
      add(MainScreenDecksUpdated(decks));
    });
    on<MainScreenInitial>(_onInitial);
    on<MainScreenDecksUpdated>(_onDecksUpdated);
    on<MainScreenAddButtonPressed>(_onAddButtonPressed);
    on<MainScreenAddNewDeck>(_onAddNewDeck);
    on<MainScreenDeckSelected>(_onDeckSelected);
    on<MainScreenAddNewDeckSubmit>(_onAddNewDeckSubmit);
    on<MainScreenAddNewDeckCancel>(_onAddNewDeckCancel);
  }

  FutureOr<void> _onInitial(
    MainScreenInitial event,
    Emitter<MainScreenState> emit,
  ) {
    // Set the status to loaded
    emit(state.copyWith(status: MainScreenStatus.loaded));
  }

  FutureOr<void> _onAddButtonPressed(
    MainScreenAddButtonPressed event,
    Emitter<MainScreenState> emit,
  ) {
    emit(state.copyWith(currentStep: MainScreenStep.addButtonPressed));
  }

  FutureOr<void> _onDecksUpdated(
    MainScreenDecksUpdated event,
    Emitter<MainScreenState> emit,
  ) {
    var newDecks = List<DeckInfo>.empty();
    var decks = event.decks;
    // Map the decks to DeckInfo
    for (var deck in decks) {
      newDecks.add(DeckInfo(
        name: deck.name,
        deckDescription: deck.description,
      ));
    }
    emit(state.copyWith(decks: newDecks));
  }

  FutureOr<void> _onAddNewDeck(
    MainScreenAddNewDeck event,
    Emitter<MainScreenState> emit,
  ) {
    emit(state.copyWith(currentStep: MainScreenStep.addNewDeckPopup));
  }

  FutureOr<void> _onAddNewDeckSubmit(
    MainScreenAddNewDeckSubmit event,
    Emitter<MainScreenState> emit,
  ) {
    emit(state.copyWith(currentStep: MainScreenStep.mainScreen, decks: [
      ...state.decks,
      DeckInfo(
        name: event.deckName,
        deckDescription: event.deckDescription,
      ),
    ]));
  }

  FutureOr<void> _onAddNewDeckCancel(
    MainScreenAddNewDeckCancel event,
    Emitter<MainScreenState> emit,
  ) {
    emit(state.copyWith(currentStep: MainScreenStep.mainScreen));
  }

  FutureOr<void> _onDeckSelected(
    MainScreenDeckSelected event,
    Emitter<MainScreenState> emit,
  ) {
    throw UnimplementedError();
  }
}
