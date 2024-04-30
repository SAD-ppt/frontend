import 'package:flutter/material.dart';
import 'package:card_browser/src/component/body_card_browser.dart';

class CardBrowserScreen extends StatelessWidget {
  const CardBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CardBrowserScreenView();
  }
}

// Global variable for future use
const int totalCard = 27;
const int memorizedCard = 3;

const List<String> content = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

class _CardBrowserScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tools bar
      appBar: AppBar(
        title: _ToolsBar(
          onSearch: () => null,
          onFilter: () => null,
          onMore: () => null,
        ),
        leading: const BackButton(),
      ),

      body: 
        const BodyCardBrowser(content: content, total: totalCard, memorized: memorizedCard),
    );
  }
}

class _ToolsBar extends StatelessWidget {
  
  final Function() onSearch;
  final Function() onFilter;
  final Function() onMore;

  const _ToolsBar({
    required this.onSearch,
    required this.onFilter,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search),
          padding: const EdgeInsets.all(10.0),
        ),
        IconButton(
          onPressed: onFilter,
          icon: const Icon(Icons.filter_alt),
          padding: const EdgeInsets.all(10.0),
        ),
        IconButton(
          onPressed: onMore,
          icon: const Icon(Icons.more_vert),
          padding: const EdgeInsets.all(10.0),
        ),
      ],
    );
  }
}
