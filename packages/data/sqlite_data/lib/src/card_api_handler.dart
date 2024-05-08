import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

extension ToMap on Card {
  Map<String, dynamic> toMap() {
    return {
      'DeckID': deckId,
      'CardTemplateID': cardTemplateId,
      'NoteTemplateID': 'noteTemplateId',
    };
  }
}

extension FromMap on Map<String, dynamic> {
  Card toCard() {
    return Card(
      deckId: this['DeckID'],
      cardTemplateId: this['CardTemplateID'],
      noteId: this['NoteID'],
    );
  }
}

class CardApiHandler implements CardApi {
  final Database db;
  const CardApiHandler({required this.db});

  @override
  Future<Card> createCard(Card card) async {
    // Create a new card to the database
    await db.insert(
      'Card',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return card;
  }

  @override
  Future<int> getNumCardsInDeck(String id) {
    // Get the number of cards in a deck
    return db.query('Card',
        where: 'DeckID = ?', whereArgs: [id]).then((value) => value.length);
  }

  @override
  Future<CardDetail> getCard(CardKey key) async {
    db.query('Card',
        where: 'DeckID = ? AND CardTemplateID = ? AND NoteID = ?',
        whereArgs: [key.deckId, key.cardTemplateId, key.noteId]).then((value) {
      if (value.isEmpty) {
        throw Exception('Card not found');
      }
      return value.first.toCard();
    });
    throw Exception('Card not found');
  }

  @override
  Future<List<CardDetail>> getCards(
      {String? deckId, List<String>? tags}) async {
    // If tags is null, get all cards in the deck
    if (tags == null) {
      await db.query('Card', where: 'DeckID = ?', whereArgs: [deckId]).then(
          (value) {
        return value.map((e) => e.toCard()).toList();
      });
      throw Exception('No cards found');
    } else {
      // Get all cards in the deck with the specified tags, by joining the Card and Tag tables using NoteID, having all tags in the list
      await db.rawQuery(
          'SELECT * FROM Card JOIN Tag ON Card.NoteID = Tag.NoteID WHERE DeckID = ? AND Name IN (?) GROUP BY Card.NoteID HAVING COUNT(*) = ?',
          [deckId, tags, tags.length]).then((value) {
        return value.map((e) => e.toCard()).toList();
      });
      throw Exception('No cards found');
    }
  }

  @override
  Stream<List<CardDetail>> getCardsStream(
      {String? deckId, List<String>? tags}) {
    // TODO: implement getCardsStream
    throw UnimplementedError();
  }
}
