import 'package:flutter/material.dart';

class TestingPanelFinish extends StatelessWidget {
  final void Function() onFinished;
  const TestingPanelFinish({
    required this.onFinished,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Text(
            'Congratulations!',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'You have completed the testing session.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onFinished,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Back to main screen', style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
    );
  }
}
