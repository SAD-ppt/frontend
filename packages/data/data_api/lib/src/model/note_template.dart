import 'package:equatable/equatable.dart';

class NoteTemplateField extends Equatable {
  final String noteTemplateId;
  final int orderNumber;
  final String name;

  const NoteTemplateField({
    required this.noteTemplateId,
    required this.orderNumber,
    required this.name,
  });

  @override
  List<Object> get props => [orderNumber, noteTemplateId, name];
}

class NoteTemplate extends Equatable {
  final String id;
  final String name;

  const NoteTemplate({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}

class NoteTemplateDetail extends Equatable {
  final NoteTemplate noteTemplate;
  final List<NoteTemplateField> fields;

  const NoteTemplateDetail({
    required this.noteTemplate,
    required this.fields,
  });

  @override
  List<Object> get props => [noteTemplate, fields];
}
