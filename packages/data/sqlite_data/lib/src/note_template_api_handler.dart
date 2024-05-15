import 'dart:async';

import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

extension ToMapNoteTemplate on NoteTemplate {
  Map<String, dynamic> toMap() {
    return {
      'UniqueID': id,
      'Name': name,
    };
  }
}

extension ToMapNoteTemplateField on NoteTemplateField {
  Map<String, dynamic> toMap() {
    return {
      'NoteTemplateId': noteTemplateId,
      'OrderNumber': orderNumber,
      'Name': name,
    };
  }
}

class NoteTemplateApiHandler implements NoteTemplateApi {
  final Database db;
  const NoteTemplateApiHandler({required this.db});

  @override
  Future<NoteTemplateDetail> createNoteTemplate(
      String name, List<String> noteFieldNames) {
    String id = const Uuid().v4();
    NoteTemplate noteTemplate = NoteTemplate(id: id, name: name);
    // Create a new note template
    return db
        .insert('NoteTemplate', noteTemplate.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) async {
      if (value == 0) {
        throw Exception('Failed to create note template');
      }
      List<NoteTemplateField> fields = noteFieldNames
          .asMap()
          .entries
          .map((e) => NoteTemplateField(
              noteTemplateId: id, orderNumber: e.key, name: e.value))
          .toList();
      for (NoteTemplateField field in fields) {
        await db.insert('NoteTemplateField', field.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return Future.value(
          NoteTemplateDetail(noteTemplate: noteTemplate, fields: fields));
    });
  }

  @override
  Future<void> deleteNoteField(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteTemplate(String id) {
    return db.delete('NoteTemplate',
        where: 'UniqueID = ?', whereArgs: [id]).then((value) {
      if (value == 0) {
        throw Exception('Failed to delete note template');
      }
      return db.delete('NoteTemplateField',
          where: 'NoteTemplateID = ?', whereArgs: [id]).then((value) {
        if (value == 0) {
          throw Exception('Failed to delete note template fields');
        }
      });
    });
  }

  @override
  Future<NoteTemplateDetail> getNoteTemplate(String id) {
    return db.query('NoteTemplate',
        where: 'UniqueID = ?', whereArgs: [id]).then((value) {
      if (value.isEmpty) {
        throw Exception('Note template not found');
      }
      NoteTemplate noteTemplate = NoteTemplate(
          id: value[0]['UniqueID'].toString(),
          name: value[0]['Name'].toString());
      List<NoteTemplateField> fields = [];
      return db.query('NoteTemplateField',
          where: 'NoteTemplateID = ?', whereArgs: [id]).then((value) {
        if (value.isEmpty) {
          throw Exception('No fields found for note template');
        }
        for (Map<String, dynamic> field in value) {
          fields.add(NoteTemplateField(
              noteTemplateId: field['NoteTemplateID'],
              orderNumber: field['OrderNumber'],
              name: field['Name']));
        }
        return Future.value(
            NoteTemplateDetail(noteTemplate: noteTemplate, fields: fields));
      });
    });
  }

  @override
  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate) {
    return db.update('NoteTemplate', noteTemplate.toMap(),
        where: 'UniqueID = ?', whereArgs: [noteTemplate.id]).then((value) {
      if (value == 0) {
        throw Exception('Failed to update note template');
      }
      return noteTemplate;
    });
  }

  @override
  Future<List<NoteTemplateDetail>> getNoteTemplates() {
    return db.query('NoteTemplate').then((value) async {
      if (value.isEmpty) {
        throw Exception('No note templates found');
      }
      List<NoteTemplateDetail> noteTemplates = [];
      for (Map<String, dynamic> noteTemplate in value) {
        List<NoteTemplateField> fields = [];
        await db.query('NoteTemplateField',
            where: 'NoteTemplateID = ?',
            whereArgs: [noteTemplate['UniqueID']]).then((value) {
          for (Map<String, dynamic> field in value) {
            fields.add(NoteTemplateField(
                noteTemplateId: field['NoteTemplateID'],
                orderNumber: field['OrderNumber'],
                name: field['Name']));
          }
        });
        noteTemplates.add(NoteTemplateDetail(
            noteTemplate: NoteTemplate(
                id: noteTemplate['UniqueID'], name: noteTemplate['Name']),
            fields: fields));
      }
      return Future.value(noteTemplates);
    });
  }

  @override
  Stream<List<NoteTemplateDetail>> getNoteTemplatesStream() {
    // TODO: implement getNoteTemplatesStream
    throw UnimplementedError();
  }
}
