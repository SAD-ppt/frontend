import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class CardTemplateApiHandler implements CardTemplateApi {
  final Database db;
  const CardTemplateApiHandler({required this.db});
  @override
  Future<CardTemplateField> addNewFieldToCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side) {
    // TODO: implement addNewFieldToCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<CardTemplate> createNewCardTemplate(
      String noteTemplateId, String name, List<(CardSide, int)> fields) {
    // TODO: implement createNewCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCardTemplate(String id) {
    // TODO: implement deleteCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFieldFromCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side) {
    // TODO: implement deleteFieldFromCardTemplate
    throw UnimplementedError();
  }

  @override
  Stream<List<CardTemplateDetail>> getCardTemplates(String? noteTemplateId) {
    // TODO: implement getCardTemplates
    throw UnimplementedError();
  }

  @override
  Future<CardTemplate> updateCardTemplate(CardTemplate cardTemplate) {
    // TODO: implement updateCardTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> updateFieldOrder(String cardTemplateId, int oldOrderNumber,
      int newOrderNumber, CardSide side) {
    // TODO: implement updateFieldOrder
    throw UnimplementedError();
  }
}
