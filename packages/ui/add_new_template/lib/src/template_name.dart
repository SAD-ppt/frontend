import 'package:flutter/material.dart';

class TemplateName extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const TemplateName({super.key, this.onChanged, this.onSubmitted});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Text(
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(fontSizeDelta: -4),
              'Name'),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            decoration: const InputDecoration(
                hintText: 'Template Name', border: OutlineInputBorder()),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
