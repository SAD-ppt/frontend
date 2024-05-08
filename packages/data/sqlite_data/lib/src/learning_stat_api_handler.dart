import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class LearningStatApiHandler implements LearningStatApi {
  final Database db;
  const LearningStatApiHandler({required this.db});
  @override
  Future<void> addLearningResult(CardKey key, String result, {DateTime? time}) {
    // TODO: implement addLearningResult
    throw UnimplementedError();
  }
  @override
  Future<void> createLearningStat(CardKey key) {
    // TODO: implement createLearningStat
    throw UnimplementedError();
  }
  @override
  Future<void> deleteLearningStat(CardKey key) {
    // TODO: implement deleteLearningStat
    throw UnimplementedError();
  }
  @override
  Future<LearningStatDetail?> getLearningStatOfCard(CardKey key) {
    // TODO: implement getLearningStatOfCard
    throw UnimplementedError();
  }
}
