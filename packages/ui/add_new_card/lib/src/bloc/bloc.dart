import 'dart:async';

import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:bloc/bloc.dart';
import 'package:repos/repos.dart';

// List<String> getFieldsForNoteTemplate(String noteTemplate) {
//   return fieldsList[noteTemplateList.indexOf(noteTemplate)];
// }

class AddNewCardBloc extends Bloc<AddNewCardEvent, AddNewCardState> {
  final DeckRepo deckRepository;
  final NoteRepo noteRepository;
  final NoteTemplateRepo noteTemplateRepository;

  AddNewCardBloc({
    required this.deckRepository,
    required this.noteRepository,
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
    on<FieldValueChanged>(_onFieldValueChanged);
  }

  FutureOr<void> _onInitial(
      InitialEvent event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.loading));
    await Future.delayed(const Duration(seconds: 1));

    // Load data from repository
    List<DeckOverview> deckList = await deckRepository.getDeckOverviews();

    List<NoteTemplate> noteTemplateList =
        await noteTemplateRepository.getAllNoteTemplates();

    List<CardTemplate> cardTemplateList = const [];
    if (noteTemplateList.isNotEmpty) {
      NoteTemplateDetail noteTemplateDetail = await noteTemplateRepository
          .getNoteTemplateDetail(noteTemplateList[0].id);
      cardTemplateList = noteTemplateDetail.cardTemplates;
    }

    List<String> fieldsList =
        getFieldsForNoteTemplate(noteTemplateList[0].name, noteTemplateList);
    // map each field to a tuple of field name and value
    List<(String, String)> fieldNamesValues =
        fieldsList.map((field) => (field, '')).toList();
    List<String> tagList = await noteRepository.getTags();

    String deckInitItem;
    if (event.deckId != null) {
      deckInitItem = deckList.firstWhere((deck) => deck.id == event.deckId).name;
    } else {
      deckInitItem = deckList.isNotEmpty ? deckList[0].name : '';
    }

    emit(state.copyWith(
      status: Status.loaded,
      deckName: deckInitItem,
      noteTemplateName:
          noteTemplateList.isNotEmpty ? noteTemplateList[0].name : '',
      fieldNamesValues: fieldNamesValues,
      tagsList: const [],
      selectedCardTypes: [],
      availableDecks: deckList,
      availableNoteTemplates: noteTemplateList,
      availableCardTypes: cardTemplateList,
      availableTagsList: tagList,
    ));
  }

  FutureOr<void> _onSubmitCard(
      SubmitCard event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.adding));
    // get deck id from deck name
    String deckId = state.availableDecks
        .firstWhere((deck) => deck.name == state.deckName)
        .id;
    return noteRepository
        .createNote(
      deckId,
      getNoteTemplateByName(
              state.noteTemplateName, state.availableNoteTemplates)
          .id,
      state.fieldNamesValues.map((field) => field.$2).toList(),
      tags: state.tagsList,
    )
        .then((value) {
      emit(state.copyWith(status: Status.addSuccess));
    }).catchError((error) {
      emit(state.copyWith(status: Status.addError));
    });
  }

  void _onDeckChanged(DeckChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(deckName: event.deckName));
  }

  FutureOr<void> _onNoteTemplateChanged(
      NoteTemplateChanged event, Emitter<AddNewCardState> emit) async {
    emit(state.copyWith(status: Status.changing));
    await Future.delayed(const Duration(milliseconds: 500));

    NoteTemplate noteTemplate = getNoteTemplateByName(
        event.noteTemplateName, state.availableNoteTemplates);
    NoteTemplateDetail noteTemplateDetail =
        await noteTemplateRepository.getNoteTemplateDetail(noteTemplate.id);
    List<CardTemplate> cardTemplateList = noteTemplateDetail.cardTemplates;
    List<String> fieldsList = getFieldsForNoteTemplate(
        event.noteTemplateName, state.availableNoteTemplates);
    List<(String, String)> fieldNamesValues =
        fieldsList.map((field) => (field, '')).toList();

    emit(state.copyWith(
        status: Status.changed,
        noteTemplateName: event.noteTemplateName,
        fieldNamesValues: fieldNamesValues,
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
    await noteRepository.createNewTag(event.tag);
    emit(state.copyWith(
        status: Status.loaded,
        availableTagsList: [...state.availableTagsList, event.tag]));
  }

  void _onTagsTriggered(TagsTriggered event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.tagsTriggered));
  }

  // Helper function
  List<String> getFieldsForNoteTemplate(
      String noteTemplateName, List<NoteTemplate> noteTemplateList) {
    return noteTemplateList
        .firstWhere((noteTemplate) => noteTemplate.name == noteTemplateName)
        .fieldNames;
  }

  NoteTemplate getNoteTemplateByName(
      String noteTemplateName, List<NoteTemplate> noteTemplateList) {
    return noteTemplateList
        .firstWhere((noteTemplate) => noteTemplate.name == noteTemplateName);
  }

  void _onFieldValueChanged(
      FieldValueChanged event, Emitter<AddNewCardState> emit) {
    List<(String, String)> newFieldNamesValues = state.fieldNamesValues;
    newFieldNamesValues[event.index] =
        (newFieldNamesValues[event.index].$1, event.value);
    emit(state.copyWith(fieldNamesValues: newFieldNamesValues));
  }
}
