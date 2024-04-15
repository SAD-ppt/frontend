import 'dart:math';

import 'package:flutter/material.dart';
import 'package:card_browser/src/status_bar.dart';

const double cardSize = 150;

class BodyCardBrowser extends StatelessWidget {
  
  final List<String> content;

  final int total;
  final int memorized;

  const BodyCardBrowser({
    super.key, 
    
    required this.content,

    required this.total,
    required this.memorized,
  });
  
  @override
  Widget build(BuildContext context) {

  double screenWidth = MediaQuery.of(context).size.width;
  int maxCard = ((screenWidth + 20) / (cardSize + 40)).floor();

    return Column(
    children: [
      StatusBar(allCard: total, memorized: memorized),
      // const Divider(),
      Expanded(
        child: ListView(
          shrinkWrap: true,
          children: createScrollView(content, maxCard),
        ),
      ),
      // const Divider(),
      const _ReviewBar(),
    ],
    );
  }
}

List<Widget> createScrollView(List<String> content, int maxCard) {
  List<_CardRow> result = [];
  for( int i = 0; i < content.length; i += maxCard ) {
    List<_CardWidget> row = [];
    for( int j = i; j < min( content.length, i + maxCard); ++j ) {
      row.add(_CardWidget(name: content[j], definition: maxCard.toString()));
    }
    result.add(_CardRow(cards: row, maxCard: maxCard));
  }
  return result;
}

class _CardWidget extends StatelessWidget {
  
  final String name;
  final String definition;

  const _CardWidget({
    required this.name, 
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: cardSize,
      height: cardSize,

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),

      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(20.0),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name of card
              Text( name, style: const TextStyle( fontWeight: FontWeight.bold ) ),
              const SizedBox(height: 4.0),
              
              // Definition of card
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    definition,
                    style: const TextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
          // Specially for icon button
          Positioned(
            bottom: 0.0, right: 0.0,
            child: IconButton( onPressed: () {}, icon: const Icon(Icons.more_vert) ),
          ),
        ],
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  final List<_CardWidget> cards;
  final int maxCard;

  const _CardRow({
    required this.cards,
    required this.maxCard,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren;

    // Check if the number of cards is less than maxCard
    if (cards.length < maxCard) {
      rowChildren = [
        ...cards,
        for (int i = 0; i < maxCard - cards.length; i++)
          const SizedBox(width: cardSize + 20),
      ];
    } else {
      rowChildren = cards;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rowChildren,
    );
  }
}

class _ReviewBar extends StatelessWidget {

  const _ReviewBar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ReviewBarItem(
            content: 'Review', 
            onClicked: () {},
          ), 
          _ReviewBarItem(
            content: 'Test', 
            onClicked: () {}
          ),
          _ReviewBarItem(
            content: 'Add card', 
            onClicked: () {}
          ), 
        ],
      ),
    );
  }
}

class _ReviewBarItem extends StatelessWidget {
  
  final String content;
  final VoidCallback onClicked;

  const _ReviewBarItem({
    required this.content,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Center(child: Text(content)),
      ),
    );
  }
}