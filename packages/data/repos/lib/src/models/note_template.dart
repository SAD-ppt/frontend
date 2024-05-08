import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/v4.dart';

import 'card_template.dart';

@immutable
class NoteTemplate extends Equatable {
  final String id;
  final String name;
  final List<String> fieldNames;

  const NoteTemplate({
    required this.id,
    required this.name,
    required this.fieldNames,
  });

  get getId => id;

  @override
  List<Object?> get props => [id, name, fieldNames];
}

@immutable
class NoteTemplateDetail extends Equatable {
  final NoteTemplate noteTemplate;
  final List<CardTemplate> cardTemplates;

  const NoteTemplateDetail({
    required this.noteTemplate,
    required this.cardTemplates,
  });

  @override
  List<Object?> get props => [noteTemplate, cardTemplates];
}
