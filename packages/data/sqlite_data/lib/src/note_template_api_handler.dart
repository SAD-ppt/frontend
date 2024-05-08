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
      String name, List<String> noteFieldNames) async {
    String id = Uuid().v4();
    NoteTemplate noteTemplate = NoteTemplate(id: id, name: name);
    // Create a new note template
    await db.insert('NoteTemplate', noteTemplate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // Create note template fields
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
    return NoteTemplateDetail(noteTemplate: noteTemplate, fields: fields);
  }

  @override
  Future<void> deleteNoteField(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteTemplate(String id) {
    // TODO: implement deleteNoteTemplate
    throw UnimplementedError();
  }

  @override
  Future<NoteTemplateDetail> getNoteTemplate(String id) {
    db.query('NoteTemplate', where: 'UniqueID = ?', whereArgs: [id]).then(
        (value) {
      NoteTemplate noteTemplate = NoteTemplate(
          id: value[0]['UniqueID'].toString(),
          name: value[0]['Name'].toString());
      List<NoteTemplateField> fields = [];
      db.query('NoteTemplateField',
          where: 'NoteTemplateID = ?', whereArgs: [id]).then((value) {
        for (Map<String, dynamic> field in value) {
          fields.add(NoteTemplateField(
              noteTemplateId: field['NoteTemplateID'],
              orderNumber: field['OrderNumber'],
              name: field['Name']));
        }
      });
      return NoteTemplateDetail(noteTemplate: noteTemplate, fields: fields);
    });
    throw Exception('Failed to get note template');
  }

  @override
  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate) async {
    await db.update('NoteTemplate', noteTemplate.toMap(),
        where: 'UniqueID = ?', whereArgs: [noteTemplate.id]);
    return noteTemplate;
  }
  
  @override
  Future<List<NoteTemplateDetail>> getNoteTemplates() async {
    await db.query('NoteTemplate').then((value) {
      List<NoteTemplateDetail> noteTemplates = [];
      for (Map<String, dynamic> noteTemplate in value) {
        List<NoteTemplateField> fields = [];
        db.query('NoteTemplateField',
            where: 'NoteTemplateID = ?', whereArgs: [noteTemplate['UniqueID']])
            .then((value) {
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
      return noteTemplates;
    });
    throw Exception('Failed to get note templates');
  }

  @override
  Stream<List<NoteTemplateDetail>> getNoteTemplatesStream() {
    // TODO: implement getNoteTemplatesStream
    throw UnimplementedError();
  }
}
