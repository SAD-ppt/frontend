import 'package:flutter/material.dart';

class CardTypeName extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const CardTypeName({super.key, this.onChanged, this.onSubmitted});
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
                  ?.apply(fontSizeDelta: -6),
              'Name'),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            decoration: const InputDecoration(
                hintText: 'Card Type Name', border: OutlineInputBorder()),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
