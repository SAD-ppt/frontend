import 'package:data_api/data_api.dart' as api;
import 'package:flutter/src/material/card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

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
  var notes = <api.Note>[];
  var noteTemplates = <api.NoteTemplate>[];

  @override
  Future<void> addNewFieldToCardTemplate(
      Uuid cardTemplateId, api.CardSide side) {
    throw UnimplementedError();
  }

  @override
  Future<api.Card> createCard(api.Card card) {
    cards.add(card);
    return Future.value(card);
  }

  @override
  Future<api.Note> updateNoteFields(
      Uuid noteId, List<api.NoteField> noteFields) {
    throw UnimplementedError();
  }

  @override
  Future<api.Deck> createDeck(String name, String description) {
    var deck = api.Deck(id: const Uuid(), name: name);
    decks.add(deck);
    return Future.value(deck);
  }

  @override
  Future<api.CardTemplate> createEmptyCardTemplate(
      Uuid noteTemplateId, String name) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var cardTemplate = api.CardTemplate(
      id: const Uuid(),
      name: name,
      noteTemplateId: noteTemplateId,
    );
    cardTemplates.add(cardTemplate);
    return Future.value(cardTemplate);
  }

  @override
  Future<api.CardTemplate> createNewCardTemplate(
      Uuid noteTemplateId, String name, List<(api.CardSide, int)> fields) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var cardTemplate = api.CardTemplate(
        id: const Uuid(), name: name, noteTemplateId: noteTemplateId);
    cardTemplates.add(cardTemplate);
    for (var field in fields) {
      addNewFieldToCardTemplate(cardTemplate.id, field.$1);
    }
    return Future.value(cardTemplate);
  }

  @override
  Future<api.Note> createNote(Uuid noteTemplateId, List<String> fieldValues) {
    // check if note template exists
    noteTemplates.firstWhere((element) => element.id == noteTemplateId,
        orElse: () => throw Exception('Note template not found'));
    var note = api.Note(
      id: const Uuid(),
      noteTemplateId: noteTemplateId.v4(),
    );
    notes.add(note);
    return Future.value(note);
  }

  @override
  Future<(api.NoteTemplate, List<api.NoteTemplateField>)> createNoteTemplate(
      String name, List<String> noteFieldNames) {
    var noteTemplate = api.NoteTemplate(
      id: const Uuid(),
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
    return Future.value((noteTemplate, noteTemplateFields));
  }

  @override
  Future<void> deleteCard(Uuid id) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCardTemplate(Uuid id) {
    // TODO: implement deleteCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDeck(Uuid id) {
    // TODO: implement deleteDeck
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFieldFromCardTemplate(
      Uuid cardTemplateId, int orderNumber, api.CardSide side) {
    // TODO: implement deleteFieldFromCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote(Uuid id) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteField(Uuid id) {
    // TODO: implement deleteNoteField
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteTemplate(Uuid id) {
    // TODO: implement deleteNoteTemplate
    throw UnimplementedError();
  }

  @override
  Future<api.CardDetail> getCard(Uuid id) {
    // TODO: implement getCard
    throw UnimplementedError();
  }

  @override
  Stream<List<api.CardDetail>> getCardsOfDeck(Uuid deckId) {
    // TODO: implement getCardsOfDeck
    throw UnimplementedError();
  }

  @override
  Stream<List<api.CardTemplateDetail>> getCardTemplates(Uuid? noteTemplateId) {
    // TODO: implement getCardTemplates
    throw UnimplementedError();
  }

  @override
  Future<api.Deck> getDeckAndCards(Uuid id) {
    // TODO: implement getDeckAndCards
    throw UnimplementedError();
  }

  @override
  Future<api.Deck> getDeck(Uuid id) {
    throw UnimplementedError();
  }

  @override
  Stream<List<api.Deck>> getDecks() {
    // TODO: implement getDecks
    throw UnimplementedError();
  }

  @override
  Stream<List<(api.Deck, Card)>> getDecksAndCards() {
    // TODO: implement getDecksAndCards
    throw UnimplementedError();
  }

  @override
  Future<api.NoteDetail> getNote(Uuid id) {
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
      Uuid id) {
    // TODO: implement getNoteTemplate
    throw UnimplementedError();
  }

  @override
  Stream<List<api.NoteTemplateDetail>> getNoteTemplates() {
    // TODO: implement getNoteTemplates
    throw UnimplementedError();
  }

  @override
  Future<int> getNumCardsInDeck(Uuid id) {
    // TODO: implement getNumCardsInDeck
    throw UnimplementedError();
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
  Future<void> updateFieldOrder(Uuid cardTemplateId, int oldOrderNumber,
      int newOrderNumber, api.CardSide side) {
    // TODO: implement updateFieldOrder
    throw UnimplementedError();
  }

  @override
  Future<api.Note> updateNoteField(Uuid noteId, int idx, String value) {
    // TODO: implement updateNoteField
    throw UnimplementedError();
  }

  @override
  Future<api.NoteTemplate> updateNoteTemplate(api.NoteTemplate noteTemplate) {
    // TODO: implement updateNoteTemplate
    throw UnimplementedError();
  }
}
