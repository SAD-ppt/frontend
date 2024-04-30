import 'dart:async';

import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:bloc/bloc.dart';

// Mock Data
var deckList = ['Deck 1', 'Deck 2', 'Deck 3'];
var noteTemplateList = [
  'Note Template 1',
  'Note Template 2',
  'Note Template 3'
];
var fieldsList = [
  ['Field 1 for Note 1', 'Field 2 for Note 1', 'Field 3 for Note 1'],
  ['Field 1 for Note 2', 'Field 2 for Note 2'],
  ['Field 1 for Note 3', 'Field 2 for Note 3', 'Field 3 for Note 3']
];
var cardTypeList = [
  [
    'Card Type 1 for Note 1',
    'Card Type 2 for Note 1',
    'Card Type 3 for Note 1'
  ],
  ['Card Type 1 for Note 2', 'Card Type 2 for Note 2'],
  ['Card Type 1 for Note 3', 'Card Type 2 for Note 3', 'Card Type 3 for Note 3']
];
var tagsList = ['Tag 1', 'Tag 2', 'Tag 3'];
var availableTagsList = ['Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Tag 5'];

List<String> getFieldsForNoteTemplate(String noteTemplate) {
  return fieldsList[noteTemplateList.indexOf(noteTemplate)];
}

class AddNewCardBloc extends Bloc<AddNewCardEvent, AddNewCardState> {
  AddNewCardBloc() : super(const AddNewCardState()) {
    on<InitialEvent>(_onInitial);
    on<SubmitCard>(_onSubmitCard);
    on<DeckChanged>(_onDeckChanged);
    on<NoteTemplateChanged>(_onNoteTemplateChanged);
    on<CardTypesChanged>(_onCardTypesChanged);
    // on<RemoveTag>(_onRemoveTag);
    // on<AddTag>(_onAddTag);
    on<TagsChanged>(_onTagsChanged);
    on<TagsTriggered>(_onTagsTriggered);
  }

  FutureOr<void> _onInitial(
      InitialEvent event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.loading));
    await Future.delayed(const Duration(seconds: 1));
    // Success loaded with mock data
    emit(state.copyWith(
        status: Status.loaded,
        deck: deckList[0],
        noteTemplate: noteTemplateList[0],
        fieldNames: fieldsList[0],
        tagsList: tagsList,
        cardTypes: cardTypeList[0],
        availableDecks: deckList,
        availableNoteTemplates: noteTemplateList,
        availableCardTypes: cardTypeList[0],
        availableTagsList: availableTagsList));
  }

  void _onSubmitCard(SubmitCard event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.adding));
  }

  void _onDeckChanged(DeckChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(deck: event.deck));
  }

  FutureOr<void> _onNoteTemplateChanged(
      NoteTemplateChanged event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.changing));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(
        status: Status.changed,
        noteTemplate: event.noteTemplate,
        fieldNames: getFieldsForNoteTemplate(event.noteTemplate),
        cardTypes: const [],
        availableCardTypes:
            cardTypeList[noteTemplateList.indexOf(event.noteTemplate)]));
  }

  void _onCardTypesChanged(
      CardTypesChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(cardTypes: event.cardTypes));
  }

  void _onTagsChanged(TagsChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(tagsList: event.tagsList));
  }

  // void _onRemoveTag(RemoveTag event, Emitter<AddNewCardState> emit) {
  //   emit(state.copyWith(tagsList: event.tagsList));
  // }

  // void _onAddTag(AddTag event, Emitter<AddNewCardState> emit) {
  //   emit(state.copyWith(tagsList: event.tagsList));
  // }

  void _onTagsTriggered(TagsTriggered event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.tagsTriggered));
  }
}
