import 'package:flutter/material.dart';

class LearningPanelFinish extends StatelessWidget {
  const LearningPanelFinish({
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
            'You have completed the learning session.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
