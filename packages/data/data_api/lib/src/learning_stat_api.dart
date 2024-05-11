import 'package:data_api/src/model/learning_stat.dart';
import 'model/card.dart';

abstract interface class LearningStatApi {
  /// Get the learning stat of the card with the given [key].
  Future<LearningStatDetail?> getLearningStatOfCard(
    CardKey key,
  );
  Future<void> createLearningStat(CardKey key);
  Future<void> addLearningResult(CardKey key, String result, {DateTime? time});
  Future<void> deleteLearningStat(CardKey key);
}
