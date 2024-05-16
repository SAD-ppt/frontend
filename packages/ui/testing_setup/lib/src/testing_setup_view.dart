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
      )..add(InitialEvent()),
      child: _TestingSetupView(),
    );
  }
}

class _TestingSetupView extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    return BlocBuilder<TestingSetupBloc, TestingSetupState>(
      builder: (context, state) {

        if (state.status == TestingSetupStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if(state.cardList.isEmpty) {
          return _NoCardNotification();
        }

        return _TestingSetupBody(
          onTagsChanged: (tags) => context.read<TestingSetupBloc>().add(SelectedTagsChanged(tags)),
          onCardTypesChanged: (cardTypes) => context.read<TestingSetupBloc>().add(SelectedCardTypeChanged(cardTypes)),
          
          availableTagsList: state.availableTags,
          availableCardTypeList: state.availableCardTypes,
          
          totalFilteredCard: state.totalFilteredCard,

          onStart: () => context.read<TestingSetupBloc>().add(StartEvent()),
          onCancel: () => Navigator.of(context).pop(),
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
        items.sort(),
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
    
    Widget cardTypeDropdown;
    if( availableCardTypeList.isEmpty ) {
      cardTypeDropdown = const Text('No card type available');
    } else {
      cardTypeDropdown = CustomDropdown<String>.multiSelectSearch(
        hideSelectedFieldWhenExpanded: true,
        hintText: 'Choose card type(s)',
        items: availableCardTypeList,
        onListChanged: (items) => {
          items.sort(),
          onSelectedCardTypeChanged(items),
        },
        decoration: CustomDropdownDecoration(
          closedBorder: Border.all(color: Colors.grey),
          expandedBorder: Border.all(color: Colors.grey),
          closedBorderRadius: BorderRadius.zero,
          expandedBorderRadius: BorderRadius.zero,
        )
      );
    }
    
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

class _TestingSetupBody extends StatelessWidget {

  final Function(List<String> tags) onTagsChanged;
  final Function(List<String> cardTypes) onCardTypesChanged;

  final Function() onStart;
  final Function() onCancel;

  final List<String> availableTagsList;
  final List<String> availableCardTypeList;

  final int totalFilteredCard;
  
  const _TestingSetupBody({
    required this.onTagsChanged,
    required this.onCardTypesChanged,

    required this.onStart,
    required this.onCancel,

    required this.availableTagsList,
    required this.availableCardTypeList,

    required this.totalFilteredCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                _Config(
                  availableTagsList: availableTagsList,
                  availableCardTypeList: availableCardTypeList,
                  onSelectedTagsChanged: (tags) => context.read<TestingSetupBloc>().add(SelectedTagsChanged(tags)),
                  onSelectedCardTypeChanged: (cardTypes) => context.read<TestingSetupBloc>().add(SelectedCardTypeChanged(cardTypes)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total cards'),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        totalFilteredCard.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: onCancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onStart,
                      child: const Text('Start'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
  }
}

class _NoCardNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Testing Setup'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        )
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No card available for this deck', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}