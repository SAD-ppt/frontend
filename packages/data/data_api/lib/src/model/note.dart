import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NoteField extends Equatable {
  final String noteId;
  final int orderNumber;
  final String value;

  const NoteField({
    required this.noteId,
    required this.orderNumber,
    required this.value,
  });

  @override
  List<Object> get props => [orderNumber, noteId, value];
}

class Note extends Equatable {
  final String id;
  final String noteTemplateId;

  const Note({
    required this.id,
    required this.noteTemplateId,
  });

  @override
  List<Object> get props => [id, noteTemplateId];
}

@immutable
class NoteDetail extends Equatable {
  final Note note;
  final List<NoteField> fields;
  final List<String> tags;

  const NoteDetail({
    required this.note,
    required this.fields,
    required this.tags,
  });

  @override
  List<Object> get props => [note, fields, tags];
}
