import 'package:data_api/data_api.dart' as api;
import 'package:repos/repos.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class NoteTemplateRepo {
  final api.NoteTemplateApi noteTemplateApi;
  final api.CardTemplateApi cardTemplateApi;

  NoteTemplateRepo(
      {required this.noteTemplateApi, required this.cardTemplateApi});

  /// Deletes the note template with the given [id]. This will also delete all
  /// fields and card templates associated with the note template.
  Future<void> deleteNoteTemplate(String id) async {
    throw UnimplementedError();
  }

  Future<void> deleteNoteTemplateField(String id, int orderNumber) {
    throw UnimplementedError();
  }

  /// Gets all note templates.
  Stream<List<NoteTemplate>> getAllNoteTemplates() {
    final noteTemplates = noteTemplateApi.getNoteTemplates();
    final rs = noteTemplates.asyncMap((nts) async {
      return nts.map((nt) {
        return NoteTemplate(
          id: nt.noteTemplate.id,
          name: nt.noteTemplate.name,
          fieldNames: nt.fields.map((f) => f.name).toList(),
        );
      }).toList();
    });
    return rs;
  }

  Future<NoteTemplate> getNoteTemplate(String id) {
    throw UnimplementedError();
  }

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
          throw ArgumentError(
              'Fields in card templates must be in note fields');
        }
      }
      for (var field in back) {
        if (!fields.contains(field)) {
          throw ArgumentError(
              'Fields in card templates must be in note fields');
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
  }

  Future<NoteTemplateDetail> getNoteTemplateDetail(String id) async {
    final (nt, fields) = await noteTemplateApi.getNoteTemplate(id);
    final cardTemplates = await cardTemplateApi.getCardTemplates(nt.id).first;
    return NoteTemplateDetail(
        noteTemplate: NoteTemplate(
            id: nt.id,
            name: nt.name,
            fieldNames: fields.map((f) => f.name).toList()),
        cardTemplates: cardTemplates.map((ct) {
          return CardTemplate(
            id: ct.cardTemplate.id,
            name: ct.cardTemplate.name,
            front: ct.frontFields
                .where((f) => f.side == api.CardSide.front)
                .map((f) => fields[f.orderNumber].name)
                .toList(),
            back: ct.backFields
                .where((f) => f.side == api.CardSide.back)
                .map((f) => fields[f.orderNumber].name)
                .toList(),
          );
        }).toList());
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
    var (api.NoteTemplate newNoteTemplate, List<api.NoteTemplateField> fields) =
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
