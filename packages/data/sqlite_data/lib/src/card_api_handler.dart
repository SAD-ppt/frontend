import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class CardApiHandler implements CardApi {
  final Future<Database> db;
  const CardApiHandler({required this.db});
  @override
  Future<Card> createCard(Card card) {
    // TODO: implement createCard
    throw UnimplementedError();
  }
  @override
  Future<void> deleteCard(String id) {
    // TODO: implement deleteCard
    throw UnimplementedError();
  }
  @override
  Future<CardDetail> getCard(String id) {
    // TODO: implement getCard
    // throw UnimplementedError();
    throw UnimplementedError();
  }
  @override
  Stream<List<CardDetail>> getCardsOfDeck(String deckId) {
    // TODO: implement getCardsOfDeck
    throw UnimplementedError();
  }
  @override
  Future<int> getNumCardsInDeck(String id) {
    // TODO: implement getNumCardsInDeck
    throw UnimplementedError();
  }
  @override
  Future<Card> updateCard(Card card) {
    // TODO: implement updateCard
    throw UnimplementedError();
  }
}
