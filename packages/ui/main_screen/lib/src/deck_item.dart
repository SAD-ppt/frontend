// Create a class to render the deck item in the main screen

import 'package:flutter/material.dart';

class DeckItem extends StatelessWidget {
  const DeckItem({
    Key? key,
    required this.deck,
    required this.description,
    required this.onTap,
    required this.onReviewDeck,
    required this.onTestDeck,
  }) : super(key: key);

  final String deck;
  final String description;
  final VoidCallback onTap;
  final VoidCallback onReviewDeck;
  final VoidCallback onTestDeck;

  @override
  Widget build(BuildContext context) {
    // Each item is a rectangle box, inside the box, there is title of the deck, brief description of the deck, and 2 buttons, review and test
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Card(
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
                  onPressed: onReviewDeck,
                  child: const Text('Review'),
                ),
                TextButton(
                  onPressed: onTestDeck,
                  child: const Text('Test'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
