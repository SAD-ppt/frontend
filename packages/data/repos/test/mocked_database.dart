import 'package:data_api/data_api.dart' as api;
import 'package:data_api/src/model/note_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class MockedDatabase
    implements
        api.DeckApi,
        api.CardApi,
        api.CardTemplateApi,
        api.NoteApi,
        api.NoteTagApi,
        api.NoteTemplateApi {
  var decks = <api.Deck>[];
  var cards = <api.Card>[];
  var cardTemplates = <api.CardTemplate>[];
  var cardTemplateFields = <api.CardTemplateField>[];
  var notes = <api.Note>[];
  var noteTemplates = <api.NoteTemplate>[];
  var noteTemplateFields = <api.NoteTemplateField>[];
  var noteFields = <api.NoteField>[];
  var tags = <NoteTag>[];

  @override
  Future<api.CardTemplateField> addNewFieldToCardTemplate(
      String cardTemplateId, int orderNumber, api.CardSide side) {
    cardTemplates.firstWhere((element) => element.id == cardTemplateId,
        orElse: () => throw Exception('Card template not found'));
    var field = api.CardTemplateField(
      cardTemplateId: cardTemplateId,
      orderNumber: orderNumber,
      side: side,
    );
    cardTemplateFields.add(field);
    return Future.value(field);
  }

  @override
  Future<api.Card> createCard(api.Card card) {
    cards.add(card);
    return Future.value(card);
  }

  @override
  Future<api.Deck> createDeck(String name, String description) {
    var deck = api.Deck(
        id: const UuidV4().generate(), name: name, description: description);
    decks.add(deck);
    return Future.value(deck);
  }

  @override
  Future<api.CardTemplate> createNewCardTemplate(
      String noteTemplateId, String name, List<(api.CardSide, int)> fields) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var cardTemplate = api.CardTemplate(
        id: const UuidV4().generate(),
        name: name,
        noteTemplateId: noteTemplateId);
    cardTemplates.add(cardTemplate);
    for (var field in fields) {
      addNewFieldToCardTemplate(cardTemplate.id, field.$2, field.$1);
    }
    return Future.value(cardTemplate);
  }

  @override
  Future<api.Note> createNote(
      String deckId, String noteTemplateId, List<String> fieldValues) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var note = api.Note(
      id: const Uuid().v4(),
      noteTemplateId: noteTemplateId.toString(),
    );
    notes.add(note);
    for (var i = 0; i < fieldValues.length; i++) {
      noteFields.add(api.NoteField(
        noteId: note.id,
        orderNumber: i,
        value: fieldValues[i],
      ));
    }
    return Future.value(note);
  }

  @override
  Future<api.NoteTemplateDetail> createNoteTemplate(
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
    return Future.value(api.NoteTemplateDetail(
      noteTemplate: noteTemplate,
      fields: noteTemplateFields,
    ));
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
  Future<api.Deck> getDeck(String id) {
    for (var deck in decks) {
      if (deck.id == id) {
        return Future.value(deck);
      }
    }
    throw Exception('Deck not found');
  }

  @override
  Future<api.Deck> getDeckAndCards(String id) {
    // TODO: implement getDeckAndCards
    throw UnimplementedError();
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
    return Stream.value(notes.map((note) {
      return api.NoteDetail(
        note: note,
        fields:
            noteFields.where((element) => element.noteId == note.id).toList(),
      );
    }).toList());
  }

  @override
  Future<api.NoteTemplateDetail> getNoteTemplate(String id) {
    for (var noteTemplate in noteTemplates) {
      if (noteTemplate.id == id) {
        var fields = noteTemplateFields
            .where((element) => element.noteTemplateId == id)
            .toList();
        return Future.value(api.NoteTemplateDetail(
          noteTemplate: noteTemplate,
          fields: fields,
        ));
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
  Future<api.Note> updateNoteFields(
      String noteId, List<api.NoteField> noteFields) {
    throw UnimplementedError();
  }

  @override
  Future<api.NoteTemplate> updateNoteTemplate(api.NoteTemplate noteTemplate) {
    // TODO: implement updateNoteTemplate
    throw UnimplementedError();
  }

  @override
  Future<NoteTag> updateTag(NoteTag tag) {
    final idx = tags.indexWhere(
        (element) => element.cardId == tag.cardId && element.name == tag.name);
    if (idx == -1) {
      throw Exception('Tag not found');
    }
    tags[idx] = tag;
    return Future.value(tag);
  }

  @override
  Future<NoteTag> getTagsOfNoteByName(String cardId, String name) {
    return Future.value(tags.firstWhere(
        (element) => element.cardId == cardId && element.name == name));
  }

  @override
  Future<void> deleteTag(String cardId, String name) {
    // TODO: implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<List<api.CardDetail>> getCardsOfDeckByTag(
      String deckId, String tagName) {
    // TODO: implement getCardsOfDeckByTag
    throw UnimplementedError();
  }

  @override
  Future<NoteTag> createTag(String cardId, String name, {String? color}) {
    final tag = NoteTag(cardId: cardId, name: name, color: color);
    tags.add(tag);
    return Future.value(tag);
  }

  @override
  Future<List<NoteTag>> getTags(String? cardId) {
    if (cardId == null) {
      return Future.value(tags);
    }
    return Future.value(
        tags.where((element) => element.cardId == cardId).toList());
  }

  @override
  Future<int> getNumTagsOfNote(String noteId) {
    // TODO: implement getNumTagsOfNote
    throw UnimplementedError();
  }
}
