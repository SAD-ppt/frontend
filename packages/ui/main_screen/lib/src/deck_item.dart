// Create a class to render the deck item in the main screen

import 'package:flutter/material.dart';

class DeckItem extends StatelessWidget {
  const DeckItem({
    Key? key,
    required this.deck,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final String deck;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Each item is a rectangle box, inside the box, there is title of the deck, brief description of the deck, and 2 buttons, review and test
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(deck),
            subtitle: Text(description),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => null,
                child: const Text('Review'),
              ),
              TextButton(
                onPressed: () => null,
                child: const Text('Test'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}