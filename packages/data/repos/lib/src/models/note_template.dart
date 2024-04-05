import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'card_template.dart';

@immutable
class NoteTemplate extends Equatable {
  final Uuid id;
  final List<String> fieldNames;
  final List<CardTemplate> associatedCardTemplates;

  const NoteTemplate({
    required this.id,
    required this.fieldNames,
    required this.associatedCardTemplates,
  });

  get getId => id;

  @override
  List<Object?> get props => [id, fieldNames, associatedCardTemplates];
}
