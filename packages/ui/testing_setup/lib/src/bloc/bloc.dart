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
    // Get the cards of the deck
    List<CardOverview> cardList = await cardRepository.getCardOverviewsOfDeck(event.deckId);
    List<String> availableTags = await getAvailableTags(event.deckId);
    List<String> availableCardTypes = cardList.map((card) => card.cardTemplateName).toSet().toList();
    
    emit(state.copyWith(
      status: TestingSetupStatus.loaded,
      // filteredCards: cardList,
      cardList: cardList,
      availableTags: availableTags,
      availableCardTypes: availableCardTypes,
      totalFilteredCard: cardList.length,
    ));
  }

  void _onSelectedTagsChanged(
    SelectedTagsChanged event, Emitter<TestingSetupState> emit) {
  
    emit(state.copyWith(status: TestingSetupStatus.loading));
    
    int totalFilteredCard = 0;
    
    for (CardOverview card in state.cardList) {
      if (event.selectedTags.every((tag) => card.tags.contains(tag)) && 
          (state.selectedCardType.isEmpty || state.selectedCardType.contains(card.cardTemplateName))) {
        totalFilteredCard++;
      }
    }

    emit(state.copyWith(
      selectedTags: event.selectedTags,
      totalFilteredCard: totalFilteredCard,
      status: TestingSetupStatus.loaded,
    ));
  }

  void _onSelectedCardTypeChanged(
    SelectedCardTypeChanged event, Emitter<TestingSetupState> emit) {
    
    emit(state.copyWith(status: TestingSetupStatus.loading));

    int totalFilteredCard = 0;

    for (CardOverview card in state.cardList) {
      if (state.selectedTags.every((tag) => card.tags.contains(tag)) && 
          (event.selectedCardType.isEmpty || event.selectedCardType.contains(card.cardTemplateName))) {
        totalFilteredCard++;
      }
    }

    emit(state.copyWith(
      selectedCardType: event.selectedCardType,
      totalFilteredCard: totalFilteredCard,
      status: TestingSetupStatus.loaded,
    ));
  }

  void _onStart(StartEvent event, Emitter<TestingSetupState> emit) {
    
    // Filter the cards

    // Navigate to the testing screen
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
