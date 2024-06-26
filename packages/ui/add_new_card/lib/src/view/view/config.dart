import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:repos/repos.dart';

class Config extends StatelessWidget {
  
  final String deckName;
  final String noteTemplateName;
  final List<String> selectedCardTypes;

  final List<DeckOverview> availableDecks;
  final List<NoteTemplate> availableNoteTemplates;
  final List<CardTemplate> availableCardTypes;

  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;

  const Config(
      {super.key,
      required this.deckName,
      required this.noteTemplateName,
      required this.selectedCardTypes,
      required this.availableDecks,
      required this.availableNoteTemplates,
      required this.availableCardTypes,
      required this.onDeckChanged,
      required this.onNoteTemplateChanged,
      required this.onCardTypesChanged});

  @override
  Widget build(BuildContext context) {
    var fieldHeaderTextStyle = Theme.of(context).textTheme.titleMedium;
    var chooseDeckTitle = Text("Deck", style: fieldHeaderTextStyle);
    var chooseDeck = CustomDropdown<String>.search(
      initialItem: deckName,
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose deck',
      items: availableDecks.map((deck) => deck.name).toList(),
      onChanged: (p0) => onDeckChanged(p0),
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: Colors.grey),
        expandedBorder: Border.all(color: Colors.grey),
        closedBorderRadius: BorderRadius.zero,
        expandedBorderRadius: BorderRadius.zero,
      ),
    );
    var chooseTemplateTitle = Text("Template", style: fieldHeaderTextStyle);
    var chooseTemplate = CustomDropdown<String>.search(
      initialItem: noteTemplateName,
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose template',
      items: availableNoteTemplates.map((noteTemplate) => noteTemplate.name).toList(),
      onChanged: (p0) => {
        // update the item selected
        onNoteTemplateChanged(p0),
      },
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: Colors.grey),
        expandedBorder: Border.all(color: Colors.grey),
        closedBorderRadius: BorderRadius.zero,
        expandedBorderRadius: BorderRadius.zero,
      ),
    );
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: chooseDeckTitle),
            Flexible(flex: 4, child: chooseDeck),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: chooseTemplateTitle),
            Flexible(flex: 4, child: chooseTemplate)
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 20),
      ],
    );
  }
}
