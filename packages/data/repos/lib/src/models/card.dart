import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/v4.dart';

@immutable
class Card extends Equatable {
  final String id;
  final List<(String name, String data, bool isFront)> front;
  final List<(String name, String data, bool isFront)> back;

  const Card({
    required this.id,
    required this.front,
    required this.back,
  });

  @override
  List<Object> get props => [id, front, back];
}
