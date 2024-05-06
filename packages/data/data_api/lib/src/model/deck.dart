import 'package:equatable/equatable.dart';
import 'package:uuid/v4.dart';

class Deck extends Equatable {
  final String id;
  final String name;

  const Deck({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
