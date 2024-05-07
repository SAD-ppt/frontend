import 'package:data_api/data_api.dart';
import 'package:sqflite/sqflite.dart';

class NoteTemplateApiHandler implements NoteTemplateApi {
  final Future<Database> db;
  const NoteTemplateApiHandler({required this.db});

  @override
  Future<NoteTemplateDetail> createNoteTemplate(
      String name, List<String> noteFieldNames) {
    // TODO: implement createNoteTemplate
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteField(String id) {
    // TODO: implement deleteNoteField
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNoteTemplate(String id) {
    // TODO: implement deleteNoteTemplate
    throw UnimplementedError();
  }

  @override
  Future<NoteTemplateDetail> getNoteTemplate(String id) {
    // TODO: implement getNoteTemplate
    throw UnimplementedError();
  }

  @override
  Stream<List<NoteTemplateDetail>> getNoteTemplates() {
    // TODO: implement getNoteTemplates
    throw UnimplementedError();
  }
  
  @override
  Future<NoteTemplate> updateNoteTemplate(NoteTemplate noteTemplate) {
    // TODO: implement updateNoteTemplate
    throw UnimplementedError();
  }
}
