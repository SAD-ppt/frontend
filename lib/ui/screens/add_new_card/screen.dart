import 'package:flutter/material.dart';

class AddNewCardPage extends StatelessWidget {
  const AddNewCardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _AddNewCardView();
  }
}

class _AddNewCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _TitleBar(
          onBack: () => null,
          onMore: () => null,
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          _CardForm(
            deck: 'deck',
            noteTemplate: 'noteTemplate',
            cardTypes: ['cardTypes'],
            fieldNames: ['field1', 'field2'],
            onDeckChanged: (value) => null,
            onNoteTemplateChanged: (value) => null,
            onCardTypesChanged: (value) => null,
            onFieldsChanged: (value) => null,
            availableDecks: [
              'Deck1',
              'Deck2',
            ],
            availableNoteTemplates: [
              'Template1',
              'Template2',
              'Template3',
            ],
            availableCardTypes: ['availableCardTypes1', 'availableCardTypes2'],
          ),
        ],
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  final Function() onBack;
  final Function() onMore;
  const _TitleBar({
    required this.onBack,
    required this.onMore,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Add new card'),
        Row(
          children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.done)),
            IconButton(onPressed: onMore, icon: const Icon(Icons.more_vert)),
          ],
        )
      ],
    );
  }
}

class _CardForm extends StatelessWidget {
  final String deck;
  final String noteTemplate;
  final List<String> cardTypes;
  final List<String> availableDecks;
  final List<String> availableNoteTemplates;
  final List<String> availableCardTypes;
  final List<String> fieldNames;
  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;
  final Function(List<String>) onFieldsChanged;
  const _CardForm(
      {required this.deck,
      required this.onDeckChanged,
      required this.noteTemplate,
      required this.cardTypes,
      required this.fieldNames,
      required this.onNoteTemplateChanged,
      required this.onCardTypesChanged,
      required this.onFieldsChanged,
      required this.availableDecks,
      required this.availableNoteTemplates,
      required this.availableCardTypes});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Deck"),
            DropdownMenu(
                dropdownMenuEntries: availableNoteTemplates
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList())
          ],
        ),
        Row(
          children: [
            const Text("Template"),
            DropdownMenu(
                dropdownMenuEntries: availableNoteTemplates
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList())
          ],
        ),
        Row(children: [
          const Text("Card types"),
          DropdownMenu(
              dropdownMenuEntries: availableCardTypes
                  .map((e) => DropdownMenuEntry(value: e, label: e))
                  .toList())
        ]),
        Divider(),
        Container(
          constraints: const BoxConstraints.
          child: ListView(
            shrinkWrap: false,
            children: fieldNames
                .map((e) => Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(e), TextField()],
                    )))
                .toList(),
          ),
        ),
        // Container(
        //   constraints: const BoxConstraints.tightFor(),
        //   child: ElevatedButton(
        //     onPressed: () => {},
        //     child: const Text("Tag"),
        //   ),
        // )
      ],
    );
  }
}
