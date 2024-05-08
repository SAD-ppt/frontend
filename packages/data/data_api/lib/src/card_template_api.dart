import 'model/card_template.dart';

abstract interface class CardTemplateApi {
  /// Returns a stream of all card templates associated with a note template.
  /// If [noteTemplateId] is null, returns all card templates.
  Stream<List<CardTemplateDetail>> getCardTemplatesStream(
      String? noteTemplateId) => throw UnimplementedError();

  /// Returns a list of all card templates associated with a note template.
  /// If [noteTemplateId] is null, returns all card templates.
  Future<List<CardTemplateDetail>> getCardTemplates(String? noteTemplateId);

  /// Create a new card template with the given [noteTemplateId] and [name].
  Future<CardTemplate> createNewCardTemplate(String noteTemplateId, String name,
      List<(CardSide side, int orderNumber)> fields);

  Future<CardTemplateField> addNewFieldToCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side);

  Future<void> deleteFieldFromCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side);

  Future<void> updateFieldOrder(String cardTemplateId, int oldOrderNumber,
      int newOrderNumber, CardSide side);

  /// Returns a card template with the given [cardTemplate.id].
  Future<CardTemplate> updateCardTemplate(CardTemplate cardTemplate);

  /// Deletes a card template.
  Future<void> deleteCardTemplate(String id);
}
