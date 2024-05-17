import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

extension ToMapDeck on Deck {
  Map<String, dynamic> toMap() {
    return {
      'UniqueID': id,
      'Name': name,
      'Description': description,
    };
  }
}

class DeckApiHandler implements DeckApi {
  final Database db;
  const DeckApiHandler({required this.db});
  @override
  Future<Deck> createDeck(String name, String description, {String? deckId}) async {
    deckId ??= const Uuid().v4();
    await db.insert('Deck', {
      'UniqueID': deckId,
      'Name': name,
      'Description': description,
    });
    return Deck(id: deckId, name: name, description: description);
  }

  @override
  Future<void> deleteDeck(String id) async {
    await db.delete('Deck', where: 'UniqueID = ?', whereArgs: [id]);
  }

  @override
  Future<Deck> getDeck(String id) {
    return db.rawQuery(
        'SELECT UniqueID, Name, Description FROM Deck WHERE UniqueID = ?',
        [id]).then((value) {
      if (value.isEmpty) {
        throw Exception('Deck not found');
      }
      return Deck(
          id: value[0]['UniqueID'].toString(),
          name: value[0]['Name'].toString(),
          description: value[0]['Description'].toString());
    });
  }

  @override
  Future<Deck> getDeckAndCards(String id) {
    // TODO: implement getDeckAndCards
    throw UnimplementedError();
  }

  @override
  Stream<List<Deck>> getDecksStream() {
    throw UnimplementedError();
  }

  @override
  Future<Deck> updateDeck(Deck deck) async {
    var res = await db.update('Deck', deck.toMap(),
        where: 'UniqueID = ?', whereArgs: [deck.id]);
    if (res == 0) {
      throw Exception('Failed to update deck ${deck.id}');
    }
    return deck;
  }

  @override
  Future<List<Deck>> getDecks() {
    return db.query('Deck').then((value) {
      if (value.isEmpty) {
        return [];
      }
      return value
          .map((e) => Deck(
              id: e['UniqueID'].toString(),
              name: e['Name'].toString(),
              description: e['Description'].toString()))
          .toList();
    });
  }
}
