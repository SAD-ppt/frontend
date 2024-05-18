import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  
  final int allCard;
  final int memorized;

  const StatusBar({
    super.key, 
    required this.allCard,
    required this.memorized,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatusBarItem(name: 'All', number: allCard),
          _StatusBarItem(name: 'Learned', number: memorized),
          _StatusBarItem(name: 'Remained', number: allCard - memorized),
        ],
      ),
    );
  }
}

class _StatusBarItem extends StatelessWidget {
  
  final String name;
  final int number;

  const _StatusBarItem({
    required this.name,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Text('$name: $number'),
    );
  }
}