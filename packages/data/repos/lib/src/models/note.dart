import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Note extends Equatable {
  final String id;
  get getId => id;

  final List<(String name, String value)> fields;
  final List<String> tags;

  const Note({
    required this.id,
    required this.fields,
    required this.tags,
  });

  @override
  List<Object> get props => [id, fields, tags];
}
