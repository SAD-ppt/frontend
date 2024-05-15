import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repos/repos.dart';
import 'package:testing_setup/src/bloc/bloc.dart';
import 'package:testing_setup/src/bloc/event.dart';
import 'package:testing_setup/src/bloc/state.dart';

class TestingSetupScreen extends StatelessWidget {
  const TestingSetupScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestingSetupBloc(
        deckRepository: context.read<DeckRepo>(),
        cardRepository: context.read<CardRepo>(),
        noteRepository: context.read<NoteRepo>(),
      )..add(InitialEvent()
      ),
      child: _TestingSetupView(),
    );
  }
}

const List<String> availableTagsList = ['Tag1', 'Tag2', 'Tag3', 'Tag4', 'Tag5'];
const List<String> availableCardTypesList = ['Type1', 'Type2', 'Type3', 'Type4', 'Type5'];

class _TestingSetupView extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    
    return BlocBuilder<TestingSetupBloc, TestingSetupState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                _Config(
                  availableTagsList: availableTagsList,
                  availableCardTypeList: availableCardTypesList,
                  onSelectedTagsChanged: (tags) => context.read<TestingSetupBloc>().add(SelectedTagsChanged(tags)),
                  onSelectedCardTypeChanged: (cardTypes) => context.read<TestingSetupBloc>().add(SelectedCardTypeChanged(cardTypes)),
                ),
              ],
            ),
          ),
        );
    });
  }
}

class _Config extends StatelessWidget {

  final List<String> availableTagsList;
  final List<String> availableCardTypeList;
  final Function(List<String>) onSelectedTagsChanged;
  final Function(List<String>) onSelectedCardTypeChanged;

  const _Config({
    required this.availableTagsList,
    required this.availableCardTypeList,
    required this.onSelectedTagsChanged,
    required this.onSelectedCardTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Setup configuration
    var fieldHeaderTextStyle = Theme.of(context).textTheme.titleMedium;
    
    var tagTitle = Text('Tag(s)', style: fieldHeaderTextStyle);
    var tagDropdown = CustomDropdown<String>.multiSelectSearch(
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose tag(s)',
      items: availableTagsList,
      onListChanged: (items) => {
        // sort tags alphabetically
        items.sort(),
        // context.read<TestingSetupBloc>().add(SelectedTagsChanged(items)),
        onSelectedTagsChanged(items),
      },
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: Colors.grey),
        expandedBorder: Border.all(color: Colors.grey),
        closedBorderRadius: BorderRadius.zero,
        expandedBorderRadius: BorderRadius.zero,
      )
    );

    var cardTypeTitle = Text('Card types:', style: fieldHeaderTextStyle);
    var cardTypeDropdown = CustomDropdown<String>.multiSelectSearch(
      hideSelectedFieldWhenExpanded: true,
      hintText: 'Choose card type(s)',
      items: availableCardTypesList,
      onListChanged: (items) => {
        // sort tags alphabetically
        items.sort(),
        // context.read<TestingSetupBloc>().add(SelectedTagsChanged(items)),
        onSelectedCardTypeChanged(items),
      },
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: Colors.grey),
        expandedBorder: Border.all(color: Colors.grey),
        closedBorderRadius: BorderRadius.zero,
        expandedBorderRadius: BorderRadius.zero,
      )
    );
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: tagTitle),
            Flexible(flex: 4, child: tagDropdown),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: cardTypeTitle),
            Flexible(flex: 4, child: cardTypeDropdown)
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}