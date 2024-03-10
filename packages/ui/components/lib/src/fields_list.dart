import 'dart:ffi';

import 'package:flutter/material.dart';

class FieldsList extends StatelessWidget {
  final List<String> fieldLabels;
  final Function(List<String>) onFieldsChanged;
  final double spacing;
  const FieldsList(
      {super.key,
      this.spacing = 8.0,
      required this.fieldLabels,
      required this.onFieldsChanged});
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var (i, e) in fieldLabels.indexed) {
      children.add(_Field(
          label: e,
          onChanged: (value) {
            final newFields = fieldLabels.map((field) {
              if (field == e) {
                return value;
              }
              return field;
            }).toList();
            onFieldsChanged(newFields);
          }));
      if (i < fieldLabels.length - 1) {
        children.add(SizedBox(height: spacing));
      }
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

class _Field extends StatelessWidget {
  final String label;
  final void Function(String)? onChanged;
  const _Field({required this.label, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Flexible(
          child: TextField(
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
