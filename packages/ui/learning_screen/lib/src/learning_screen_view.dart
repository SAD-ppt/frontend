import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_screen/src/bloc/bloc.dart';
import 'package:learning_screen/src/bloc/event.dart';
import 'package:learning_screen/src/bloc/state.dart';
import 'package:learning_screen/src/learning_panel_widget.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LearningScreenBloc(),
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
            if (state.side == LearningCardSide.front) ...[
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
            if (state.side == LearningCardSide.back) ...[
              Expanded(
                  child: LearningPanelWidget(
                      cardInfo: state.cardInfo ?? const CardInfo.empty())),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                    ),
                    onPressed: null,
                    child: Text(
                      'Easy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    ),
                    onPressed: null,
                    child: Text(
                      'Medium',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: null,
                    child: Text(
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
