import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:testing_setup/src/bloc/event.dart';
import 'package:testing_setup/src/bloc/state.dart';

class TestingSetupBloc extends Bloc<TestingSetupEvent, TestingSetupState> {
  TestingSetupBloc() : super(const TestingSetupState()) {
    on<InitialEvent>(_onInitial);
    on<SelectedTagsChanged>(_onSelectedTagsChanged);
    on<SelectedCardTypeChanged>(_onSelectedCardTypeChanged);
    on<StartEvent>(_onStart);
  }

  FutureOr<void> _onInitial(
    InitialEvent event, Emitter<TestingSetupState> emit) async {
    emit(state.copyWith(status: TestingSetupStatus.loading));
    // Fetch data
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  void _onSelectedTagsChanged(
    SelectedTagsChanged event, Emitter<TestingSetupState> emit) {
    emit(state.copyWith(selectedTags: event.selectedTags));
  }

  void _onSelectedCardTypeChanged(
    SelectedCardTypeChanged event, Emitter<TestingSetupState> emit) {
    emit(state.copyWith(selectedCardType: event.selectedCardType));
  }

  void _onStart(StartEvent event, Emitter<TestingSetupState> emit) {
    // Start testing
  }
}
