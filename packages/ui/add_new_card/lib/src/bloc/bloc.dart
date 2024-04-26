import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:bloc/bloc.dart';

class AddNewCardBloc extends Bloc<AddNewCardEvent, AddNewCardState> {
  AddNewCardBloc() : super(const AddNewCardState()) {
    on<InitialEvent>(_onInitial);
    on<SubmitCard>(_onSubmitCard);
    on<DeckChanged>(_onDeckChanged);
    on<NoteTemplateChanged>(_onNoteTemplateChanged);
    on<CardTypesChanged>(_onCardTypesChanged);
    on<RemoveTag>(_onRemoveTag);
    on<TagsTriggered>(_onTagsTriggered);
  }

  void _onInitial(InitialEvent event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.initial));
  }

  void _onSubmitCard(SubmitCard event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(status: Status.adding));
  }

  void _onDeckChanged(DeckChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(deck: event.deck));
  }

  void _onNoteTemplateChanged(
      NoteTemplateChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(noteTemplate: event.noteTemplate));
  }

  void _onCardTypesChanged(
      CardTypesChanged event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(cardTypes: event.cardTypes));
  }

  void _onRemoveTag(RemoveTag event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(tagsList: state.tagsList..remove(event.tag)));
  }

  void _onTagsTriggered(TagsTriggered event, Emitter<AddNewCardState> emit) {
    emit(state.copyWith(tagsList: state.tagsList..add('')));
  }
}

class AddNewCardStatus {
}
