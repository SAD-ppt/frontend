import 'package:data_api/data_api.dart' as api;
import 'package:data_api/data_api.dart'
    show NoteTemplateApi, CardTemplateApi, CardSide;
import 'package:repos/src/models/note_template.dart';
import 'package:uuid/uuid.dart';

class NoteTemplateRepo {
  final NoteTemplateApi noteTemplateApi;
  final CardTemplateApi cardTemplateApi;

  NoteTemplateRepo(
      {required this.noteTemplateApi, required this.cardTemplateApi});

  /// Creates a new note template with the given [name] and [fieldNames].
  /// The newly created note will have no associated card templates.
  /// Returns the newly created note template.
  Future<void> createNewNoteTemplate(
    String name,
    List<String> fieldNames,
  ) async {
    final (api.NoteTemplate noteTemplate, List<api.NoteTemplateField> fields) =
        await noteTemplateApi.createNoteTemplate(name, fieldNames);
  }

  /// Creates a new card template with the given [name] and [front] and [back]
  Future<void> createNewCardTemplate(
    Uuid noteTemplateId,
    String name,
    List<String> front,
    List<String> back,
  ) async {
    throw UnimplementedError();
  }

  /// Deletes the note template with the given [id]. This will also delete all
  /// fields and card templates associated with the note template.
  Future<void> deleteNoteTemplate(Uuid id) async {
    throw UnimplementedError();
  }

  Stream<List<NoteTemplate>> getAllNoteTemplates() {
    throw UnimplementedError();
  }
}
