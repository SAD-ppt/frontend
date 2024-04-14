import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './card_form.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CardForm(
          deck: 'deck',
          noteTemplate: 'noteTemplate',
          cardTypes: ['cardTypes'],
          fieldNames: [
            'field1',
            'field2',
            'field3',
            'field4',
            'field5',
            'field6',
            'field7',
          ],
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
          tagsList: [
            "English",
            "Chinese",
            "日本語",
          ],
          onTagsChanged: (p0) {},
        ),
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
