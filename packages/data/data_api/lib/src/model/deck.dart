import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Deck extends Equatable {
  final Uuid id;
  final String name;

  const Deck({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
