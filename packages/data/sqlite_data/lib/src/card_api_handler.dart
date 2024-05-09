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
    // return await db.query('Card',
    //     where: 'DeckID = ? AND CardTemplateID = ? AND NoteID = ?',
    //     whereArgs: [key.deckId, key.cardTemplateId, key.noteId]).then((value) {
    //   if (value.isEmpty) {
    //     throw Exception('Card not found');
    //   }
    //   // Create Card
    //   Card card = value[0].toCard();
    //   // CardTemplateDetail
    //   CardTemplateDetail cardTemplate = await db.query('CardTemplate',
    //       where: 'UniqueID = ?', whereArgs: [card.cardTemplateId]).then(
    //       (value) {
    //     if (value.isEmpty) {
    //       throw Exception('CardTemplate not found');
    //     }
    //     return value[0].toCardTemplate();
    //   });
    // });
    throw UnimplementedError();
  }

  @override
  Future<List<CardDetail>> getCards(
      {String? deckId, List<String>? tags}) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<CardDetail>> getCardsStream(
      {String? deckId, List<String>? tags}) {
    // TODO: implement getCardsStream
    throw UnimplementedError();
  }
}
