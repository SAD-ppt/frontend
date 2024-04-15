import 'package:data_api/src/model/note_template.dart';
import 'package:uuid/uuid.dart';

abstract interface class NoteTemplateApi {
  Stream<Map<NoteTemplate, List<NoteTemplateField>>> getNoteTemplates();

  Future<(NoteTemplate template, List<NoteTemplateField> fields)>
      getNoteTemplate(Uuid id);

  Future<(NoteTemplate, List<NoteTemplateField>)> createNoteTemplate(
      String name, List<String> noteFieldNames);

  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate);

  Future<NoteTemplate> updateNoteFields(
      String noteTemplateId, List<NoteTemplateField> noteFields);

  Future<void> deleteNoteField(Uuid id);

  Future<void> deleteNoteTemplate(Uuid id);
}
