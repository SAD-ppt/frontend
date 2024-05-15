import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:repos/repos.dart';
import 'package:testing_setup/src/bloc/event.dart';
import 'package:testing_setup/src/bloc/state.dart';

class TestingSetupBloc extends Bloc<TestingSetupEvent, TestingSetupState> {

  final DeckRepo deckRepository;
  final CardRepo cardRepository;
  final NoteRepo noteRepository;

  TestingSetupBloc({
    required this.deckRepository,
    required this.cardRepository,
    required this.noteRepository,
  }) : super(const TestingSetupState()) {
    on<InitialEvent>(_onInitial);
    on<SelectedTagsChanged>(_onSelectedTagsChanged);
    on<SelectedCardTypeChanged>(_onSelectedCardTypeChanged);
    on<StartEvent>(_onStart);
  }

  FutureOr<void> _onInitial(
    InitialEvent event, Emitter<TestingSetupState> emit) async {
    
    // Set the status to loading
    emit(state.copyWith(status: TestingSetupStatus.loading));
    await Future<void>.delayed(const Duration(seconds: 1));

    // Get the cards of the deck
    List<Card> cardList = await cardRepository.getCardsOfDeck(state.deckID);
    List<String> availableTags = await getAvailableTags(state.deckID);
    List<CardTemplate> availableCardTypes = const [];                         // Still update

    emit(state.copyWith(
      status: TestingSetupStatus.loaded,
      filteredCards: cardList,
      cardList: cardList,
      availableTags: availableTags,
      availableCardTypes: availableCardTypes,
    ));
  }

  void _onSelectedTagsChanged(
    SelectedTagsChanged event, Emitter<TestingSetupState> emit) {
    emit(state.copyWith(selectedTags: event.selectedTags));
  }

  void _onSelectedCardTypeChanged(
    SelectedCardTypeChanged event, Emitter<TestingSetupState> emit) {
    emit(state.copyWith(selectedCardType: event.selectedCardType));
  }

  void _onStart(StartEvent event, Emitter<TestingSetupState> emit) {
    // Start testing
  }

  // Helper functions
  Future<List<String>> getAvailableTags( String deckID ) async {
    Iterable<Note> noteList = await noteRepository.getNotesOfDeck(deckID);
    List<String> tags = [];
    for (Note note in noteList) {
      tags.addAll(note.tags);
    }
    return tags.toSet().toList();
  }
}
