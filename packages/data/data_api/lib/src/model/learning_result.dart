import 'package:equatable/equatable.dart';

/// Record the time which the user has learned a card, and the result of the learning.
class LearningResult extends Equatable {
  final String cardId;
  final DateTime time;
  final String result;

  const LearningResult({
    required this.cardId,
    required this.time,
    required this.result,
  });

  @override
  List<Object?> get props => [cardId, time, result];
}
