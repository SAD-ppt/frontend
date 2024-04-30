import 'package:add_new_card/src/bloc/bloc.dart';
import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:add_new_card/src/view/view/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './card_form.dart';

class AddNewCardPage extends StatelessWidget {
  const AddNewCardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddNewCardBloc()..add(InitialEvent()),
        child: _AddNewCardView());
  }
}

class _AddNewCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCardBloc, AddNewCardState>(
        builder: (context, state) {
      if (state.status == Status.loading || state.status == Status.changing) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add new card'),
            leading: const BackButton(),
          ),
          body: const Loading(),
        );
      } else {
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
              deck: state.deck,
              noteTemplate: state.noteTemplate,
              cardTypes: state.cardTypes,
              fieldNames: state.fieldNames,
              onDeckChanged: (value) =>
                  {context.read<AddNewCardBloc>().add(DeckChanged(value))},
              onNoteTemplateChanged: (value) => {
                context.read<AddNewCardBloc>().add(NoteTemplateChanged(value))
              },
              onCardTypesChanged: (value) =>
                  {context.read<AddNewCardBloc>().add(CardTypesChanged(value))},
              onFieldsChanged: (value) => null,
              availableDecks: state.availableDecks,
              availableNoteTemplates: state.availableNoteTemplates,
              availableCardTypes: state.availableCardTypes,
              availableTagsList: state.availableTagsList,
              tagsList: state.tagsList,
              onTagsChanged: (p0) {
                context.read<AddNewCardBloc>().add(TagsChanged(p0));
              },
              onAddNewAvailableTag: (p0) {
                context.read<AddNewCardBloc>().add(AddNewAvailableTag(p0));
              },
              // onTagsTriggered: () {
              //   context.read<AddNewCardBloc>().add(TagsTriggered());
              // },
            ),
          ),
        );
      }
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
