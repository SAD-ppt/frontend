import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  final List<String> tags;
  final Function(List<String>) onTagsChanged;
  const Tags({super.key, required this.tags, required this.onTagsChanged});
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: tags
              .map((e) => Chip(
                    label: Text(e),
                    onDeleted: () => onTagsChanged(
                        tags.where((element) => element != e).toList()),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
