import 'package:flutter/material.dart';

class TagsSelection extends StatelessWidget {
  const TagsSelection({
    super.key,
    required this.tagsList,
    required this.availableTagsList,
    required this.onAddTag,
    required this.onRemoveTag,
  });

  final List<String> tagsList;
  final List<String> availableTagsList;
  final Function(List<String>) onAddTag;
  final Function(List<String>) onRemoveTag;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableTagsList
          .map((tag) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tag),
                  Checkbox(
                    value: tagsList.contains(tag),
                    onChanged: (value) {
                      if (value == true) {
                        tagsList.remove(tag);
                        onAddTag(tagsList);
                      } else {
                        tagsList.add(tag);
                        onRemoveTag(tagsList);
                      }
                    },
                  ),
                ],
              ))
          .toList(),
    );
  }
}
