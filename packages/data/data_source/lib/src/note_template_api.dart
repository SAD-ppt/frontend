import 'package:data_source/src/model/note_template.dart';

abstract interface class NoteTemplateApi {
  Stream<Map<NoteTemplate, List<NoteTemplateField>>> getNoteTemplates();
  Future<(NoteTemplate template, List<NoteTemplateField> fields)>
      getNoteTemplate(String id);
  Future<NoteTemplate> createNoteTemplate(
      NoteTemplate noteTemplate, List<NoteTemplateField> noteFields);
  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate);
  Future<NoteTemplate> updateNoteFields(
      String noteTemplateId, List<NoteTemplateField> noteFields);
  Future<void> deleteNoteField(String id);
  Future<void> deleteNoteTemplate(String id);
}
