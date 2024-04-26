import 'package:add_new_card/src/bloc/bloc.dart';
import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './card_form.dart';

class AddNewCardPage extends StatelessWidget {
  const AddNewCardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddNewCardBloc(), child: _AddNewCardView());
  }
}

class _AddNewCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCardBloc, AddNewCardState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: _TitleBar(
            onDone: () => context.read<AddNewCardBloc>().add(SubmitCard()),
            onMore: () => null,
          ),
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardForm(
            deck: 'deck',
            noteTemplate: 'noteTemplate',
            cardTypes: const ['cardTypes'],
            fieldNames: const [
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
            availableDecks: const [
              'Deck1',
              'Deck2',
            ],
            availableNoteTemplates: const [
              'Template1',
              'Template2',
              'Template3',
            ],
            availableCardTypes: const ['availableCardTypes1', 'availableCardTypes2'],
            tagsList: const [
              "English",
              "Chinese",
              "日本語",
            ],
            onTagsChanged: (p0) {},
            onTagsTriggered: (p0) {},
          ),
        ),
      );
    });
  }
}

class _TitleBar extends StatelessWidget {
  final Function() onDone;
  final Function() onMore;
  const _TitleBar({
    required this.onDone,
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
            IconButton(onPressed: onDone, icon: const Icon(Icons.done)),
            IconButton(onPressed: onMore, icon: const Icon(Icons.more_vert)),
          ],
        )
      ],
    );
  }
}
