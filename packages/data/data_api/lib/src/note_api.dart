import 'dart:ffi';

import './model/note.dart';
import 'package:uuid/uuid.dart';

abstract interface class NoteApi {
  /// Get all notes, with their fields.
  Stream<List<NoteDetail>> getNotes();

  /// Get a note, with its fields.
  Future<NoteDetail> getNote(Uuid id);

  /// Creates a note from a note template, with the given field values. Order of
  /// field values should match the order of fields in the note template.
  Future<Note> createNote(Uuid noteTemplateId, List<String> fieldValues);

  /// Updates the fields of a note. Order of fields should match the order of
  /// fields in the note template.
  Future<Note> updateNoteFields(Uuid noteId, List<NoteField> noteFields);

  /// Updates a single field of a note by index.
  Future<Note> updateNoteField(Uuid noteId, int idx, String value);

  /// Delete a note
  Future<void> deleteNote(Uuid id);
}
