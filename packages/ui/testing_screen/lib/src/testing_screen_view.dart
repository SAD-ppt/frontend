import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repos/repos.dart';
import 'package:testing_screen/src/bloc/bloc.dart';
import 'package:testing_screen/src/bloc/event.dart';
import 'package:testing_screen/src/bloc/state.dart';
import 'package:testing_screen/src/testing_panel_finish.dart';
import 'package:testing_screen/src/testing_panel_loading.dart';
import 'package:testing_screen/src/testing_panel_widget.dart';

class TestingScreen extends StatelessWidget {
  final String deckId;
  const TestingScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TestingScreenBloc(
            cardRepo: context.read<CardRepo>(),
            deckRepo: context.read<DeckRepo>())
          ..add(InitialEvent(deckId: deckId)),
        child: _TestingScreenView());
  }
}

class _TestingScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestingScreenBloc, TestingScreenState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          // Back button and settings icon
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.of(context).pop();
            },
          ),
          actions: const <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: null,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.status == TestingCardStatus.finish) ...[
              TestingPanelFinish(
                onFinished: () {
                  context
                      .read<TestingScreenBloc>()
                      .add(FinishEvent(deckId: state.deckId));
                },
              ),
              // call the function to delete temp deck
            ],
            if (state.status == TestingCardStatus.loading) ...[
              const TestingPanelLoading(),
            ],
            if (state.status == TestingCardStatus.success &&
                state.side == TestingCardSide.front) ...[
              Expanded(
                child: TestingPanelWidget(
                    cardInfo: state.cardInfo ?? const CardInfo.empty()),
              ),
              // Render according to the state of the bloc
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  // emit the LearningScreenRevealButtonPressed event
                  context
                      .read<TestingScreenBloc>()
                      .add(const RevealCardEvent());
                },
                child: const Text(
                  'Reveal',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
            if (state.status == TestingCardStatus.success &&
                state.side == TestingCardSide.back) ...[
              Expanded(
                  child: TestingPanelWidget(
                      cardInfo: state.cardInfo ?? const CardInfo.empty())),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                    ),
                    onPressed: () {
                      // emit the LearningScreenSubmitButtonPressed event
                      context
                          .read<TestingScreenBloc>()
                          .add(const SubmitButtonsPressed(result: 'correct'));
                    },
                    child: const Text(
                      'Correct',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      // emit the LearningScreenSubmitButtonPressed event
                      context
                          .read<TestingScreenBloc>()
                          .add(const SubmitButtonsPressed(result: 'incorrect'));
                    },
                    child: const Text(
                      'Incorrect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
