import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:main_screen/src/add_new_deck_popup.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenBloc(),
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
        drawer: Drawer(
          // Add a list of drawer items
          child: ListView(
            children: [
              // Profile item on the top of the drawer
              UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                accountName: const Text('User Name'),
                accountEmail: const Text('username@gmail.com'),
                // Add a onDetailsPressed function to the widget
                onDetailsPressed: onDetailsPressed,
              ),
              // Add statistics, shared_deck and templates items
              DrawerItem(
                icon: Icons.bar_chart,
                title: 'Statistics',
                onTap: () => null,
              ),
              DrawerItem(
                icon: Icons.download_sharp,
                title: 'Shared Decks',
                onTap: () => null,
              ),
              DrawerItem(
                icon: Icons.format_list_bulleted,
                title: 'Templates',
                onTap: () => null,
              ),
              // Add a divider
              const Divider(),
              // Add settings and logout items
              DrawerItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () => null,
              ),
              DrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => null,
              ),
            ],
          ),
        ),
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
