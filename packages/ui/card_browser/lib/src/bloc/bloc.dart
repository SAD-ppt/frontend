import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_browser/src/bloc/state.dart';
import 'package:card_browser/src/bloc/event.dart';
import 'package:logging/logging.dart';

// Testing Data

class CardBrowserBloc extends Bloc<CardBrowserEvent, CardBrowserState> {
  // final CardRepository cardRepository;
  final log = Logger('VicLuu/CardBrowserBloc');

  CardBrowserBloc(/*{required this.cardRepository}*/) : super(const CardBrowserState()) {
    on<InitialEvent>(_onInitial);
    on<TestEvent>(_onTest);
    on<AddCardEvent>(_onAddCard);
    on<ReviewEvent>(_onReview);
  }
  Future<FutureOr<void>> _onInitial(InitialEvent event, Emitter<CardBrowserState> emit) async {
    emit(state.copyWith(status: CardBrowserStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    // final cardList = await cardRepository.getCards(deckID: state.deckID);
    // emit(state.copyWith(status: CardBrowserStatus.loaded, cardList: cardList));
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