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
  Future<Card> createCard(Card card) {
    return db.insert('Card', card.toMap()).then((value) {
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
        whereArgs: [key.deckId, key.noteId, key.cardTemplateId]).then((value) {
      card = value[0].toCard();
      return db.rawQuery(
          'SELECT * FROM Note JOIN NoteField ON Note.ID = NoteField.NoteID WHERE Note.ID = ?',
          [key.noteId]).then((value) {
        for (var item in value) {
          noteFields.add(NoteField(
            noteId: item['NoteID'].toString(),
            orderNumber: item['OrderNumber'] as int,
            value: item['RichTextDatta'].toString(),
          ));
        }
        return db.rawQuery(
            'SELECT Note.NoteTemplateID, NoteTemplateField.OrderNumber, NoteTemplateField.Name FROM Note JOIN NoteTemplate ON Note.NoteTemplateID = NoteTemplate.UniqueID JOIN NoteTemplateField ON NoteTemplate.UniqueID = NoteTemplateField.NoteTemplateID WHERE Note.ID = ?',
            [key.noteId]).then((value) {
          for (var item in value) {
            noteTemplateFields.add(NoteTemplateField(
              noteTemplateId: item['Note.NoteTemplateID'].toString(),
              orderNumber: item['NoteTemplateField.OrderNumber'] as int,
              name: item['NoteTemplateField.Name'].toString(),
            ));
          }
          return Future.value(CardDetail(
              card: card,
              noteTemplateFields: noteTemplateFields,
              cardTemplateFields: cardTemplateFields,
              noteFields: noteFields));
        });
      });
    });
  }

  @override
  Future<List<CardDetail>> getCards(
      {String? deckId, List<String>? tags}) {
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
        'SELECT Card.DeckID, Card.NoteID, Card.CardTemplateID FROM Card JOIN Tag ON Card.NoteID = Tag.NoteID WHERE Tag.Name IN (?) GROUP BY Card.DeckID, Card.NoteID, Card.CardTemplateID HAVING COUNT(*) = ?', [tags, tags.length]).then((value) async {
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
        'SELECT Card.DeckID, Card.NoteID, Card.CardTemplateID FROM Card JOIN Tag ON Card.NoteID = Tag.NoteID WHERE Card.DeckID = ? AND Tag.Name IN (?) GROUP BY Card.DeckID, Card.NoteID, Card.CardTemplateID HAVING COUNT(*) = ?', [deckId, tags, tags.length]).then((value) async {
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
