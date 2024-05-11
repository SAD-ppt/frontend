import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class NoteTagApiHandler implements NoteTagApi {
  final Database db;
  const NoteTagApiHandler({required this.db});
  @override
  Future<void> addTagToNote(String noteId, String name) {
    return db.query('Tag',
        where: 'NoteID = ? AND Name = ?',
        whereArgs: [noteId, name]).then((value) {
      if (value.isEmpty) {
        return db
            .insert(
          'Tag',
          {
            'NoteID': noteId,
            'Name': name,
            'Color': "",
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then((value) {
          return Future.value();
        });
      }
    });
  }

  @override
  Future<NoteTag> createTag(String name, {String? color}) {
    return db.insert('Tag', {
      'NoteID': "",
      'Name': name,
      'Color': color ?? "",
    }).then((value) {
      return Future.value(NoteTag(
        noteId: "",
        name: name,
        color: color,
      ));
    });
  }

  @override
  Future<int> getNumTagsOfNote(String noteId) {
    return db.rawQuery(
        'SELECT COUNT(*) FROM Tag WHERE NoteID = ?', [noteId]).then((value) {
      return Future.value(value[0]['COUNT(*)'] as int);
    });
  }

  @override
  Future<List<NoteTag>> getTags(String? noteId) {
    if (noteId == null) {
      // select all unique tags
      return db.rawQuery(
          'SELECT DISTINCT Name, Color FROM Tag').then((value) {
        return Future.value(value
            .map((e) => NoteTag(
                  noteId: "",
                  name: e['Name'].toString(),
                  color: e['Color'].toString(),
                ))
            .toList());
      }
      );
    } else {
      return db
          .query('Tag', where: 'NoteID = ?', whereArgs: [noteId]).then((value) {
        return Future.value(value
            .map((e) => NoteTag(
                  noteId: e['NoteID'].toString(),
                  name: e['Name'].toString(),
                  color: e['Color'].toString(),
                ))
            .toList());
      });
    }
  }

  @override
  Future<NoteTag> getTagsOfNoteByName(String noteId, String name) {
    return db.query('Tag',
        where: 'NoteID = ? AND Name = ?',
        whereArgs: [noteId, name]).then((value) {
      if (value.isEmpty) {
        throw Exception('Tag not found');
      }
      return Future.value(NoteTag(
        noteId: value[0]['NoteID'].toString(),
        name: value[0]['Name'].toString(),
        color: value[0]['Color'].toString(),
      ));
    });
  }

  @override
  Future<void> removeTagFromNote(String noteId, String name) {
    return db.delete('Tag', where: 'NoteID = ? AND Name = ?', whereArgs: [noteId, name]).then((value) {
      return Future.value();
    });
  }

  @override
  Future<NoteTag> updateTag(NoteTag tag) {
    return db.update('Tag', {
      'NoteID': tag.noteId,
      'Name': tag.name,
      'Color': tag.color,
    }, where: 'NoteID = ? AND Name = ?', whereArgs: [tag.noteId, tag.name]).then((value) {
      return Future.value(tag);
    });
  }
}
