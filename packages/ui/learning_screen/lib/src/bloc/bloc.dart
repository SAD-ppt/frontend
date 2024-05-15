import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_screen/src/bloc/event.dart';
import 'package:learning_screen/src/bloc/state.dart';
import 'package:learning_screen/src/learning_panel_widget.dart';
import 'package:repos/repos.dart';

class LearningScreenBloc
    extends Bloc<LearningScreenEvent, LearningScreenState> {
  CardRepo cardRepo;
  LearningScreenBloc({required this.cardRepo})
      : super(const LearningScreenState.initial()) {
    on<InitialEvent>(_onInitial);
    on<LoadCardEvent>(_onLoadCard);
    on<RevealCardEvent>(_onRevealCard);
    on<SubmitButtonsPressed>(_onSubmitButtonsPressed);
  }

  FutureOr<void> _onInitial(
    InitialEvent event,
    Emitter<LearningScreenState> emit,
  ) async {
    emit(state.copyWith(
        status: LearningScreenStatus.loading, deckId: event.deckId));
    // call repository to load the first card
    // load the first card
    Card? card = await cardRepo.nextCardForReview(event.deckId);
    if (card == null) {
      emit(state.copyWith(status: LearningScreenStatus.error));
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
      status: LearningScreenStatus.success,
      cardInfo: cardInfo,
    ));
  }

  FutureOr<void> _onLoadCard(
    LoadCardEvent event,
    Emitter<LearningScreenState> emit,
  ) async {
    emit(state.copyWith(status: LearningScreenStatus.loading));
    // call repository to load the next card
    // load the next card
    Card? card = await cardRepo.nextCardForReview(state.deckId);
    if (card == null) {
      emit(state.copyWith(status: LearningScreenStatus.error));
      return;
    }
    List<(String, String)> frontFields =
        card.front.map((field) => (field.$1, field.$2)).toList();
    List<(String, String)> backFields =
        card.back.map((field) => (field.$1, field.$2)).toList();
    CardInfo cardInfo =
        CardInfo(backFields: backFields, frontFields: frontFields, side: true);
    emit(state.copyWith(
      side: LearningCardSide.front,
      status: LearningScreenStatus.success,
      cardInfo: cardInfo,
    ));
  }

  FutureOr<void> _onRevealCard(
    RevealCardEvent event,
    Emitter<LearningScreenState> emit,
  ) {
    CardInfo newCardInfo = state.cardInfo!.copyWith(side: false);
    emit(state.copyWith(
      side: LearningCardSide.back,
      cardInfo: newCardInfo,
    ));
  }

  FutureOr<void> _onSubmitButtonsPressed(
    SubmitButtonsPressed event,
    Emitter<LearningScreenState> emit,
  ) async {
    emit(state.copyWith(status: LearningScreenStatus.loading));
    // call repository to update the card difficulty
    CardKey key = CardKey(
        deckId: state.deckId,
        noteId: state.noteId,
        cardTemplateId: state.cardTemplateId);
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
    await cardRepo.learnCard(card, event.difficulty);
    // load the next card
    Card? nextCard = await cardRepo.nextCardForReview(state.deckId);
    if (nextCard == null) {
      emit(state.copyWith(status: LearningScreenStatus.error));
      return;
    }
    List<(String, String)> frontFieldsNext =
        nextCard.front.map((field) => (field.$1, field.$2)).toList();
    List<(String, String)> backFieldsNext =
        nextCard.back.map((field) => (field.$1, field.$2)).toList();
    CardInfo cardInfoNext = CardInfo(
        backFields: backFieldsNext, frontFields: frontFieldsNext, side: true);
    emit(state.copyWith(
      noteId: nextCard.key.noteId,
      cardTemplateId: nextCard.key.cardTemplateId,
      status: LearningScreenStatus.success,
      cardInfo: cardInfoNext,
    ));
  }
}
