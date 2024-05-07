import 'model/card_tag.dart';

abstract interface class CardTagApi {
  Stream<List<CardTag>> getTagsOfCard(String cardId);
  Future<CardTag> getTag(String id);
  Future<CardTag> createTag(CardTag tag);
  Future<CardTag> updateTag(CardTag tag);
  Future<void> deleteTag(String id);
  Future<int> getNumTagsOfCard(String cardId);
}
