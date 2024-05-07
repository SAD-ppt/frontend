import 'package:equatable/equatable.dart';

class CardTag extends Equatable {
  final String name;
  final String cardId;
  final String? color;

  const CardTag({
    required this.name,
    required this.cardId,
    this.color,
  });

  @override
  List<Object> get props => [cardId, name];
}
