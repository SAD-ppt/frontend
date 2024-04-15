import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:main_screen/src/bloc/event.dart';
import 'package:main_screen/src/bloc/state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  MainScreenBloc() : super(const MainScreenState()) {
    on<MainScreenInitial>(_onInitial);
    on<MainScreenAddButtonPressed>(_onAddButtonPressed);
    on<MainScreenAddNewDeck>(_onAddNewDeck);
    on<MainScreenAddNewDeckSubmit>(_onAddNewDeckSubmit);
    on<MainScreenAddNewDeckCancel>(_onAddNewDeckCancel);
  }

  FutureOr<void> _onInitial(
    MainScreenInitial event,
    Emitter<MainScreenState> emit,
  ) {
    emit(state.copyWith(status: MainScreenStatus.loaded));
  }

  FutureOr<void> _onAddButtonPressed(
    MainScreenAddButtonPressed event,
    Emitter<MainScreenState> emit,
  ) {
    emit(state.copyWith(currentStep: MainScreenStep.addButtonPressed));
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
}
