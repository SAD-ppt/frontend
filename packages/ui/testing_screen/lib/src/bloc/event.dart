import 'package:equatable/equatable.dart';

class TestingScreenEvent extends Equatable {
  const TestingScreenEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends TestingScreenEvent {
  final String deckId;
  const InitialEvent({required this.deckId});

  @override
  List<Object> get props => [deckId];
}

class FinishEvent extends TestingScreenEvent {
  final String deckId;
  const FinishEvent({required this.deckId});

  @override
  List<Object> get props => [deckId];
}

class RevealCardEvent extends TestingScreenEvent {
  const RevealCardEvent();
}

class SubmitButtonsPressed extends TestingScreenEvent {
  final String result;
  const SubmitButtonsPressed({required this.result});
}