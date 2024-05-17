import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_screen/src/bloc/bloc.dart';
import 'package:learning_screen/src/bloc/event.dart';
import 'package:learning_screen/src/bloc/state.dart';
import 'package:learning_screen/src/learning_panel_finish.dart';
import 'package:learning_screen/src/learning_panel_loading.dart';
import 'package:learning_screen/src/learning_panel_widget.dart';
import 'package:repos/repos.dart';

class LearningScreen extends StatelessWidget {
  final String deckId;
  const LearningScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            LearningScreenBloc(cardRepo: context.read<CardRepo>())
              ..add(InitialEvent(deckId: deckId)),
        child: _LearningScreenView());
  }
}

class _LearningScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningScreenBloc, LearningScreenState>(
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
            if (state.status == LearningScreenStatus.finish) ...[
              LearningPanelFinish(
                onFinished: () {
                  context.read<LearningScreenBloc>().add(const FinishEvent());
                },
              ),
              // call the function to delete temp deck
            ],
            if (state.status == LearningScreenStatus.loading) ...[
              const LearningPanelLoading(),
            ],
            if (state.status == LearningScreenStatus.success &&
                state.side == LearningCardSide.front) ...[
              Expanded(
                child: LearningPanelWidget(
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
                      .read<LearningScreenBloc>()
                      .add(const RevealCardEvent());
                },
                child: const Text(
                  'Reveal',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
            if (state.status == LearningScreenStatus.success &&
                state.side == LearningCardSide.back) ...[
              Expanded(
                  child: LearningPanelWidget(
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
                          .read<LearningScreenBloc>()
                          .add(const SubmitButtonsPressed(difficulty: 'easy'));
                    },
                    child: const Text(
                      'Easy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    ),
                    onPressed: () {
                      // emit the LearningScreenSubmitButtonPressed event
                      context.read<LearningScreenBloc>().add(
                          const SubmitButtonsPressed(difficulty: 'medium'));
                    },
                    child: const Text(
                      'Medium',
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
                          .read<LearningScreenBloc>()
                          .add(const SubmitButtonsPressed(difficulty: 'hard'));
                    },
                    child: const Text(
                      'Hard',
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
