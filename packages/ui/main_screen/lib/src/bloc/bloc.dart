import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:main_screen/main_screen.dart';
import 'package:main_screen/src/bloc/event.dart';
import 'package:main_screen/src/bloc/state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  List decks = ['Deck 1', 'Deck 2', 'Deck 3', 'Deck 4', 'Deck 5'];
  MainScreenState get initialState => MainScreenInitialState();
  
  MainScreenBloc() : super(MainScreenInitialState()) {
    on<MainScreenInitialEvent>(_onMainScreenInitialEvent);
    on<MainScreenAddNewDeckEvent>(_onMainScreenAddNewDeckEvent);
    on<MainScreenAddNewDeckPopupEvent>(_onMainScreenAddNewDeckPopupEvent);
  }

  void _onMainScreenInitialEvent(
    MainScreenInitialEvent event,
    Emitter<MainScreenState> emit,
  ) {
    emit(MainScreenInitialState());
  }

  void _onMainScreenAddNewDeckEvent(
    MainScreenAddNewDeckEvent event,
    Emitter<MainScreenState> emit,
  ) {
    if (decks.contains(event.deck)) {
      emit(MainScreenAddNewDeckErrorState(message: 'Deck already exists'));
    } else {
      decks.add(event.deck);
      emit(MainScreenAddNewDeckSuccessState(deck: event.deck));
    }
  }

  void _onMainScreenAddNewDeckPopupEvent(
    MainScreenAddNewDeckPopupEvent event,
    Emitter<MainScreenState> emit,
  ) {
    emit(MainScreenAddNewDeckPopupState());
  }
}
