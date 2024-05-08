import 'package:equatable/equatable.dart';

class NoteTag extends Equatable {
  final String name;
  final String noteId;
  final String? color;

  const NoteTag({
    required this.name,
    required this.noteId,
    this.color,
  });

  @override
  List<Object> get props => [noteId, name];
}
