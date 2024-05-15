import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_browser/src/bloc/state.dart';
import 'package:card_browser/src/bloc/event.dart';
import 'package:repos/repos.dart';

// Testing Data

class CardBrowserBloc extends Bloc<CardBrowserEvent, CardBrowserState> {
  
  final DeckRepo deckRepository;
  final CardRepo cardRepository;

  CardBrowserBloc({
    required this.deckRepository,
    required this.cardRepository
  }) : super(const CardBrowserState()) {
    on<InitialEvent>(_onInitial);
    on<TestEvent>(_onTest);
    on<AddCardEvent>(_onAddCard);
    on<ReviewEvent>(_onReview);
    on<SearchEvent>(_onSearch);
  }
  Future<FutureOr<void>> _onInitial(InitialEvent event, Emitter<CardBrowserState> emit) async {

    // Set the status to loading
    emit(state.copyWith(status: CardBrowserStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    // Get the cards of the deck
    List<Card> cardList = await cardRepository.getCardsOfDeck(state.deckID);
    emit(state.copyWith(
      status: CardBrowserStatus.loaded,
      cardList: cardList
    ));
  }

  FutureOr<void> _onReview(ReviewEvent event, Emitter<CardBrowserState> emit) {
    print('Reviewing');
  }

  FutureOr<void> _onTest(TestEvent event, Emitter<CardBrowserState> emit) {
    print('Testing');
  }

  FutureOr<void> _onAddCard(AddCardEvent event, Emitter<CardBrowserState> emit) {
    print('Adding Card');
  }

  void _onSearch(SearchEvent event, Emitter<CardBrowserState> emit) {
    // Set the status to loading
    emit(state.copyWith(status: CardBrowserStatus.loading));
    // Logical resolution
    if(event.keyword.isEmpty) {
      emit(state.copyWith(
        status: CardBrowserStatus.loaded,
        selectedCards: state.cardList
      ));
      return;
    }

    List<Card> selectedCards = state.cardList
        .where((card) => 
            (card.front[0].$2).toLowerCase().contains(event.keyword))
        .toList();
    
    emit(state.copyWith(
      status: CardBrowserStatus.loaded,
      selectedCards: selectedCards
    ));
  }
}