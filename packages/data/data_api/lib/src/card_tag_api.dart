import 'model/card_tag.dart';

abstract interface class CardTagApi {
  /// Returns tags associated with a card. If [cardId] is null, returns all card tags.
  Future<List<CardTag>> getTags(String? cardId);
  Future<CardTag> getTagsOfCardByName(String cardId, String name);
  Future<CardTag> createTag(String cardId, String name, String? color);
  Future<CardTag> updateTag(CardTag tag);
  Future<void> deleteTag(String cardId, String name);
  Future<int> getNumTagsOfCard(String cardId);
}
