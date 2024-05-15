import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class LearningStatApiHandler implements LearningStatApi {
  final Database db;
  const LearningStatApiHandler({required this.db});
  @override
  Future<void> addLearningResult(CardKey key, String result, {DateTime? time}) {
    return db.insert('LearningResult', {
      'DeckID': key.deckId,
      'NoteID': key.noteId,
      'CardTemplateID': key.cardTemplateId,
      'Result': result,
      'Time': time?.toIso8601String(),
    }).then((value) {
      return Future.value();
    });
  }

  @override
  Future<void> createLearningStat(CardKey key) {
    return db.insert('LearningStat', {
      'DeckID': key.deckId,
      'NoteID': key.noteId,
      'CardTemplateID': key.cardTemplateId,
    }).then((value) {
      return Future.value();
    });
  }

  @override
  Future<void> deleteLearningStat(CardKey key) {
    return db.delete('LearningResult',
        where: 'DeckID = ? AND NoteID = ? AND CardTemplateID = ?',
        whereArgs: [key.deckId, key.noteId, key.cardTemplateId]).then((value) {
      return db.delete(
        'LearningStat',
        where: 'DeckID = ? AND NoteID = ? AND CardTemplateID = ?',
        whereArgs: [key.deckId, key.noteId, key.cardTemplateId],
      ).then((value) => Future.value());
    });
  }

  @override
  Future<LearningStatDetail?> getLearningStatOfCard(CardKey key) {
    return db.query('LearningResult',
        where: 'DeckID = ? AND NoteID = ? AND CardTemplateID = ?',
        whereArgs: [key.deckId, key.noteId, key.cardTemplateId]).then((value) {
      if (value.isEmpty) {
        return Future.value(null);
      }
      return Future.value(LearningStatDetail(
        learningStat: LearningStat(cardId: key),
        results: value
            .map((e) => LearningResult(
                  cardId: key,
                  result: e['Result'].toString(),
                  time: DateTime.parse(e['Time'].toString()),
                ))
            .toList(),
      ));
    });
  }
}
