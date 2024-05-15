import 'package:equatable/equatable.dart';

sealed class LearningScreenEvent extends Equatable {
  const LearningScreenEvent();

  @override
  List<Object> get props => [];
}

final class InitialEvent extends LearningScreenEvent {
  final String deckId;
  const InitialEvent({required this.deckId});
}

final class LoadCardEvent extends LearningScreenEvent {
  const LoadCardEvent();
}

final class RevealCardEvent extends LearningScreenEvent {
  const RevealCardEvent();
}

final class SubmitButtonsPressed extends LearningScreenEvent {
  final String difficulty;
  const SubmitButtonsPressed({required this.difficulty});
}