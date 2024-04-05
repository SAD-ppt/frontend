import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class NoteField extends Equatable {
  final Uuid noteId;
  final String orderNumber;
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
  final Uuid id;
  final String noteTemplateId;

  const Note({
    required this.id,
    required this.noteTemplateId,
  });

  @override
  List<Object> get props => [id, noteTemplateId];
}
