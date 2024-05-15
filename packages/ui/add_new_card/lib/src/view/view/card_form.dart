import 'package:add_new_card/src/view/view/config.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:repos/repos.dart';

class CardForm extends StatelessWidget {

  final String deckName;
  final String noteTemplateName;
  final List<String> selectedCardTypes;
  final List<String> fieldNames;
  final List<String> tagsList;

  final List<DeckOverview> availableDecks;
  final List<NoteTemplate> availableNoteTemplates;
  final List<CardTemplate> availableCardTypes;
  final List<String> availableTagsList;

  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;
  final Function(List<String>) onFieldsChanged;
  final Function(List<String>) onTagsChanged;
  final Function(String) onAddNewAvailableTag;

  // final VoidCallback onTagsTriggered;
  const CardForm(
      {super.key,
      required this.deckName,
      required this.onDeckChanged,
      required this.noteTemplateName,
      required this.onTagsChanged,
      // required this.onTagsTriggered,
      required this.tagsList,
      required this.availableTagsList,
      required this.selectedCardTypes,
      required this.fieldNames,
      required this.onNoteTemplateChanged,
      required this.onCardTypesChanged,
      required this.onFieldsChanged,
      required this.availableDecks,
      required this.availableNoteTemplates,
      required this.availableCardTypes,
      required this.onAddNewAvailableTag,});
  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    var newTagTextField = TextField(controller: controller);
    return ListView(
      children: [
        Config(
          deckName: deckName,
          noteTemplateName: noteTemplateName,
          selectedCardTypes: selectedCardTypes,
          availableDecks: availableDecks,
          availableNoteTemplates: availableNoteTemplates,
          availableCardTypes: availableCardTypes,
          onCardTypesChanged: onCardTypesChanged,
          onNoteTemplateChanged: onNoteTemplateChanged,
          onDeckChanged: onDeckChanged,
        ),
        Column(
          children: fieldNames
              .map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(e), const TextField()],
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () {
              // Show a dialog to add a new tag
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add new tag'),
                      content: newTagTextField,
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                onAddNewAvailableTag(controller.text);
                              }
                              else {
                                // Show a snackbar to inform the user that the tag name is empty
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tag name cannot be empty'),
                                  ),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add')),
                      ],
                    );
                  });
            }, icon: const Icon(Icons.add)),
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
