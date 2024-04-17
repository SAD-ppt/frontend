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
  }

  FutureOr<void> _onInitial(
    InitialEvent event,
    Emitter<LearningScreenState> emit,
  ) {
    emit(state.copyWith(status: LearningScreenStatus.loading));
  }

  FutureOr<void> _onLoadCard(
    LoadCardEvent event,
    Emitter<LearningScreenState> emit,
  ) {
    emit(state.copyWith(
      status: LearningScreenStatus.success,
      cardInfo: const CardInfo(fields: ['Front of the card']),
    ));
  }

  FutureOr<void> _onRevealCard(
    RevealCardEvent event,
    Emitter<LearningScreenState> emit,
  ) {
    emit(state.copyWith(
      side: LearningCardSide.back,
      cardInfo: const CardInfo(fields: ['Back of the card']),
    ));
  }
}
