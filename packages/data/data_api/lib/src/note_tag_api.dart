import 'model/note_tag.dart';

abstract interface class NoteTagApi {
  /// Returns tags associated with a note. If [noteId] is null, 
  /// return all unique tags.
  Future<List<NoteTag>> getTags(String? noteId);

  /// Returns tags associated with a note. If [noteId] is null,
  /// return all unique tags.
  Future<NoteTag> getTagsOfNoteByName(String noteId, String name);

  /// Create a new tag with the given [name] and [color].
  Future<NoteTag> createTag(String name, {String? color});

  /// Add a tag to a note.
  Future<void> addTagToNote(String noteId, String name);
  Future<void> removeTagFromNote(String noteId, String name);

  Future<NoteTag> updateTag(NoteTag tag);
  Future<int> getNumTagsOfNote(String noteId);
}
