import 'package:flutter/material.dart';

class TestingPanelLoading extends StatelessWidget {
  const TestingPanelLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}