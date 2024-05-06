import 'package:uuid/v4.dart';

import 'model/note_template.dart';
import 'package:uuid/uuid.dart';

abstract interface class NoteTemplateApi {
  Stream<List<NoteTemplateDetail>> getNoteTemplates();

  Future<(NoteTemplate template, List<NoteTemplateField> fields)>
      getNoteTemplate(String id);

  Future<(NoteTemplate, List<NoteTemplateField>)> createNoteTemplate(
      String name, List<String> noteFieldNames);

  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate);

  Future<void> deleteNoteField(String id);

  Future<void> deleteNoteTemplate(String id);
}
