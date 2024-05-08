import 'package:equatable/equatable.dart';
import 'package:repos/repos.dart';

enum Status {
  initial,
  loading,
  loaded,
  addSuccess,
  addError,
  adding,
  changing,
  changed,
  newAvailableTagAdding,
  tagsTriggered
}

class AddNewCardState extends Equatable {
  final Status status;
  final String deckName;
  final String noteTemplateName;
  final List<DeckOverview> deckList;
  final List<NoteTemplate> noteTemplateList;
  final List<String> cardTypes;               // Still remain
  final List<String> fieldNames;
  final List<String> tagsList;
  final List<String> availableTagsList;
  final List<DeckOverview> availableDecks;
  final List<NoteTemplate> availableNoteTemplates;
  final List<String> availableCardTypes;      // Still remain

  const AddNewCardState({
    this.status = Status.initial,
    this.deckName = '',
    this.noteTemplateName = '',
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
        deckName,
        noteTemplateName,
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
    String? deckName,
    String? noteTemplateName,
    List<String>? cardTypes,
    List<String>? fieldNames,
    List<String>? tagsList,
    List<String>? availableTagsList,
    List<DeckOverview>? availableDecks,
    List<NoteTemplate>? availableNoteTemplates,
    List<String>? availableCardTypes,
  }) {
    return AddNewCardState(
      status: status ?? this.status,
      deckName: deckName ?? this.deckName,
      noteTemplateName: noteTemplateName ?? this.noteTemplateName,
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
