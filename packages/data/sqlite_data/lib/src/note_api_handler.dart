import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

extension ToMapNote on Note {
  Map<String, dynamic> toMap() {
    return {
      'UniqueID': id,
      'NoteTemplateID': noteTemplateId,
    };
  }
}

class NoteApiHandler implements NoteApi {
  final Database db;
  const NoteApiHandler({required this.db});
  @override
  Future<Note> createNote(
      String deckId, String noteTemplateId, List<String> fieldValues) async {
    Note note = Note(
      id: const Uuid().v4(),
      noteTemplateId: noteTemplateId,
    );
    await db.insert('Note', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    // Delete all associated fields
    await db.delete('NoteField', where: 'NoteID = ?', whereArgs: [id]);
    // Delete the note
    await db.delete('Note', where: 'UniqueID = ?', whereArgs: [id]);
  }

  @override
  Future<NoteDetail> getNote(String id) {
    db.query('Note', where: 'UniqueID = ?', whereArgs: [id]).then((value) {
      Note note = Note(
        id: value[0]['UniqueID'].toString(),
        noteTemplateId: value[0]['NoteTemplateID'].toString(),
      );
      List<NoteField> fields = [];
      List<NoteTag> tags = [];
      db.query('NoteField', where: 'NoteID = ?', whereArgs: [id]).then((value) {
        for (Map<String, dynamic> row in value) {
          fields.add(NoteField(
            noteId: row['NoteID'],
            orderNumber: row['OrderNumber'],
            value: row['RichDataText'],
          ));
        }
      });
      db.query('Tag', where: 'NoteID = ?', whereArgs: [id]).then((value) {
        for (Map<String, dynamic> row in value) {
          tags.add(NoteTag(
            noteId: row['NoteID'],
            name: row['Name'],
            color: row['Color'],
          ));
        }
      });
      return NoteDetail(note: note, fields: fields, tags: tags);
    });
    throw Exception('Note not found');
  }

  @override
  Future<List<NoteDetail>> getNotes() {
    List<NoteDetail> notes = [];
    db.query('Note').then((value) {
      for (Map<String, dynamic> row in value) {
        Note note = Note(
          id: row['UniqueID'].toString(),
          noteTemplateId: row['NoteTemplateID'].toString(),
        );
        List<NoteField> fields = [];
        List<NoteTag> tags = [];
        db.query('NoteField', where: 'NoteID = ?', whereArgs: [note.id]).then(
            (value) {
          for (Map<String, dynamic> row in value) {
            fields.add(NoteField(
              noteId: row['NoteID'],
              orderNumber: row['OrderNumber'],
              value: row['RichDataText'],
            ));
          }
        });
        db.query('Tag', where: 'NoteID = ?', whereArgs: [note.id]).then(
            (value) {
          for (Map<String, dynamic> row in value) {
            tags.add(NoteTag(
              noteId: row['NoteID'],
              name: row['Name'],
              color: row['Color'],
            ));
          }
        });
        notes.add(NoteDetail(note: note, fields: fields, tags: tags));
      }
    });
    return Future.value(notes);
  }

  @override
  Stream<List<NoteDetail>> getNotesStream() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNoteField(String noteId, int idx, String value) async {
    // Update the field in NoteField table
    await db.update('NoteField', {'RichDataText': value},
        where: 'NoteID = ? AND OrderNumber = ?',
        whereArgs: [noteId, idx],
        conflictAlgorithm: ConflictAlgorithm.replace);
    // Get the note from the Note table
    db.query('Note', where: 'UniqueID = ?', whereArgs: [noteId]).then((value) {
      return Note(
        id: value[0]['UniqueID'].toString(),
        noteTemplateId: value[0]['NoteTemplateID'].toString(),
      );
    });
    throw Exception('Note not found');
  }

  @override
  Future<Note> updateNoteFields(String noteId, List<NoteField> noteFields) {
    // Update the fields in NoteField table
    for (NoteField field in noteFields) {
      db.update('NoteField', {'RichDataText': field.value},
          where: 'NoteID = ? AND OrderNumber = ?',
          whereArgs: [noteId, field.orderNumber],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    // Get the note from the Note table
    db.query('Note', where: 'UniqueID = ?', whereArgs: [noteId]).then((value) {
      return Note(
        id: value[0]['UniqueID'].toString(),
        noteTemplateId: value[0]['NoteTemplateID'].toString(),
      );
    });
    throw Exception('Note not found');
    
  }
}
