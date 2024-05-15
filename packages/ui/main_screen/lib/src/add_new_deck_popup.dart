import 'package:flutter/material.dart';

class AddNewDeckPopup extends StatelessWidget {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final Function(String, String) _onAddDeck;

   AddNewDeckPopup({super.key, required Function(String, String) onAddDeck})
      : _onAddDeck = onAddDeck;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new deck'),
      content: 
        // Add a text field to enter the deck name and a text field to enter the deck description
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controllerName,
              decoration: const InputDecoration(
                labelText: 'Deck name',
              ),
            ),
            TextField(
              controller: _controllerDescription,
              decoration: const InputDecoration(
                labelText: 'Deck description',
              ),
            ),
          ],
              ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            _onAddDeck(_controllerName.text, _controllerDescription.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
