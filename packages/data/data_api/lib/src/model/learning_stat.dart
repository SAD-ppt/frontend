import 'package:data_api/src/model/learning_result.dart';
import 'package:equatable/equatable.dart';

class LearningStat extends Equatable {
  final String cardId;

  const LearningStat({
    required this.cardId,
  });

  @override
  List<Object?> get props => [cardId];
}

class LearningStatDetail extends Equatable {
  final LearningStat learningStat;
  final List<LearningResult> results;

  const LearningStatDetail({
    required this.learningStat,
    required this.results,
  });

  @override
  List<Object?> get props => [learningStat, results];
}
