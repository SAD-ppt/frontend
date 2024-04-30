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

// class RemoveTag extends AddNewCardEvent {
//   final List<String> tagsList;

//   const RemoveTag(this.tagsList);

//   @override
//   List<Object> get props => [tagsList];
// }

// class AddTag extends AddNewCardEvent {
//   final List<String> tagsList;

//   const AddTag(this.tagsList);

//   @override
//   List<Object> get props => [tagsList];
// }

class TagsChanged extends AddNewCardEvent {
  final List<String> tagsList;

  const TagsChanged(this.tagsList);

  @override
  List<Object> get props => [tagsList];
}

class AddNewAvailableTag extends AddNewCardEvent {
  final String tag;

  const AddNewAvailableTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class TagsTriggered extends AddNewCardEvent {
}