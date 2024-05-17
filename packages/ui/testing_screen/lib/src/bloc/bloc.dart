import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repos/repos.dart';
import 'package:testing_screen/src/bloc/event.dart';
import 'package:testing_screen/src/bloc/state.dart';
import 'package:testing_screen/src/testing_panel_widget.dart';

class TestingScreenBloc extends Bloc<TestingScreenEvent, TestingScreenState> {
  final CardRepo cardRepo;

  TestingScreenBloc({required this.cardRepo})
      : super(const TestingScreenState.initial()) {
    on<InitialEvent>(_onInitial);
    on<FinishEvent>(_onFinish);
    on<RevealCardEvent>(_onRevealCard);
    on<SubmitButtonsPressed>(_onSubmitButtonsPressed);
  }

  FutureOr<void> _onInitial(
      InitialEvent event, Emitter<TestingScreenState> emit) async {
    emit(state.copyWith(status: TestingCardStatus.loading, deckId: event.deckId));
    Card? card = await cardRepo.nextCardForReview(event.deckId);
    if (card == null) {
      emit(state.copyWith(status: TestingCardStatus.finish));
      return;
    }
    List<(String, String)> frontFields =
        card.front.map((field) => (field.$1, field.$2)).toList();
    List<(String, String)> backFields =
        card.back.map((field) => (field.$1, field.$2)).toList();
    CardInfo cardInfo =
        CardInfo(backFields: backFields, frontFields: frontFields, side: true);
    emit(state.copyWith(
      noteId: card.key.noteId,
      cardTemplateId: card.key.cardTemplateId,
      status: TestingCardStatus.success,
      cardInfo: cardInfo,
    ));
  }

  void _onFinish(FinishEvent event, Emitter<TestingScreenState> emit) {
    // call the function to delete temp deck
    emit(state.copyWith(status: TestingCardStatus.finish));
  }

  FutureOr<void> _onRevealCard(
      RevealCardEvent event, Emitter<TestingScreenState> emit) {
    CardInfo cardInfo = state.cardInfo!.copyWith(
      side: false,
    );
    emit(state.copyWith(side: TestingCardSide.back, cardInfo: cardInfo));
  }

  FutureOr<void> _onSubmitButtonsPressed(
      SubmitButtonsPressed event, Emitter<TestingScreenState> emit) async {
    emit(state.copyWith(status: TestingCardStatus.loading));
    CardKey key = CardKey(
      deckId: state.deckId,
      noteId: state.noteId,
      cardTemplateId: state.cardTemplateId,
    );
    List<(String, String, bool)> frontFields = state.cardInfo!.frontFields
        .map((field) => (field.$1, field.$2, true))
        .toList();
    List<(String, String, bool)> backFields = state.cardInfo!.backFields
        .map((field) => (field.$1, field.$2, false))
        .toList();
    Card card = Card(
      key: key,
      front: frontFields,
      back: backFields,
    );
    await cardRepo.learnCard(card, event.result);

    Card? nextCard = await cardRepo.nextCardForReview(state.deckId);
    if (nextCard == null) {
      emit(state.copyWith(status: TestingCardStatus.finish));
      return;
    }
    List<(String, String)> frontFieldsNext =
        nextCard.front.map((field) => (field.$1, field.$2)).toList();
    List<(String, String)> backFieldsNext =
        nextCard.back.map((field) => (field.$1, field.$2)).toList();
    CardInfo cardInfoNext = CardInfo(
        backFields: backFieldsNext, frontFields: frontFieldsNext, side: true);
    emit(state.copyWith(
        side: TestingCardSide.front,
        cardInfo: cardInfoNext,
        status: TestingCardStatus.success,
        noteId: nextCard.key.noteId,
        cardTemplateId: nextCard.key.cardTemplateId));
  }
}
