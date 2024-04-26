import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_screen/src/bloc/event.dart';
import 'package:learning_screen/src/bloc/state.dart';
import 'package:learning_screen/src/learning_panel_widget.dart';

class LearningScreenBloc
    extends Bloc<LearningScreenEvent, LearningScreenState> {
  LearningScreenBloc() : super(const LearningScreenState.initial()) {
    on<InitialEvent>(_onInitial);
    on<LoadCardEvent>(_onLoadCard);
    on<RevealCardEvent>(_onRevealCard);
    on<SubmitButtonsPressed>(_onSubmitButtonsPressed);
  }

  FutureOr<void> _onInitial(
    InitialEvent event,
    Emitter<LearningScreenState> emit,
  ) async {
    emit(state.copyWith(status: LearningScreenStatus.loading));
    // wait for 1 second
    await Future.delayed(const Duration(seconds: 1), () {
      // Mock data (will be replaced by real data fetching logic)
      CardInfo cardInfo = const CardInfo(frontFields: ['Front of the card'], backFields: ['Back of the card'], side: true);
      emit(state.copyWith(
        status: LearningScreenStatus.success,
        cardInfo: cardInfo,
      ));
    });
  }

  FutureOr<void> _onLoadCard(
    LoadCardEvent event,
    Emitter<LearningScreenState> emit,
  ) {
    CardInfo cardInfo = const CardInfo(frontFields: ['Front of the card'], backFields: ['Back of the card'], side: true);
    emit(state.copyWith(
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
    // load the next card
    CardInfo cardInfo = const CardInfo(frontFields: ['Next front of the card'], backFields: ['Next back of the card'], side: true);
    await Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(
        side: LearningCardSide.front,
        status: LearningScreenStatus.success,
        cardInfo: cardInfo,
      ));
    });
  }
}
