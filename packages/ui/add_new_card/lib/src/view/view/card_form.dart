import 'package:add_new_card/src/view/view/config.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';

class CardForm extends StatelessWidget {
  final String deck;
  final String noteTemplate;
  final List<String> cardTypes;
  final List<String> availableDecks;
  final List<String> availableNoteTemplates;
  final List<String> availableCardTypes;
  final List<String> fieldNames;
  final List<String> tagsList;
  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;
  final Function(List<String>) onFieldsChanged;
  final Function(List<String>) onTagsChanged;
  final Function(List<String>) onTagsTriggered;
  const CardForm(
      {super.key,
      required this.deck,
      required this.onDeckChanged,
      required this.noteTemplate,
      required this.onTagsChanged,
      required this.onTagsTriggered,
      required this.tagsList,
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
    return ListView(
      children: [
        Config(
          availableDecks: availableDecks,
          availableNoteTemplates: availableNoteTemplates,
          availableCardTypes: availableCardTypes,
          onCardTypesChanged: onCardTypesChanged,
          onNoteTemplateChanged: onNoteTemplateChanged,
          onDeckChanged: onDeckChanged,
        ),
        const Divider(),
        Column(
          children: fieldNames
              .map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(e), TextField()],
                  ))
              .toList(),
        ),
        Tags(tags: tagsList, onTagsChanged: onTagsChanged, onTagsTriggered: () {}),
      ],
    );
  }
}
