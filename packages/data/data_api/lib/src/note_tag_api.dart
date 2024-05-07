import 'model/note_tag.dart';

abstract interface class NoteTagApi {
  /// Returns tags associated with a card. If [cardId] is null, returns all card tags.
  Future<List<NoteTag>> getTags(String? cardId);
  Future<NoteTag> getTagsOfNoteByName(String noteId, String name);
  Future<NoteTag> createTag(String noteId, String name, {String? color});
  Future<NoteTag> updateTag(NoteTag tag);
  Future<void> deleteTag(String cardId, String name);
  Future<int> getNumTagsOfCard(String cardId);
}
