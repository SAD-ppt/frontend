import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import 'model/card_template.dart';

abstract interface class CardTemplateApi {
  /// Returns a stream of all card templates associated with a note template.
  /// If [noteTemplateId] is null, returns all card templates.
  Stream<List<CardTemplateDetail>> getCardTemplates(String? noteTemplateId);

  /// Create a new card template with the given [noteTemplateId] and [name].
  Future<CardTemplate> createEmptyCardTemplate(
      String noteTemplateId, String name);

  Future<CardTemplate> createNewCardTemplate(String noteTemplateId, String name,
      List<(CardSide side, int orderNumber)> fields);

  Future<void> addNewFieldToCardTemplate(
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
