import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:repos/repos.dart';
import 'package:testing_setup/src/bloc/event.dart';
import 'package:testing_setup/src/bloc/state.dart';

class TestingSetupBloc extends Bloc<TestingSetupEvent, TestingSetupState> {

  final void Function(String) onStart;
  final DeckRepo deckRepository;
  final CardRepo cardRepository;
  final NoteRepo noteRepository;

  TestingSetupBloc({
    required this.onStart,
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
    List<String> availableCardTypes = [];
    Map<String, String> dictionary = {};

    // Get the available card types
    for (CardOverview card in cardList) {
      availableCardTypes.add(card.cardTemplateName);
      dictionary[card.cardTemplateName] = card.id.cardTemplateId;
    }

    availableCardTypes = availableCardTypes.toSet().toList();
    
    emit(state.copyWith(
      status: TestingSetupStatus.loaded,
      deckID: event.deckId,
      cardList: cardList,
      availableTags: availableTags,
      availableCardTypes: availableCardTypes,
      totalFilteredCard: cardList.length,
      dictionary: dictionary,
    ));
  }

  void _onSelectedTagsChanged(
    SelectedTagsChanged event, Emitter<TestingSetupState> emit) {
  
    emit(state.copyWith(status: TestingSetupStatus.loading));
    
    int totalFilteredCard = state.cardList.where((card) =>
      event.selectedTags.every((tag) => card.tags.contains(tag)) &&
      (state.selectedCardType.isEmpty || state.selectedCardType.contains(card.cardTemplateName))).length;

    emit(state.copyWith(
      selectedTags: event.selectedTags,
      totalFilteredCard: totalFilteredCard,
      status: TestingSetupStatus.loaded,
    ));
  }

  void _onSelectedCardTypeChanged(
    SelectedCardTypeChanged event, Emitter<TestingSetupState> emit) {
    
    emit(state.copyWith(status: TestingSetupStatus.loading));

    int totalFilteredCard = state.cardList.where((card) {
      return state.selectedTags.every((tag) => card.tags.contains(tag)) &&
          (event.selectedCardType.isEmpty || event.selectedCardType.contains(card.cardTemplateName));
    }).length;

    emit(state.copyWith(
      selectedCardType: event.selectedCardType,
      totalFilteredCard: totalFilteredCard,
      status: TestingSetupStatus.loaded,
    ));
  }

  Future<void> _onStart(StartEvent event, Emitter<TestingSetupState> emit) async {
    
    emit(state.copyWith(status: TestingSetupStatus.loading));
    
    List<String> selectedCardType = state.selectedCardType.isEmpty ? state.availableCardTypes : state.selectedCardType;
    List<String> selectedCardTypeId = [];
    for (String cardType in selectedCardType) {
      selectedCardTypeId.add(state.dictionary[cardType]!);
    }

    String resultID = await deckRepository.createTestDeck( 
      state.deckID, 
      state.selectedTags, 
      selectedCardTypeId.toSet().toList()
    );
    print("Result ID: $resultID");
    onStart(resultID);
    
    emit(state.copyWith(
      status: TestingSetupStatus.loaded,
      deliverDeckId: resultID,
    ));
  }

  // Helper functions
  Future<List<String>> getAvailableTags( String deckID ) async {
    Iterable<Note> noteList = await noteRepository.getNotesOfDeck(deckID);
    List<String> tags = noteList.expand((note) => note.tags).toSet().toList();
    return tags;
  }
}
