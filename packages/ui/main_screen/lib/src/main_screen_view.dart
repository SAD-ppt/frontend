import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:main_screen/src/add_new_deck_popup.dart';
import 'package:main_screen/src/drawer.dart';
import 'package:repos/repos.dart';
// import 'package:repos/repos.dart';

class MainScreen extends StatelessWidget {
  final void Function() onAddNewCard;
  final void Function() onAddNewTemplate;
  final void Function(String deckId) onDeckSelected;
  const MainScreen(
      {super.key,
      required this.onAddNewCard,
      required this.onAddNewTemplate,
      required this.onDeckSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenBloc(deckRepo: context.read<DeckRepo>())
        ..add(const MainScreenInitial()),
      child: _MainScreenView(
        onDeckSelected: onDeckSelected,
        onAddNewCard: onAddNewCard,
        onAddNewTemplate: onAddNewTemplate,
      ),
    );
  }
}

class _MainScreenView extends StatelessWidget {
  final void Function() onAddNewCard;
  final void Function() onAddNewTemplate;
  final void Function(String deckId) onDeckSelected;
  const _MainScreenView(
      {required this.onAddNewCard,
      required this.onAddNewTemplate,
      required this.onDeckSelected});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
            title: SizedBox(
          height: 45,
          child: SearchBar(
            hintText: 'Search for decks',
            // no shadow
            elevation: const WidgetStatePropertyAll<double>(0),

            onChanged: (value) =>
                context.read<MainScreenBloc>().add(MainScreenSearch(value)),
          ),
        )),
        drawer: const MainScreenDrawer(),
        body: Center(
          // List of decks
          child: ListView(
            padding: const EdgeInsets.all(20),
            // get the list of decks from bloc
            children: state.filteredDecks
                .map(
                  (deck) => DeckItem(
                    deck: deck.name,
                    description: deck.deckDescription,
                    onTap: () => onDeckSelected(deck.id),
                  ),
                )
                .toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // emit the MainScreenAddButtonPressed event
            context
                .read<MainScreenBloc>()
                .add(const MainScreenAddButtonPressed());
            _onAddButtonPressed(context, onAddNewCard, onAddNewTemplate);
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  void _onAddButtonPressed(BuildContext context, void Function() onAddNewCard,
      void Function() onAddNewTemplate) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<MainScreenBloc>(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('Add New Deck'),
                onTap: () {
                  _onAddNewDeck(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle),
                title: const Text('Add New Card'),
                onTap: onAddNewCard,
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Add New Template'),
                onTap: onAddNewTemplate,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddNewDeck(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<MainScreenBloc>(),
          child: AddNewDeckPopup(
            onAddDeck: (deckName, deckDescription) {
              // emit the MainScreenAddNewDeckSubmit event
              context.read<MainScreenBloc>().add(
                    MainScreenAddNewDeckSubmit(
                      deckName: deckName,
                      deckDescription: deckDescription,
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}

