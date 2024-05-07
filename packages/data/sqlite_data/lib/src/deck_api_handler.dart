import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class DeckApiHandler implements DeckApi {
  final Database db;
  const DeckApiHandler({required this.db});
  @override
  Future<Deck> createDeck(String name, String description) {
    // TODO: implement createDeck
    throw UnimplementedError();
  }
  @override
  Future<void> deleteDeck(String id) {
    // TODO: implement deleteDeck
    throw UnimplementedError();
  }
  @override
  Future<Deck> getDeck(String id) {
    // TODO: implement getDeck
    throw UnimplementedError();
  }
  @override
  Future<Deck> getDeckAndCards(String id) {
    // TODO: implement getDeckAndCards
    throw UnimplementedError();
  }
  @override
  Stream<List<Deck>> getDecks() {
    // TODO: implement getDecks
    throw UnimplementedError();
  }
  @override
  Future<Deck> updateDeck(Deck deck) {
    // TODO: implement updateDeck
    throw UnimplementedError();
  }
}
