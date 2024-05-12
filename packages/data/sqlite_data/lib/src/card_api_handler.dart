import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

extension ToMap on Card {
  Map<String, dynamic> toMap() {
    return {
      'DeckID': deckId,
      'CardTemplateID': cardTemplateId,
      'NoteID': noteId,
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
  Future<Card> createCard(Card card) {
    return db
        .insert('Card', card.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      return Future.value(card);
    });
  }

  @override
  Future<int> getNumCardsInDeck(String id) {
    // Get the number of cards in a deck
    return db.query('Card',
        where: 'DeckID = ?', whereArgs: [id]).then((value) => value.length);
  }

  @override
  Future<CardDetail> getCard(CardKey key) {
    Card card = const Card(deckId: '', noteId: '', cardTemplateId: '');
    List<NoteTemplateField> noteTemplateFields = [];
    List<CardTemplateField> cardTemplateFields = [];
    List<NoteField> noteFields = [];
    // Get the card
    return db.query('Card',
        where: 'DeckID = ? AND NoteID = ? AND CardTemplateID = ?',
        whereArgs: [
          key.deckId,
          key.noteId,
          key.cardTemplateId
        ]).then((value) async {
      if (value.isEmpty) {
        throw Exception('Card not found');
      }
      card = value[0].toCard();
      await db.rawQuery(
          'SELECT * FROM Note JOIN NoteField ON Note.UniqueID = NoteField.NoteID WHERE Note.UniqueID = ?',
          [key.noteId]).then((value) {
        for (var item in value) {
          noteFields.add(NoteField(
            noteId: item['NoteID'].toString(),
            orderNumber: item['OrderNumber'] as int,
            value: item['RichTextData'].toString(),
          ));
        }
      });
      await db.rawQuery(
          'SELECT Note.NoteTemplateID, NoteTemplateField.OrderNumber, NoteTemplateField.Name FROM Note JOIN NoteTemplate ON Note.NoteTemplateID = NoteTemplate.UniqueID JOIN NoteTemplateField ON NoteTemplate.UniqueID = NoteTemplateField.NoteTemplateID WHERE Note.UniqueID = ?',
          [key.noteId]).then((value) {
        for (var item in value) {
          noteTemplateFields.add(NoteTemplateField(
            noteTemplateId: item['NoteTemplateID'].toString(),
            orderNumber: item['OrderNumber'] as int,
            name: item['Name'].toString(),
          ));
        }
      });
      await db.rawQuery(
          'SELECT CardTemplate.UniqueID, CardTemplateField.OrderNumber, CardTemplateField.Side FROM Card JOIN CardTemplate ON Card.CardTemplateID = CardTemplate.UniqueID JOIN CardTemplateField ON CardTemplate.UniqueID = CardTemplateField.CardTemplateID WHERE Card.DeckID = ? AND Card.NoteID = ? AND Card.CardTemplateID = ?',
          [key.deckId, key.noteId, key.cardTemplateId]).then((value) {
        for (var item in value) {
          cardTemplateFields.add(CardTemplateField(
            cardTemplateId: item['UniqueID'].toString(),
            orderNumber: item['OrderNumber'] as int,
            side: CardSide.values[item['Side'] as int],
          ));
        }
      });
      return Future.value(CardDetail(
          card: card,
          noteTemplateFields: noteTemplateFields,
          cardTemplateFields: cardTemplateFields,
          noteFields: noteFields));
    });
  }

  @override
  Future<List<CardDetail>> getCards({String? deckId, List<String>? tags}) {
    if (deckId == null && tags == null) {
      return getCardsRaw();
    } else if (deckId != null && tags == null) {
      return getCardsByDeckId(deckId);
    } else if (deckId == null && tags != null) {
      return getCardsByTags(tags);
    } else {
      return getCardsByDeckIdAndTags(deckId!, tags!);
    }
  }

  Future<List<CardDetail>> getCardsRaw() {
    List<CardDetail> cards = [];
    return db.query('Card').then((value) async {
      for (var item in value) {
        CardKey key = CardKey(
          deckId: item['DeckID'].toString(),
          noteId: item['NoteID'].toString(),
          cardTemplateId: item['CardTemplateID'].toString(),
        );
        CardDetail card = await getCard(key);
        cards.add(card);
      }
      return Future.value(cards);
    });
  }

  Future<List<CardDetail>> getCardsByDeckId(String deckId) {
    List<CardDetail> cards = [];
    return db.query('Card', where: 'DeckID = ?', whereArgs: [deckId]).then(
        (value) async {
      for (var item in value) {
        CardKey key = CardKey(
          deckId: item['DeckID'].toString(),
          noteId: item['NoteID'].toString(),
          cardTemplateId: item['CardTemplateID'].toString(),
        );
        CardDetail card = await getCard(key);
        cards.add(card);
      }
      return Future.value(cards);
    });
  }

  Future<List<CardDetail>> getCardsByTags(List<String> tags) {
    // Get cards that have all the tags in the list
    List<CardDetail> cards = [];
    return db.rawQuery(
        'SELECT DISTINCT Card.DeckID, Card.NoteID, Card.CardTemplateID FROM Card JOIN Tag ON Card.NoteID = Tag.NoteID WHERE Tag.Name IN (${tags.map((_) => '?').join(',')}) GROUP BY Card.DeckID, Card.NoteID, Card.CardTemplateID HAVING COUNT(*) >= ?',
        [...tags, tags.length]).then((value) async {
      for (var item in value) {
        CardKey key = CardKey(
          deckId: item['DeckID'].toString(),
          noteId: item['NoteID'].toString(),
          cardTemplateId: item['CardTemplateID'].toString(),
        );
        CardDetail card = await getCard(key);
        cards.add(card);
      }
      return Future.value(cards);
    });
  }

  Future<List<CardDetail>> getCardsByDeckIdAndTags(
      String deckId, List<String> tags) {
    // Get cards that have all the tags in the list
    List<CardDetail> cards = [];
    return db.rawQuery(
        'SELECT Card.DeckID, Card.NoteID, Card.CardTemplateID FROM Card JOIN Tag ON Card.NoteID = Tag.NoteID WHERE Card.DeckID = ? AND Tag.Name IN (${tags.map((_) => '?').join(',')}) GROUP BY Card.DeckID, Card.NoteID, Card.CardTemplateID HAVING COUNT(*) >= ?',
        [deckId, ...tags, tags.length]).then((value) async {
      for (var item in value) {
        CardKey key = CardKey(
          deckId: item['DeckID'].toString(),
          noteId: item['NoteID'].toString(),
          cardTemplateId: item['CardTemplateID'].toString(),
        );
        CardDetail card = await getCard(key);
        cards.add(card);
      }
      return Future.value(cards);
    });
  }

  @override
  Stream<List<CardDetail>> getCardsStream(
      {String? deckId, List<String>? tags}) {
    // TODO: implement getCardsStream
    throw UnimplementedError();
  }
}
