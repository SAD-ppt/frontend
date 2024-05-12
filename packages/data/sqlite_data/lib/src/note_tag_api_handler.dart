import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class NoteTagApiHandler implements NoteTagApi {
  final Database db;
  const NoteTagApiHandler({required this.db});
  @override
  Future<void> addTagToNote(String noteId, String name) {
    return db.query('NoteTag',
        where: 'NoteID = ? AND Name = ?',
        whereArgs: [noteId, name]).then((value) {
      if (value.isEmpty) {
        return db.query('NoteTag', where: 'Name = ?', whereArgs: [name]).then((value) {
          if (value.isEmpty) {
            throw Exception('NoteTag not found');
          }
          return db.insert('NoteTag', {
            'NoteID': noteId,
            'Name': name,
            'Color': value[0]['Color'].toString(),
          }).then((value) {
            return Future.value();
          });
        });
      }
    });
  }

  @override
  Future<NoteTag> createTag(String name, {String? color}) {
    return db.insert('NoteTag', {
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
        'SELECT COUNT(*) FROM NoteTag WHERE NoteID = ?', [noteId]).then((value) {
      return Future.value(value[0]['COUNT(*)'] as int);
    });
  }

  @override
  Future<List<NoteTag>> getTags(String? noteId) {
    if (noteId == null) {
      // select all unique tags
      return db.rawQuery(
          'SELECT DISTINCT Name, Color FROM NoteTag').then((value) {
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
          .query('NoteTag', where: 'NoteID = ?', whereArgs: [noteId]).then((value) {
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
  Future<void> removeTagFromNote(String noteId, String name) {
    return db.delete('NoteTag', where: 'NoteID = ? AND Name = ?', whereArgs: [noteId, name]).then((value) {
      return Future.value();
    });
  }

  @override
  Future<NoteTag> updateTag(NoteTag tag) {
    return db.update('NoteTag', {
      'NoteID': tag.noteId,
      'Name': tag.name,
      'Color': tag.color,
    }, where: 'NoteID = ? AND Name = ?', whereArgs: [tag.noteId, tag.name]).then((value) {
      return Future.value(tag);
    });
  }
}
