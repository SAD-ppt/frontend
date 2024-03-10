import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Config extends StatelessWidget {
  final List<String> availableDecks;
  final List<String> availableNoteTemplates;
  final List<String> availableCardTypes;
  final Function(String) onDeckChanged;
  final Function(String) onNoteTemplateChanged;
  final Function(List<String>) onCardTypesChanged;
  Config(
      {super.key,
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
    var chooseDeck = DropdownMenu(
        textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        expandedInsets: EdgeInsets.zero,
        dropdownMenuEntries: availableDecks
            .map((e) => DropdownMenuEntry(value: e, label: e))
            .toList());
    var chooseTemplateTitle = Text("Template", style: fieldHeaderTextStyle);
    var chooseCardTypesTitle = Text("Card types", style: fieldHeaderTextStyle);
    var chooseTemplate = DropdownMenu(
      textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      expandedInsets: EdgeInsets.zero,
      dropdownMenuEntries: availableNoteTemplates
          .map((e) => DropdownMenuEntry(value: e, label: e))
          .toList(),
    );
    var chooseCardTypes = DropdownMenu(
        expandedInsets: EdgeInsets.zero,
        textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        dropdownMenuEntries: availableCardTypes
            .map((e) => DropdownMenuEntry(value: e, label: e))
            .toList());
    return Column(
      children: [
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
      ],
    );
  }
}
