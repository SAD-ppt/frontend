import 'package:flutter/material.dart';
import 'package:main_screen/src/drawer_item.dart';
import 'package:main_screen/src/deck_item.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _MainScreenView();
  }
}

class _MainScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              accountName: Text('User Name'),
              accountEmail: Text('username@gmail.com'),
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
          children: [
            // Add a deck item
            DeckItem(
              deck: 'Deck 1',
              onTap: () => null,
            ),
            DeckItem(
              deck: 'Deck 2',
              onTap: () => null,
            ),
            DeckItem(
              deck: 'Deck 3',
              onTap: () => null,
            ),
            DeckItem(
              deck: 'Deck 4',
              onTap: () => null,
            ),
            DeckItem(
              deck: 'Deck 5',
              onTap: () => null,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add_box),
                    title: Text('Add New Deck'),
                    onTap: () {
                      // Handle add new deck
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle),
                    title: Text('Add New Card'),
                    onTap: () {
                      // Handle add new card
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Add New Template'),
                    onTap: () {
                      // Handle add new template
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onDetailsPressed() {
    // Add the implementation of the onDetailsPressed function
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
