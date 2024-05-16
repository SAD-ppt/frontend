import 'package:flutter/material.dart';

class CardTypeName extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const CardTypeName({super.key, this.onChanged, this.onSubmitted});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: const InputDecoration(hintText: 'Card Type Name'),
        onChanged: onChanged,
      ),
    );
  }
}
