import 'package:data_api/data_api.dart' as api;
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'models/note.dart';

class NoteRepo {
  final api.NoteApi noteApi;
  final api.NoteTemplateApi noteTemplateApi;

  NoteRepo({required this.noteApi, required this.noteTemplateApi});

  Stream<Iterable<Note>> getNotesOfDeck(String deckId) {
    return noteApi.getNotes().asyncMap((List<api.NoteDetail> notes) async {
      // Get note templates to get field names, this functionality should be
      // moved to the API, but it's working ok because numbers of note templates
      // is small.
      var noteTemplates = await noteTemplateApi.getNoteTemplates().first;
      return notes.map((note) {
        var noteTemplate = noteTemplates.firstWhere(((ntd) =>
            ntd.noteTemplate.id.toString() == note.note.noteTemplateId));
        // Map note fields to field names. This implementation is not efficient
        // and should be updated to use a map.
        var fields = noteTemplate.fields.map((field) {
          var noteField = note.fields
              .firstWhere(((nf) => nf.orderNumber == field.orderNumber));
          return (field.name, noteField.value);
        }).toList();
        return Note(
          id: note.note.id,
          fields: fields,
        );
      }).toList();
    });
  }

  /// Creates a note from a note template.
  Future<void> createNote(
      String noteTemplateId, List<(int order, String value)> fieldValues) {
    Set<int> orderNumbers = fieldValues.map((fv) => fv.$1).toSet();
    if (orderNumbers.length != fieldValues.length) {
      throw ArgumentError('Order numbers must be unique.');
    }
    // Sort field values by order number.
    fieldValues.sort((a, b) => a.$1.compareTo(b.$1));
    // Strip order numbers from field values.
    var strippedFieldValues = fieldValues.map((fv) => fv.$2).toList();
    return noteApi.createNote(noteTemplateId, strippedFieldValues);
  }
}
