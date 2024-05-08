import 'package:data_api/data_api.dart' as api;
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'models/note.dart';

class NoteRepo {
  final api.NoteTagApi noteTagApi;
  final api.NoteApi noteApi;
  final api.NoteTemplateApi noteTemplateApi;

  NoteRepo(
      {required this.noteApi,
      required this.noteTemplateApi,
      required this.noteTagApi});

  Stream<Iterable<Note>> getNotesOfDeck(String deckId) {
    return noteApi.getNotes().asyncMap((List<api.NoteDetail> notes) async {
      // Get note templates to get field names, this functionality should be
      // moved to the API, but it's working ok because numbers of note templates
      // is small.
      var noteTemplates = await noteTemplateApi.getNoteTemplates().first;
      return Future.wait(notes.map((note) async {
        var noteTemplate = noteTemplates.firstWhere(((ntd) =>
            ntd.noteTemplate.id.toString() == note.note.noteTemplateId));
        var tags = await noteTagApi.getTags(
          note.note.id,
        );
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
          tags: tags.map((tag) => tag.name).toList(),
        );
      }).toList());
    });
  }

  Future<void> addTagToNote(String noteId, String name) {
    return noteTagApi.createTag(
      noteId,
      name,
    );
  }

  /// Creates a note from a note template, with the given field values. Order of
  /// field values should match the order of fields in the note template.
  Future<void> createNote(
      String deckId, String noteTemplateId, List<String> fieldValues,
      {List<String>? tags}) async {
    await noteApi
        .createNote(deckId, noteTemplateId, fieldValues)
        .then((note) async {
      // Add tags to note
      if (tags != null) {
        for (var tag in tags) {
          await addTagToNote(
            note.id,
            tag,
          );
        }
      }
    });
  }
}
