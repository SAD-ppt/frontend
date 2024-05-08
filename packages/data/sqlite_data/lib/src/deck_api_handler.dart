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
  Future<Deck> createDeck(String name, String description) async {
    Deck deck =
        Deck(id: const Uuid().v4(), name: name, description: description);
    await db.insert('Deck', deck.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return deck;
  }

  @override
  Future<void> deleteDeck(String id) async {
    await db.delete('Deck', where: 'UniqueID = ?', whereArgs: [id]);
  }

  @override
  Future<Deck> getDeck(String id) async {
    await db
        .query('Deck', where: 'UniqueID = ?', whereArgs: [id]).then((onValue) {
      return Deck(
          id: onValue[0]['UniqueID'].toString(),
          name: onValue[0]['Name'].toString(),
          description: onValue[0]['Description'].toString());
    });
    throw Exception('Deck not found');
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
    db.query('Deck').then((onValue) {
      return onValue
          .map((e) => Deck(
              id: e['UniqueID'].toString(),
              name: e['Name'].toString(),
              description: e['Description'].toString()))
          .toList();
    });
    throw Exception('No decks found');
  }
}
