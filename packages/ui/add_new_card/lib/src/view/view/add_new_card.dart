import 'package:add_new_card/src/bloc/bloc.dart';
import 'package:add_new_card/src/bloc/event.dart';
import 'package:add_new_card/src/bloc/state.dart';
import 'package:add_new_card/src/view/view/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repos/repos.dart';
import './card_form.dart';

class AddNewCardPage extends StatelessWidget {
  final void Function() onDone;
  final void Function() onBack;
  const AddNewCardPage({super.key, required this.onDone, required this.onBack});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddNewCardBloc(
              deckRepository: context.read<DeckRepo>(),
              noteRepository: context.read<NoteRepo>(),
              noteTemplateRepository: context.read<NoteTemplateRepo>(),
            )..add(InitialEvent()),
        child: _AddNewCardView(onDone: onDone, onBack: onBack));
  }
}

class _AddNewCardView extends StatelessWidget {
  final void Function() onDone;
  final void Function() onBack;

  const _AddNewCardView({required this.onDone, required this.onBack});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCardBloc, AddNewCardState>(
        builder: (context, state) {
      if (state.status == Status.loading || state.status == Status.changing) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add new card'),
            leading: BackButton(
              onPressed: onBack,
            ),
          ),
          body: const Loading(),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: _TitleBar(
              onDone: () {
                context.read<AddNewCardBloc>().add(SubmitCard());
                onDone();
              },
              onMore: () => null,
            ),
            leading: const BackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CardForm(
              deckName: state.deckName,
              noteTemplateName: state.noteTemplateName,
              selectedCardTypes: state.selectedCardTypes,
              fieldNames: state.fieldNamesValues.map((e) => e.$1).toList(),
              onDeckChanged: (value) =>
                  {context.read<AddNewCardBloc>().add(DeckChanged(value))},
              onNoteTemplateChanged: (value) => {
                context.read<AddNewCardBloc>().add(NoteTemplateChanged(value))
              },
              onCardFormFieldChanged: (index, value) => {
                context
                    .read<AddNewCardBloc>()
                    .add(FieldValueChanged(index, value))
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
