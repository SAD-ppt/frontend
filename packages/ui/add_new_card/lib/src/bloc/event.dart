import 'package:equatable/equatable.dart';

class AddNewCardEvent extends Equatable {
  const AddNewCardEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends AddNewCardEvent {
}

class SubmitCard extends AddNewCardEvent {
}

class DeckChanged extends AddNewCardEvent {
  final String deck;

  const DeckChanged(this.deck);

  @override
  List<Object> get props => [deck];
}

class NoteTemplateChanged extends AddNewCardEvent {
  final String noteTemplate;

  const NoteTemplateChanged(this.noteTemplate);

  @override
  List<Object> get props => [noteTemplate];
}

class CardTypesChanged extends AddNewCardEvent {
  final List<String> cardTypes;

  const CardTypesChanged(this.cardTypes);

  @override
  List<Object> get props => [cardTypes];
}

class RemoveTag extends AddNewCardEvent {
  final String tag;

  const RemoveTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class TagsTriggered extends AddNewCardEvent {
}