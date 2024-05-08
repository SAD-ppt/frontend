import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Card extends Equatable {
  final List<(String name, String data, bool isFront)> front;
  final List<(String name, String data, bool isFront)> back;

  const Card({
    required this.front,
    required this.back,
  });

  @override
  List<Object> get props => [front, back];
}
