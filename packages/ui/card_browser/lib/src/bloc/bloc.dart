import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_browser/src/bloc/state.dart';
import 'package:card_browser/src/bloc/event.dart';
import 'package:repos/repos.dart';

// Testing Data

class CardBrowserBloc extends Bloc<CardBrowserEvent, CardBrowserState> {
  final DeckRepo deckRepository;
  final CardRepo cardRepository;

  CardBrowserBloc({required this.deckRepository, required this.cardRepository})
      : super(const CardBrowserState()) {
    on<InitialEvent>(_onInitial);
    on<TestEvent>(_onTest);
    on<AddCardEvent>(_onAddCard);
    on<ReviewEvent>(_onReview);
    on<SearchEvent>(_onSearch);
  }
  Future<FutureOr<void>> _onInitial(
      InitialEvent event, Emitter<CardBrowserState> emit) async {
    // Set the status to loading
    emit(state.copyWith(
        status: CardBrowserStatus.loading, deckID: event.deckId));

    // Get the cards of the deck
    List<Card> cardList = await cardRepository.getCardsOfDeck(state.deckID!);
    // Get remaining cards
    int remainingCards = await cardRepository.numCardsDueForReview(state.deckID!);
    
    emit(state.copyWith(
      status: CardBrowserStatus.loaded, 
      cardList: cardList,
      remainingCards: remainingCards,
      selectedCards: cardList
    ));
  }

  FutureOr<void> _onReview(ReviewEvent event, Emitter<CardBrowserState> emit) {
    print('Reviewing');
  }

  FutureOr<void> _onTest(TestEvent event, Emitter<CardBrowserState> emit) {
    print('Testing');
  }

  FutureOr<void> _onAddCard(
      AddCardEvent event, Emitter<CardBrowserState> emit) {
    print('Adding Card');
  }

  Future<void> _onSearch(SearchEvent event, Emitter<CardBrowserState> emit) async {
    // Set the status to loading
    emit(state.copyWith(status: CardBrowserStatus.loading));
    // Logical resolution
    if (event.keyword.isEmpty) {
      emit(state.copyWith(
          status: CardBrowserStatus.loaded, selectedCards: state.cardList));
      return;
    }

    List<Card> selectedCards = state.cardList
        .where(
            (card) => (card.front[0].$2).toLowerCase().contains(event.keyword))
        .toList();

    List<CardKey> selectedCardIds = selectedCards
        .map((card) => card.key)
        .toList();

    int remainingCards = await cardRepository.numCardsDueForReviewWithSelection(
        state.deckID!, selectedCardIds);

    emit(state.copyWith(
        status: CardBrowserStatus.loaded, 
        selectedCards: selectedCards,
        remainingCards: remainingCards));
  }
}

