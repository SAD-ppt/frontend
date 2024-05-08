import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class NoteTagApiHandler implements NoteTagApi {
  final Database db;
  const NoteTagApiHandler({required this.db});
  @override
  Future<void> addTagToNote(String noteId, String name) {
    // TODO: implement addTagToNote
    throw UnimplementedError();
  }
  @override
  Future<NoteTag> createTag(String name, {String? color}) {
    // TODO: implement createTag
    throw UnimplementedError();
  }
  @override
  Future<int> getNumTagsOfNote(String noteId) {
    // TODO: implement getNumTagsOfNote
    throw UnimplementedError();
  }
  @override
  Future<List<NoteTag>> getTags(String? noteId) {
    // TODO: implement getTags
    throw UnimplementedError();
  }
  @override
  Future<NoteTag> getTagsOfNoteByName(String noteId, String name) {
    // TODO: implement getTagsOfNoteByName
    throw UnimplementedError();
  }
  @override
  Future<void> removeTagFromNote(String noteId, String name) {
    // TODO: implement removeTagFromNote
    throw UnimplementedError();
  }
  @override
  Future<NoteTag> updateTag(NoteTag tag) {
    // TODO: implement updateTag
    throw UnimplementedError();
  }
}
