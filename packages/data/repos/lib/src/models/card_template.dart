import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CardTemplate extends Equatable {
  final String id;
  get getId => id;
  final String name;
  final List<String> front;
  final List<String> back;

  const CardTemplate({
    required this.id,
    required this.name,
    required this.front,
    required this.back,
  });

  @override
  List<Object> get props => [id, name, front, back];
}
