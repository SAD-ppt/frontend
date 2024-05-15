import 'dart:async';

import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:bloc/bloc.dart';
import 'package:repos/repos.dart';

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

// List<String> getFieldsForNoteTemplate(String noteTemplate) {
//   return fieldsList[noteTemplateList.indexOf(noteTemplate)];
// }

class AddNewCardBloc extends Bloc<AddNewCardEvent, AddNewCardState> {

  final DeckRepo deckRepository;
  final NoteTemplateRepo noteTemplateRepository;

  AddNewCardBloc({
    required this.deckRepository,
    required this.noteTemplateRepository,
  }) : super(const AddNewCardState()) {

    on<InitialEvent>(_onInitial);
    on<SubmitCard>(_onSubmitCard);
    on<DeckChanged>(_onDeckChanged);
    on<NoteTemplateChanged>(_onNoteTemplateChanged);
    on<CardTypesChanged>(_onCardTypesChanged);
    // on<RemoveTag>(_onRemoveTag);
    // on<AddTag>(_onAddTag);
    on<TagsChanged>(_onTagsChanged);
    on<AddNewAvailableTag>(_onAddNewAvailableTag);
    on<TagsTriggered>(_onTagsTriggered);
  
  }

  FutureOr<void> _onInitial(
      InitialEvent event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.loading));
    await Future.delayed(const Duration(seconds: 1));

    // Load data from repository
    List<DeckOverview> deckList = await deckRepository.getDeckOverviews();
    List<NoteTemplate> noteTemplateList = await noteTemplateRepository.getAllNoteTemplates();
    
    List<CardTemplate> cardTemplateList = const [];
    if(noteTemplateList.isNotEmpty) {
      NoteTemplateDetail noteTemplateDetail = await noteTemplateRepository.getNoteTemplateDetail(noteTemplateList[0].id);
      cardTemplateList = noteTemplateDetail.cardTemplates;
    }

    emit(state.copyWith(
        status: Status.loaded,
        deckName: deckList.isNotEmpty ? deckList[0].name : '',
        noteTemplateName: noteTemplateList.isNotEmpty ? noteTemplateList[0].name : '',
        fieldNames: fieldsList[0],
        tagsList: tagsList,
        selectedCardTypes: [],
        availableDecks: deckList,
        availableNoteTemplates: noteTemplateList,
        availableCardTypes: cardTemplateList,
        availableTagsList: availableTagsList
    ));
  }

  void _onSubmitCard(SubmitCard event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.adding));
  }

  void _onDeckChanged(DeckChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(deckName: event.deckName));
  }

  FutureOr<void> _onNoteTemplateChanged(
      NoteTemplateChanged event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.changing));
    await Future.delayed(const Duration(milliseconds: 500));

    NoteTemplate noteTemplate = getNoteTemplateByName(event.noteTemplateName, state.availableNoteTemplates);
    NoteTemplateDetail noteTemplateDetail = await noteTemplateRepository.getNoteTemplateDetail(noteTemplate.id);
    List<CardTemplate> cardTemplateList = noteTemplateDetail.cardTemplates;

    emit(state.copyWith(
        status: Status.changed,
        noteTemplateName: event.noteTemplateName,
        fieldNames: getFieldsForNoteTemplate(event.noteTemplateName, state.availableNoteTemplates),
        selectedCardTypes: const [],
        availableCardTypes: cardTemplateList));
  }

  void _onCardTypesChanged(
      CardTypesChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(selectedCardTypes: event.selectedCardTypes));
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

  FutureOr<void> _onAddNewAvailableTag(
      AddNewAvailableTag event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.newAvailableTagAdding));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
        status: Status.loaded,
        availableTagsList: [...state.availableTagsList, event.tag]));
  }

  void _onTagsTriggered(TagsTriggered event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.tagsTriggered));
  }

  // Helper function
  List<String> getFieldsForNoteTemplate(String noteTemplateName, List<NoteTemplate> noteTemplateList) {
    return noteTemplateList.firstWhere((noteTemplate) => noteTemplate.name == noteTemplateName).fieldNames;
  }

  NoteTemplate getNoteTemplateByName(String noteTemplateName, List<NoteTemplate> noteTemplateList) {
    return noteTemplateList.firstWhere((noteTemplate) => noteTemplate.name == noteTemplateName);
  }
}
