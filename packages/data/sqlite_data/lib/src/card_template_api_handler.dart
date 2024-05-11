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
    return db.query('CardTemplate',
        where: 'UniqueID = ?', whereArgs: [id]).then((value) async {
      if (value.isEmpty) {
        throw Exception('Card template not found');
      }
      List<CardTemplateField> frontFields = [];
      List<CardTemplateField> backFields = [];
      await db.query('CardTemplateField',
          where: 'CardTemplateID = ?', whereArgs: [id]).then((value) {
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
      return CardTemplateDetail(
        cardTemplate: CardTemplate(
          id: value[0]['UniqueID'].toString(),
          noteTemplateId: value[0]['NoteTemplateID'].toString(),
          name: value[0]['Name'].toString(),
        ),
        frontFields: frontFields,
        backFields: backFields,
      );
    });
  }

  @override
  Future<CardTemplateField> addNewFieldToCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side) async {
    CardTemplateField newField = CardTemplateField(
      cardTemplateId: cardTemplateId,
      orderNumber: orderNumber,
      side: side,
    );
    await db.insert('CardTemplateField', newField.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return newField;
  }

  @override
  Future<CardTemplate> createNewCardTemplate(
      String noteTemplateId, String name, List<(CardSide, int)> fields) {
    String id = const Uuid().v4();
    return db
        .insert(
      'CardTemplate',
      {
        'UniqueID': id,
        'NoteTemplateID': noteTemplateId,
        'Name': name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      for (var field in fields) {
        db.insert(
            'CardTemplateField',
            {
              'CardTemplateID': id,
              'OrderNumber': field.$2,
              'Side': field.$1.index,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return CardTemplate(
        id: id,
        noteTemplateId: noteTemplateId,
        name: name,
      );
    });
  }

  @override
  Future<void> deleteCardTemplate(String id) {
    // Delete all associated fields
    return db.delete('CardTemplateField',
        where: 'CardTemplateID = ?', whereArgs: [id]).then((value) {
      return db.delete('CardTemplate',
          where: 'UniqueID = ?', whereArgs: [id]).then((value) {
        return Future.value();
      });
    });
  }

  @override
  Future<void> deleteFieldFromCardTemplate(
      String cardTemplateId, int orderNumber, CardSide side) {
    return db.delete('CardTemplateField',
        where: 'CardTemplateID = ? AND OrderNumber = ? AND Side = ?',
        whereArgs: [cardTemplateId, orderNumber, side.index]).then((value) {
      return Future.value();
    });
  }

  @override
  Stream<List<CardTemplateDetail>> getCardTemplatesStream(
      String? noteTemplateId) {
    // TODO: implement getCardTemplates
    throw UnimplementedError();
  }

  @override
  Future<CardTemplate> updateCardTemplate(CardTemplate cardTemplate) {
    return db.update('CardTemplate', cardTemplate.toMap(),
        where: 'UniqueID = ?', whereArgs: [cardTemplate.id]).then((value) {
      if (value == 0) {
        throw Exception('Failed to update card template');
      }
      return Future.value(cardTemplate);
    });
  }

  @override
  Future<void> updateFieldOrder(String cardTemplateId, int oldOrderNumber,
      int newOrderNumber, CardSide side) {
    return db
        .update('CardTemplateField', {'OrderNumber': newOrderNumber},
            where: 'CardTemplateID = ? AND OrderNumber = ? AND Side = ?',
            whereArgs: [cardTemplateId, oldOrderNumber, side.index],
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      if (value == 0) {
        throw Exception('Failed to update field order');
      }
      return Future.value();
    });
  }

  @override
  Future<List<CardTemplateDetail>> getCardTemplates(String? noteTemplateId) {
    return db.query('CardTemplate',
        where: 'NoteTemplateID = ?', whereArgs: [noteTemplateId]).then((value) {
      if (value.isEmpty) {
        throw Exception('No card templates found');
      }
      List<CardTemplateDetail> cardTemplates = [];
      for (var cardTemplate in value) {
        List<CardTemplateField> frontFields = [];
        List<CardTemplateField> backFields = [];
        db.query('CardTemplateField',
            where: 'CardTemplateID = ? AND Side = ?',
            whereArgs: [
              cardTemplate['UniqueID'],
              CardSide.front.index
            ]).then((value) {
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
            noteTemplateId: cardTemplate['NoteTemplateID'].toString(),
            name: cardTemplate['Name'].toString(),
          ),
          frontFields: frontFields,
          backFields: backFields,
        ));
      }
      return Future.value(cardTemplates);
    });
  }
}
