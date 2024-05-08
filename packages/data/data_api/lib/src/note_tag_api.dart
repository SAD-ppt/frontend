import 'model/note_tag.dart';

abstract interface class NoteTagApi {
  /// Returns tags associated with a note. If [noteId] is null, returns all card tags.
  Future<List<NoteTag>> getTags(String? noteId);
  Future<NoteTag> getTagsOfNoteByName(String noteId, String name);
  Future<NoteTag> createTag(String name, {String? color});
  Future<void> addTagToNote(String noteId, String name);
  Future<void> removeTagFromNote(String noteId, String name);
  Future<NoteTag> updateTag(NoteTag tag);
  Future<int> getNumTagsOfNote(String noteId);
}
