import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class Config extends StatelessWidget {
  final String deck;
  final String noteTemplate;
  final List<String> cardTypes;
  final List<String> availableDecks;
  final List<String> availableNoteTemplates;
  final List<String> availableCardTypes;
  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;
  Config(
      {super.key,
      required this.deck,
      required this.noteTemplate,
      required this.cardTypes,
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
      initialItem: deck,
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose deck',
      items: availableDecks,
      onChanged: (p0) => onDeckChanged(p0),
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: Colors.grey),
        expandedBorder: Border.all(color: Colors.grey),
        closedBorderRadius: BorderRadius.zero,
        expandedBorderRadius: BorderRadius.zero,
      ),
    );
    var chooseTemplateTitle = Text("Template", style: fieldHeaderTextStyle);
    var chooseCardTypesTitle = Text("Card types", style: fieldHeaderTextStyle);
    var chooseTemplate = CustomDropdown<String>.search(
      initialItem: noteTemplate,
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose template',
      items: availableNoteTemplates,
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
    var chooseCardTypes = CustomDropdown<String>.multiSelectSearch(
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose card type(s)',
      items: availableCardTypes,
      onListChanged: (p0) => onCardTypesChanged(p0),
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(flex: 2, child: chooseCardTypesTitle),
          Flexible(flex: 4, child: chooseCardTypes),
        ]),
        const SizedBox(height: 20),
      ],
    );
  }
}
