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
  final String deckName;

  const DeckChanged(this.deckName);

  @override
  List<Object> get props => [deckName];
}

class NoteTemplateChanged extends AddNewCardEvent {
  final String noteTemplateName;

  const NoteTemplateChanged(this.noteTemplateName);

  @override
  List<Object> get props => [noteTemplateName];
}

class CardTypesChanged extends AddNewCardEvent {
  final List<String> selectedCardTypes;

  const CardTypesChanged(this.selectedCardTypes);

  @override
  List<Object> get props => [selectedCardTypes];
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