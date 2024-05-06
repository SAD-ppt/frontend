import 'model/note_template.dart';

abstract interface class NoteTemplateApi {
  Stream<List<NoteTemplateDetail>> getNoteTemplates();

  Future<NoteTemplateDetail> getNoteTemplate(String id);

  Future<NoteTemplateDetail> createNoteTemplate(
      String name, List<String> noteFieldNames);

  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate);

  Future<void> deleteNoteField(String id);

  Future<void> deleteNoteTemplate(String id);
}
