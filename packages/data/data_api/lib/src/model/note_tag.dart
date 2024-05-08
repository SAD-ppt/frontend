import 'package:equatable/equatable.dart';

class NoteTag extends Equatable {
  final String name;
  final String cardId;
  final String? color;

  const NoteTag({
    required this.name,
    required this.cardId,
    this.color,
  });

  @override
  List<Object> get props => [cardId, name];
}
