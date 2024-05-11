import 'package:flutter/material.dart';
import 'package:main_screen/main_screen.dart';

class MainScreenDrawer extends StatelessWidget {
  const MainScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onDetailsPressed: () => null,
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
    );
  }
}
