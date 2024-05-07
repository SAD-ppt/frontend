import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class NoteApiHandler implements NoteApi {
  final Future<Database> db;
  const NoteApiHandler({required this.db});
  @override
  Future<Note> createNote(String noteTemplateId, List<String> fieldValues) {
    // TODO: implement createNote
    throw UnimplementedError();
  }
  @override
  Future<void> deleteNote(String id) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }
  @override
  Future<NoteDetail> getNote(String id) {
    // TODO: implement getNote
    throw UnimplementedError();
  }
  @override
  Stream<List<NoteDetail>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }
  @override
  Future<Note> updateNoteField(String noteId, int idx, String value) {
    // TODO: implement updateNoteField
    throw UnimplementedError();
  }
  @override
  Future<Note> updateNoteFields(String noteId, List<NoteField> noteFields) {
    // TODO: implement updateNoteFields
    throw UnimplementedError();
  }
}
