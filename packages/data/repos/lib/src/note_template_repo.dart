import 'package:data_api/data_api.dart' as api;
import 'package:repos/src/models/note_template.dart';
import 'package:uuid/uuid.dart';

class NoteTemplateRepo {
  final api.NoteTemplateApi noteTemplateApi;
  final api.CardTemplateApi cardTemplateApi;

  NoteTemplateRepo(
      {required this.noteTemplateApi, required this.cardTemplateApi});

  void _validateCardTemplates(
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

    /// Create a new note template with the given [name], [noteFields], and
    /// [cardTemplates]. The [noteFields] are the fields that the note template
    /// will have. The [cardTemplates] are the templates for the cards that will
    /// be created from the note template. Each card template is a tuple of
    /// [frontFields] and [backFields]. The [frontFields] are the fields that
    /// will be shown on the front of the card, and the [backFields] are the
    /// fields that will be shown on the back of the card.
    /// Fields in [frontFields] and [backFields] must be in [noteFields],
    /// otherwise an [ArgumentError] will be thrown.
    Future<void> createNewNoteTemplate(
      String name,
      List<String> noteFields,
      List<(List<String> frontFields, List<String> backFields)> cardTemplates,
    ) async {
      _validateCardTemplates(name, noteFields, cardTemplates);
      var (
        api.NoteTemplate newNoteTemplate,
        List<api.NoteTemplateField> fields
      ) = await noteTemplateApi.createNoteTemplate(name, noteFields);
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

  Future<NoteTemplate> getNoteTemplate(Uuid id) {
    throw UnimplementedError();
  }

  Future<void> deleteNoteTemplateField(Uuid id, int orderNumber) {
    throw UnimplementedError();
  }
}
