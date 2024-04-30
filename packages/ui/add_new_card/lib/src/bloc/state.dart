import 'package:equatable/equatable.dart';

enum Status {
  initial,
  loading,
  loaded,
  addSuccess,
  addError,
  adding,
  changing,
  changed,
  tagsTriggered
}

class AddNewCardState extends Equatable {
  final Status status;
  final String deck;
  final String noteTemplate;
  final List<String> deckList;
  final List<String> noteTemplateList;
  final List<String> cardTypes;
  final List<String> fieldNames;
  final List<String> tagsList;
  final List<String> availableTagsList;
  final List<String> availableDecks;
  final List<String> availableNoteTemplates;
  final List<String> availableCardTypes;

  const AddNewCardState({
    this.status = Status.initial,
    this.deck = '',
    this.noteTemplate = '',
    this.deckList = const [],
    this.noteTemplateList = const [],
    this.cardTypes = const [],
    this.fieldNames = const [],
    this.tagsList = const [],
    this.availableTagsList = const [],
    this.availableDecks = const [],
    this.availableNoteTemplates = const [],
    this.availableCardTypes = const [],
  });

  @override
  List<Object> get props => [
        status,
        deck,
        noteTemplate,
        cardTypes,
        fieldNames,
        tagsList,
        availableTagsList,
        availableDecks,
        availableNoteTemplates,
        availableCardTypes,
      ];

  AddNewCardState copyWith({
    Status? status,
    String? deck,
    String? noteTemplate,
    List<String>? cardTypes,
    List<String>? fieldNames,
    List<String>? tagsList,
    List<String>? availableTagsList,
    List<String>? availableDecks,
    List<String>? availableNoteTemplates,
    List<String>? availableCardTypes,
  }) {
    return AddNewCardState(
      status: status ?? this.status,
      deck: deck ?? this.deck,
      noteTemplate: noteTemplate ?? this.noteTemplate,
      cardTypes: cardTypes ?? this.cardTypes,
      fieldNames: fieldNames ?? this.fieldNames,
      tagsList: tagsList ?? this.tagsList,
      availableTagsList: availableTagsList ?? this.availableTagsList,
      availableDecks: availableDecks ?? this.availableDecks,
      availableNoteTemplates:
          availableNoteTemplates ?? this.availableNoteTemplates,
      availableCardTypes: availableCardTypes ?? this.availableCardTypes,
    );
  }
}
