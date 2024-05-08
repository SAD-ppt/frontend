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
  }
  Future<FutureOr<void>> _onInitial(InitialEvent event, Emitter<CardBrowserState> emit) async {

    // Set the status to loading
    emit(state.copyWith(status: CardBrowserStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    // Get the cards of the deck
    StreamSubscription cardSubscription = cardRepository.getCardsOfDeck(state.deckID).listen((event) {
      emit(state.copyWith(cardList: event));
    });
    
    // Set the status to loaded
    cardSubscription.onDone(() {
      emit(state.copyWith(status: CardBrowserStatus.loaded));
    });
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
}