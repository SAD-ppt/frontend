import 'package:equatable/equatable.dart';

class TestingSetupEvent extends Equatable {
  const TestingSetupEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends TestingSetupEvent {
  final String deckId;

  const InitialEvent(this.deckId);

  @override
  List<Object> get props => [deckId];
}

class SelectedTagsChanged extends TestingSetupEvent {
  final List<String> selectedTags;

  const SelectedTagsChanged(this.selectedTags);

  @override
  List<Object> get props => [selectedTags];
}

class SelectedCardTypeChanged extends TestingSetupEvent {
  final List<String> selectedCardType;

  const SelectedCardTypeChanged(this.selectedCardType);

  @override
  List<Object> get props => [selectedCardType];
}

class StartEvent extends TestingSetupEvent {
}