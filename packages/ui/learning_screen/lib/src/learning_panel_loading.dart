import 'package:flutter/material.dart';

class LearningPanelLoading extends StatelessWidget {
  const LearningPanelLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}