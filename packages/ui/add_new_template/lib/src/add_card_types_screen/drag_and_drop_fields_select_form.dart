import 'package:flutter/material.dart';

class DragAndDropFieldsSelectForm extends StatelessWidget {
  final List<String> availableFields;
  final List<String> frontFields;
  final List<String> backFields;

  final void Function(String) onFrontFieldAdded;
  final void Function(String) onBackFieldAdded;
  final void Function(String) onFrontFieldRemoved;
  final void Function(String) onBackFieldRemoved;

  const DragAndDropFieldsSelectForm({
    super.key,
    required this.availableFields,
    required this.frontFields,
    required this.backFields,
    required this.onFrontFieldAdded,
    required this.onBackFieldAdded,
    required this.onFrontFieldRemoved,
    required this.onBackFieldRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Fields'),
        _AvailableFieldsList(availableFields: availableFields),
        const SizedBox(height: 16),
        const Text('Front Fields'),
        _ChosenFieldsList(
          fields: frontFields,
          onAdded: onFrontFieldAdded,
          onRemoved: onFrontFieldRemoved,
        ),
        const SizedBox(height: 16),
        const Text('Back Fields'),
        _ChosenFieldsList(
          fields: backFields,
          onAdded: onBackFieldAdded,
          onRemoved: onBackFieldRemoved,
        ),
      ],
    );
  }
}

class _AvailableFieldsList extends StatelessWidget {
  final List<String> availableFields;

  const _AvailableFieldsList({
    required this.availableFields,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var field in availableFields)
          Draggable<String>(
            data: field,
            feedback: Material(
              child: Chip(
                label: Text(field),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Chip(
                label: Text(field),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChosenFieldsList extends StatelessWidget {
  final List<String> fields;
  final void Function(String) onAdded;
  final void Function(String) onRemoved;

  const _ChosenFieldsList({
    required this.fields,
    required this.onAdded,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final color = candidateData.isEmpty
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          constraints: const BoxConstraints(
            minHeight: 50,
            minWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            children: [
              for (var field in fields)
                Draggable<String>(
                  data: field,
                  feedback: Material(
                    child: Chip(
                      label: Text(field),
                    ),
                  ),
                  child: Chip(
                    label: Text(field),
                    deleteIcon: const Icon(Icons.cancel),
                    onDeleted: () => onRemoved(field),
                  ),
                ),
            ],
          ),
        );
      },
      onAcceptWithDetails: (details) => onAdded(details.data),
    );
  }
}
