import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class Note extends Equatable {
  final Uuid id;
  get getId => id;

  final List<(String name, String value)> fields;

  const Note({
    required this.id,
    required this.fields,
  });

  @override
  List<Object> get props => [id, fields];
}
