import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:main_screen/src/add_new_deck_popup.dart';
import 'package:main_screen/src/drawer.dart';
import 'package:repos/repos.dart';
// import 'package:repos/repos.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenBloc(deckRepo: context.read<DeckRepo>()),
      child: _MainScreenView(),
    );
  }
}

class _MainScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: _SearchBar(
            onSearch: () => null,
          ),
        ),
        drawer: const MainScreenDrawer(), 
        body: Center(
          // List of decks
          child: ListView(
            padding: const EdgeInsets.all(20),
            // get the list of decks from bloc
            children: state.decks
                .map(
                  (deck) => DeckItem(
                    deck: deck.name,
                    description: deck.deckDescription,
                    onTap: () => null,
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
            _onAddButtonPressed(context);
            },
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  void onDetailsPressed() {
    // Add the implementation of the onDetailsPressed function
  }

  void _onAddButtonPressed(BuildContext context) {
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
                onTap: () {
                  // Handle add new card
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Add New Template'),
                onTap: () {
                  // Handle add new template
                  Navigator.pop(context);
                },
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

class _SearchBar extends StatelessWidget {
  final void Function() onSearch;

  const _SearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
      ],
    );
  }
}
