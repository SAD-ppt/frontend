import 'package:data_api/data_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class MockedDatabase
    implements
        api.DeckApi,
        api.CardApi,
        api.CardTemplateApi,
        api.NoteApi,
        api.NoteTemplateApi {
  var decks = <api.Deck>[];
  var cards = <api.Card>[];
  var cardTemplates = <api.CardTemplate>[];
  var cardTemplateFields = <api.CardTemplateField>[];
  var notes = <api.Note>[];
  var noteTemplates = <api.NoteTemplate>[];
  var noteTemplateFields = <api.NoteTemplateField>[];

  @override
  Future<void> addNewFieldToCardTemplate(
      String cardTemplateId, int orderNumber, api.CardSide side) {
    cardTemplates.firstWhere((element) => element.id == cardTemplateId,
        orElse: () => throw Exception('Card template not found'));
    var field = api.CardTemplateField(
      cardTemplateId: cardTemplateId,
      orderNumber: orderNumber,
      side: side,
    );
    cardTemplateFields.add(field);
    return Future.value();
  }

  @override
  Future<api.Card> createCard(api.Card card) {
    cards.add(card);
    return Future.value(card);
  }

  @override
  Future<api.Note> updateNoteFields(
      String noteId, List<api.NoteField> noteFields) {
    throw UnimplementedError();
  }

  @override
  Future<api.Deck> createDeck(String name, String description) {
    var deck = api.Deck(id: const UuidV4().generate(), name: name);
    decks.add(deck);
    return Future.value(deck);
  }

  @override
  Future<api.CardTemplate> createEmptyCardTemplate(
      String noteTemplateId, String name) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var cardTemplate = api.CardTemplate(
      id: const UuidV4().generate(),
      name: name,
      noteTemplateId: noteTemplateId,
    );
    cardTemplates.add(cardTemplate);
    return Future.value(cardTemplate);
  }

  @override
  Future<api.CardTemplate> createNewCardTemplate(
      String noteTemplateId, String name, List<(api.CardSide, int)> fields) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var cardTemplate = api.CardTemplate(
        id: const UuidV4().generate(), name: name, noteTemplateId: noteTemplateId);
    cardTemplates.add(cardTemplate);
    for (var field in fields) {
      addNewFieldToCardTemplate(cardTemplate.id, field.$2, field.$1);
    }
    return Future.value(cardTemplate);
  }

  @override
  Future<api.Note> createNote(String noteTemplateId, List<String> fieldValues) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var note = api.Note(
      id: const Uuid().v4(),
      noteTemplateId: noteTemplateId.toString(),
    );
    notes.add(note);
    return Future.value(note);
  }

  @override
  Future<(api.NoteTemplate, List<api.NoteTemplateField>)> createNoteTemplate(
      String name, List<String> noteFieldNames) {
    var noteTemplate = api.NoteTemplate(
      id: const UuidV4().generate(),
      name: name,
    );
    noteTemplates.add(noteTemplate);
    var noteTemplateFields = noteFieldNames
        .asMap()
        .map((idx, name) => MapEntry(
            idx,
            api.NoteTemplateField(
              noteTemplateId: noteTemplate.id,
              orderNumber: idx,
              name: name,
            )))
        .values
        .toList();
    this.noteTemplateFields.addAll(noteTemplateFields);
    return Future.value((noteTemplate, noteTemplateFields));
  }

  @override
  Future<void> deleteCard(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCardTemplate(String id) {
    // TODO: implement deleteCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDeck(String id) {
    // TODO: implement deleteDeck
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFieldFromCardTemplate(
      String cardTemplateId, int orderNumber, api.CardSide side) {
    // TODO: implement deleteFieldFromCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote(String id) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteField(String id) {
    // TODO: implement deleteNoteField
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteTemplate(String id) {
    // TODO: implement deleteNoteTemplate
    throw UnimplementedError();
  }

  @override
  Future<api.CardDetail> getCard(String id) {
    // TODO: implement getCard
    throw UnimplementedError();
  }

  @override
  Stream<List<api.CardDetail>> getCardsOfDeck(String deckId) {
    // TODO: implement getCardsOfDeck
    throw UnimplementedError();
  }

  @override
  Stream<List<api.CardTemplateDetail>> getCardTemplates(
      String? noteTemplateId) {
    return Stream.value(cardTemplates.map((ct) {
      var frontFields = cardTemplateFields
          .where((element) =>
              element.cardTemplateId == ct.id &&
              element.side == api.CardSide.front)
          .toList();
      var backFields = cardTemplateFields
          .where((element) =>
              element.cardTemplateId == ct.id &&
              element.side == api.CardSide.back)
          .toList();
      return api.CardTemplateDetail(
        cardTemplate: ct,
        frontFields: frontFields,
        backFields: backFields,
      );
    }).toList());
  }

  @override
  Future<api.Deck> getDeckAndCards(String id) {
    // TODO: implement getDeckAndCards
    throw UnimplementedError();
  }

  @override
  Future<api.Deck> getDeck(String id) {
    for (var deck in decks) {
      if (deck.id == id) {
        return Future.value(deck);
      }
    }
    throw Exception('Deck not found');
  }

  @override
  Stream<List<api.Deck>> getDecks() {
    return Stream.value(decks);
  }

  @override
  Future<api.NoteDetail> getNote(String id) {
    // TODO: implement getNote
    throw UnimplementedError();
  }

  @override
  Stream<List<api.NoteDetail>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }

  @override
  Future<(api.NoteTemplate, List<api.NoteTemplateField>)> getNoteTemplate(
      String id) {
    for (var noteTemplate in noteTemplates) {
      if (noteTemplate.id == id) {
        var fields = noteTemplateFields
            .where((element) => element.noteTemplateId == id)
            .toList();
        return Future.value((noteTemplate, fields));
      }
    }
    throw Exception('Note template not found');
  }

  @override
  Stream<List<api.NoteTemplateDetail>> getNoteTemplates() {
    return Stream.value(noteTemplates.map((nt) {
      var fields = noteTemplateFields
          .where((element) => element.noteTemplateId == nt.id)
          .toList();
      return api.NoteTemplateDetail(
        noteTemplate: nt,
        fields: fields,
      );
    }).toList());
  }

  @override
  Future<int> getNumCardsInDeck(String id) {
    for (var card in cards) {
      if (card.deckId == id) {
        return Future.value(cards.length);
      }
    }
    return Future.value(0);
  }

  @override
  Future<api.Card> updateCard(api.Card card) {
    // TODO: implement updateCard
    throw UnimplementedError();
  }

  @override
  Future<api.CardTemplate> updateCardTemplate(api.CardTemplate cardTemplate) {
    // TODO: implement updateCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<api.Deck> updateDeck(api.Deck deck) {
    // TODO: implement updateDeck
    throw UnimplementedError();
  }

  @override
  Future<void> updateFieldOrder(String cardTemplateId, int oldOrderNumber,
      int newOrderNumber, api.CardSide side) {
    // TODO: implement updateFieldOrder
    throw UnimplementedError();
  }

  @override
  Future<api.Note> updateNoteField(String noteId, int idx, String value) {
    // TODO: implement updateNoteField
    throw UnimplementedError();
  }

  @override
  Future<api.NoteTemplate> updateNoteTemplate(api.NoteTemplate noteTemplate) {
    // TODO: implement updateNoteTemplate
    throw UnimplementedError();
  }

  @override
  Stream<List<(api.Deck, api.Card)>> getDecksAndCards() {
    // TODO: implement getDecksAndCards
    throw UnimplementedError();
  }
}
