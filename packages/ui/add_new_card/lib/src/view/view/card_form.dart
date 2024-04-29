import 'package:add_new_card/src/view/view/config.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:components/components.dart';
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
  final List<String> availableTagsList;
  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;
  final Function(List<String>) onFieldsChanged;
  final Function(List<String>) onTagsChanged;
  // final VoidCallback onTagsTriggered;
  const CardForm(
      {super.key,
      required this.deck,
      required this.onDeckChanged,
      required this.noteTemplate,
      required this.onTagsChanged,
      // required this.onTagsTriggered,
      required this.tagsList,
      required this.availableTagsList,
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
                    children: [Text(e), const TextField()],
                  ))
              .toList(),
        ),
        const Divider(),
        const Row(
          children: [
            Text('Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        // Tags(tags: tagsList, onTagsChanged: onTagsChanged),
        CustomDropdown.multiSelectSearch(
          hideSelectedFieldWhenExpanded: true,
          hintText: 'Choose tag(s)',
          items: availableTagsList,
          initialItems: tagsList,
          onListChanged: (p0) => {
            // sort tags alphabetically
            p0.sort(),
            onTagsChanged(p0)
          },
          decoration: CustomDropdownDecoration(
            closedBorder: Border.all(color: Colors.grey),
            expandedBorder: Border.all(color: Colors.grey),
            closedBorderRadius: BorderRadius.zero,
            expandedBorderRadius: BorderRadius.zero,
          ),
        )
      ],
    );
  }
}
