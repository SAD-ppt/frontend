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

  void validateCardTemplates(
    String name,
    List<String> noteFields,
    List<(List<String> frontFields, List<String> backFields)> cardTemplates,
  ) {
    var fields = Set.from(noteFields);
    for (var i = 0; i < cardTemplates.length; i++) {
      var (front, back) = cardTemplates[i];
      for (var field in front) {
        if (!fields.contains(field)) {
          throw ArgumentError('All card templates must have the same fields');
        }
      }
      for (var field in back) {
        if (!fields.contains(field)) {
          throw ArgumentError('All card templates must have the same fields');
        }
      }
      if (name.isEmpty) {
        throw ArgumentError('name cannot be empty');
      } else if (cardTemplates.isEmpty) {
        throw ArgumentError('cardTemplates cannot be empty');
      } else if (cardTemplates.any((cardTemplate) {
        var (front, back) = cardTemplate;
        return front.isEmpty || back.isEmpty;
      })) {
        throw ArgumentError('frontFields and backFields cannot be empty');
      }
    }

    Future<void> createNewNoteTemplate(
      String name,
      List<String> noteFields,
      List<(List<String> frontFields, List<String> backFields)> cardTemplates,
    ) async {
      validateCardTemplates(name, noteFields, cardTemplates);
      var (newNoteTemplate, fields) =
          await noteTemplateApi.createNoteTemplate(name, noteFields);
      var noteFieldsIndexMap = <String, int>{};
      for (var i = 0; i < noteFields.length; i++) {
        noteFieldsIndexMap[noteFields[i]] = i;
      }
      for (var cardTemplate in cardTemplates) {
        var (frontFields, backFields) = cardTemplate;
        var mappedFront = frontFields
            .map((e) => (api.CardSide.front, noteFieldsIndexMap[e]!))
            .toList();
        var mappedBack = backFields
            .map((e) => (api.CardSide.back, noteFieldsIndexMap[e]!))
            .toList();
        var cardTemplateFields = mappedFront + mappedBack;
        await cardTemplateApi.createNewCardTemplate(
          newNoteTemplate.id,
          name,
          cardTemplateFields,
        );
      }
    }
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
