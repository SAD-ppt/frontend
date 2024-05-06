import 'package:equatable/equatable.dart';

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
