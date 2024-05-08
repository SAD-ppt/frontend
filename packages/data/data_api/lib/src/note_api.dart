import '../data_api.dart';

abstract interface class NoteApi {
  /// Get all notes, with their fields.
  Stream<List<NoteDetail>> getNotesStream() => throw NotSupportedError();

  /// Get all notes, with their fields.
  Future<List<NoteDetail>> getNotes();

  /// Get a note, with its fields.
  Future<NoteDetail?> getNote(String id);

  /// Creates a note from a note template, with the given field values. Order of
  /// field values should match the order of fields in the note template.
  Future<Note> createNote(
      String deckId, String noteTemplateId, List<String> fieldValues);

  /// Updates the fields of a note. Order of fields should match the order of
  /// fields in the note template.
  Future<Note> updateNoteFields(String noteId, List<NoteField> noteFields);

  /// Updates a single field of a note by index.
  Future<Note> updateNoteField(String noteId, int idx, String value);

  /// Delete a note
  Future<void> deleteNote(String id);
}
