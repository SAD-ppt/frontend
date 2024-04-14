import 'package:flutter/material.dart';

class CardName extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const CardName({super.key, this.onChanged, this.onSubmitted});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
                hintText: 'Card Name', border: UnderlineInputBorder()),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
