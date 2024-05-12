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
      String deckId, String noteTemplateId, List<String> fieldValues) {
    Note note = Note(
      id: const Uuid().v4(),
      noteTemplateId: noteTemplateId,
    );
    return db
        .insert('Note', note.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      if (value == 0) {
        throw Exception('Failed to create note');
      } else {
        for (int i = 0; i < fieldValues.length; i++) {
          db.insert('NoteField', {
            'NoteID': note.id,
            'OrderNumber': i,
            'RichTextData': fieldValues[i],
          });
        }
        return Future.value(note);
      }
    });
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
    return db
        .query('Note', where: 'UniqueID = ?', whereArgs: [id]).then((value) {
      if (value.isEmpty) {
        throw Exception('Note not found');
      }
      Note note = Note(
        id: value[0]['UniqueID'].toString(),
        noteTemplateId: value[0]['NoteTemplateID'].toString(),
      );
      List<NoteField> fields = [];
      List<NoteTag> tags = [];
      return db.query('NoteField', where: 'NoteID = ?', whereArgs: [id]).then(
          (value) {
        for (Map<String, dynamic> row in value) {
          fields.add(NoteField(
            noteId: row['NoteID'],
            orderNumber: row['OrderNumber'],
            value: row['RichTextData'],
          ));
        }
        return db
            .query('Tag', where: 'NoteID = ?', whereArgs: [id]).then((value) {
          for (Map<String, dynamic> row in value) {
            tags.add(NoteTag(
              noteId: row['NoteID'],
              name: row['Name'],
              color: row['Color'],
            ));
          }
          return Future.value(
              NoteDetail(note: note, fields: fields, tags: tags));
        });
      });
    });
  }

  Future<List<NoteDetail>> getNotesRaw() {
    // Get all notes, asscoiated fields and tags with them
    List<NoteDetail> notes = [];
    return db.query('Note').then((value) async {
      for (Map<String, dynamic> row in value) {
        Note note = Note(
          id: row['UniqueID'].toString(),
          noteTemplateId: row['NoteTemplateID'].toString(),
        );
        List<NoteField> fields = [];
        List<NoteTag> tags = [];
        await db.query('NoteField',
            where: 'NoteID = ?', whereArgs: [note.id]).then((value) {
          for (Map<String, dynamic> row in value) {
            fields.add(NoteField(
              noteId: row['NoteID'],
              orderNumber: row['OrderNumber'],
              value: row['RichTextData'],
            ));
          }
        });
        await db.query('Tag', where: 'NoteID = ?', whereArgs: [note.id]).then(
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
      return Future.value(notes);
    });
  }

  Future<List<NoteDetail>> getNotesByDeckId(String deckId) {
    // Get all notes, asscoiated fields and tags with them
    List<NoteDetail> notes = [];
    return db.rawQuery(
      'SELECT * FROM Note WHERE UniqueID IN (SELECT NoteID FROM Card WHERE DeckID = ?)',
      [deckId],
    ).then((value) async {
      for (Map<String, dynamic> row in value) {
        Note note = Note(
          id: row['UniqueID'].toString(),
          noteTemplateId: row['NoteTemplateID'].toString(),
        );
        List<NoteField> fields = [];
        List<NoteTag> tags = [];
        await db.query('NoteField',
            where: 'NoteID = ?', whereArgs: [note.id]).then((value) {
          for (Map<String, dynamic> row in value) {
            fields.add(NoteField(
              noteId: row['NoteID'],
              orderNumber: row['OrderNumber'],
              value: row['RichTextData'],
            ));
          }
        });
        await db.query('Tag', where: 'NoteID = ?', whereArgs: [note.id]).then(
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
      return Future.value(notes);
    });
  }

  Future<List<NoteDetail>> getNotesByTags(List<String> tags) {
    // Select the notes that have all the tags, by joining the Note and Tag tables
    return db.rawQuery(
        "SELECT * FROM Note WHERE UniqueID IN (SELECT NoteID FROM Tag WHERE Name IN (${tags.map((_) => '?').join(',')}) GROUP BY NoteID HAVING COUNT(*) >= ?)",
    [...tags, tags.length],).then((value) {
      List<NoteDetail> notes = [];
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
              value: row['RichTextData'],
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
      return Future.value(notes);
    });
  }

  Future<List<NoteDetail>> getNotesByDeckIdAndTags(
      String deckId, List<String> tags) {
    // Select the notes in the deckID deck, that have all the tags, by joining the Note, Tag and Card tables
    return db.rawQuery(
        'SELECT * FROM Note WHERE UniqueID IN (SELECT NoteID FROM Tag WHERE Name IN (${tags.map((_) => '?').join(',')}) GROUP BY NoteID HAVING COUNT(*) >= ?) AND UniqueID IN (SELECT NoteID FROM Card WHERE DeckID = ?)',
        [...tags, tags.length, deckId]).then((value) {
      List<NoteDetail> notes = [];
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
              value: row['RichTextData'],
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
      return Future.value(notes);
    });
  }

  @override
  Future<List<NoteDetail>> getNotes(
      {String? deckId, List<String>? tags}) async {
    if (deckId == null && tags == null) {
      return await getNotesRaw();
    } else if (deckId != null && tags == null) {
      return await getNotesByDeckId(deckId);
    } else if (deckId == null && tags != null) {
      return await getNotesByTags(tags);
    } else {
      return await getNotesByDeckIdAndTags(deckId!, tags!);
    }
  }

  @override
  Stream<List<NoteDetail>> getNotesStream() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNoteField(String noteId, int idx, String value) {
    // Update the field in NoteField table
    return db
        .update('NoteField', {'RichTextData': value},
            where: 'NoteID = ? AND OrderNumber = ?',
            whereArgs: [noteId, idx],
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      if (value == 0) {
        throw Exception('Field not found');
      } else {
        return db.query('Note',
            where: 'UniqueID = ?', whereArgs: [noteId]).then((value) {
          return Future.value(Note(
            id: value[0]['UniqueID'].toString(),
            noteTemplateId: value[0]['NoteTemplateID'].toString(),
          ));
        });
      }
    });
  }

  @override
  Future<Note> updateNoteFields(
      String noteId, List<NoteField> noteFields) async {
    // Update the fields in NoteField table
    for (NoteField field in noteFields) {
      await db.update('NoteField', {'RichTextData': field.value},
          where: 'NoteID = ? AND OrderNumber = ?',
          whereArgs: [noteId, field.orderNumber],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    // Get the note from the Note table
    return db.query('Note', where: 'UniqueID = ?', whereArgs: [noteId]).then(
        (value) {
      if (value.isEmpty) {
        throw Exception('Note not found');
      }
      return Future.value(Note(
        id: value[0]['UniqueID'].toString(),
        noteTemplateId: value[0]['NoteTemplateID'].toString(),
      ));
    });
  }
}
