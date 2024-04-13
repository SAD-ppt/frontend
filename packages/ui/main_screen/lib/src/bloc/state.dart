import 'package:equatable/equatable.dart';

sealed class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object> get props => [];
}

class MainScreenInitialState extends MainScreenState {
}

class MainScreenAddNewDeckPopupState extends MainScreenState {
}

class MainScreenAddNewDeckErrorState extends MainScreenState {
  final String message;

  MainScreenAddNewDeckErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class MainScreenAddNewDeckSuccessState extends MainScreenState {
  final String deck;

  MainScreenAddNewDeckSuccessState({required this.deck});

  @override
  List<Object> get props => [deck];
}

class MainScreenReadingState extends MainScreenState {
}

class MainScreenReadingErrorState extends MainScreenState {
  final String message;

  MainScreenReadingErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class MainScreenReadingSuccessState extends MainScreenState {
  final List<String> data;

  MainScreenReadingSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}
