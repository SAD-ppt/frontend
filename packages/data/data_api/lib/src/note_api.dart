import 'dart:ffi';

import './model/note.dart';
import 'package:uuid/uuid.dart';

abstract interface class NoteApi {
  Stream<Map<Note, List<NoteField>>> getNotes();
  Future<(Note template, List<NoteField> fields)> getNote(Uuid id);
  Future<Note> createNote(Note note, List<NoteField> noteFields);
  Future<Note> updateNote(Note note);
  Future<Note> updateNoteFields(Uuid noteId, List<NoteField> noteFields);
  Future<Note> updateNoteField(NoteField noteField);
  Future<void> deleteNoteField(Uuid id, Int orderNumber);
  Future<void> deleteNote(String id);
}
