// A class to render the item of the drawer in the main screen
// Pass the corresponding icon, title, and onTap function

import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
