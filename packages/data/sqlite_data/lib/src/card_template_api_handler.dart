import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

extension ToMapCardTemplateField on CardTemplateField {
  Map<String, dynamic> toMap() {
    return {
      'CardTemplateID': cardTemplateId,
      'OrderNumber': orderNumber,
      'Side': side.index,
    };
  }
}

extension ToMapCardTemplate on CardTemplate {
  Map<String, dynamic> toMap() {
    return {
      'UniqueID': id,
      'NoteTemplateID': noteTemplateId,
      'Name': name,
    };
  }
}

class CardTemplateApiHandler implements CardTemplateApi {
  final Database db;
  const CardTemplateApiHandler({required this.db});
  @override
  Future<CardTemplateDetail?> getCardTemplate(String id) {
    db.query('CardTemplate', where: 'UniqueID = ?', whereArgs: [id]).then((value) {
      if (value.isNotEmpty) {
        return CardTemplateDetail(
          cardTemplate: CardTemplate(
            id: value[0]['UniqueID'].toString(),
            noteTemplateId: value[0]['NoteTemplateId'].toString(),
            name: value[0]['Name'].toString(),
          ),
          frontFields: [],
          backFields: [],
        );
      }
    });
    throw Exception('Card template not found');
  }
  
  @override
  Future<CardTemplateField> addNewFieldToCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side) async {
    CardTemplateField newField = CardTemplateField(
      cardTemplateId: cardTemplateId,
      orderNumber: orderNumber,
      side: side,
    );
    await db.insert('CardTemplateField', newField.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return newField;
  }

  @override
  Future<CardTemplate> createNewCardTemplate(
      String noteTemplateId, String name, List<(CardSide, int)> fields) async {
    CardTemplate newCardTemplate = CardTemplate(
      id: const Uuid().v4(),
      noteTemplateId: noteTemplateId,
      name: name,
    );
    db.insert('CardTemplate', newCardTemplate.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    // Add fields
    for (var field in fields)  {
      await addNewFieldToCardTemplate(newCardTemplate.id, field.$2, field.$1);
    }
    return newCardTemplate;
  }

  @override
  Future<void> deleteCardTemplate(String id) async {
    // Delete all associated fields
    await db.delete('CardTemplateField', where: 'CardTemplateID = ?', whereArgs: [id]);
    // Delete the card template
    await db.delete('CardTemplate', where: 'UniqueID = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteFieldFromCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side) async {
    await db.delete('CardTemplateField', where: 'CardTemplateID = ? AND OrderNumber = ? AND Side = ?', whereArgs: [cardTemplateId, orderNumber, side.index]);
  }

  @override
  Stream<List<CardTemplateDetail>> getCardTemplatesStream(String? noteTemplateId) {
    // TODO: implement getCardTemplates
    throw UnimplementedError();
  }

  @override
  Future<CardTemplate> updateCardTemplate(CardTemplate cardTemplate) async {
    var res = await db.update('CardTemplate', cardTemplate.toMap(), where: 'UniqueID = ?', whereArgs: [cardTemplate.id]);
    if (res == 0) {
      throw Exception('Card template not found');
    }
    return cardTemplate;
  }

  @override
  Future<void> updateFieldOrder(String cardTemplateId, int oldOrderNumber,
      int newOrderNumber, CardSide side) async {
    await db.update('CardTemplateField', {'OrderNumber': newOrderNumber}, where: 'CardTemplateID = ? AND OrderNumber = ? AND Side = ?', whereArgs: [cardTemplateId, oldOrderNumber, side.index], conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  @override
  Future<List<CardTemplateDetail>> getCardTemplates(String? noteTemplateId) async {
    await db.query('CardTemplate', where: 'NoteTemplateID = ?', whereArgs: [noteTemplateId]).then((value) {
      List<CardTemplateDetail> cardTemplates = [];
      for (var cardTemplate in value) {
        List<CardTemplateField> frontFields = [];
        List<CardTemplateField> backFields = [];
        db.query('CardTemplateField', where: 'CardTemplateID = ? AND Side = ?', whereArgs: [cardTemplate['UniqueID'], CardSide.front.index]).then((value) {
          for (var field in value) {
            CardTemplateField newField = CardTemplateField(
              cardTemplateId: field['CardTemplateID'].toString(),
              orderNumber: field['OrderNumber'] as int,
              side: CardSide.values[field['Side'] as int],
            );
            if (field['Side'] as int == CardSide.front.index) {
              frontFields.add(newField);
            } else {
              backFields.add(newField);
            }
          }
        });
        cardTemplates.add(CardTemplateDetail(
          cardTemplate: CardTemplate(
            id: cardTemplate['UniqueID'].toString(),
            noteTemplateId: cardTemplate['NoteTemplateId'].toString(),
            name: cardTemplate['Name'].toString(),
          ),
          frontFields: frontFields,
          backFields: backFields,
        ));
      }
      return cardTemplates;
    });
    throw Exception('Card templates not found for note template $noteTemplateId');
  }
}
