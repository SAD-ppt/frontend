import 'package:equatable/equatable.dart';

sealed class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}

class MainScreenInitialEvent extends MainScreenEvent {
}

class MainScreenAddNewDeckEvent extends MainScreenEvent {
  final String deck;

  MainScreenAddNewDeckEvent({required this.deck});

  @override
  List<Object> get props => [deck];
}

class MainScreenAddNewDeckPopupEvent extends MainScreenEvent {
}