import 'package:data_api/data_api.dart' as api;
import 'package:flutter/src/material/card.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repos/repos.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import 'mocked_database.dart';

void main() {
  test("Create new note template", () async {
    final mockedDatabase = MockedDatabase();
    final noteTemplateRepo = NoteTemplateRepo(
        noteTemplateApi: mockedDatabase, cardTemplateApi: mockedDatabase);
    noteTemplateRepo.createNewNoteTemplate("template1", [
      "field1",
      "field2",
      "field3",
      "field4",
    ], [
      (["field1", "field2"], ["field3", "field4"]),
      (["field1", "field3"], ["field2", "field4"]),
    ]);
    late String id;
    await noteTemplateRepo.getAllNoteTemplates().first.then((value) {
      expect(value.length, 1);
      expect(value[0].name, "template1");
      expect(value[0].fieldNames, ["field1", "field2", "field3", "field4"]);
      id = value[0].id;
    });
    final ntt = await noteTemplateRepo.getNoteTemplateDetail(id);
    final fronts = ntt.cardTemplates.map((ct) => ct.front).toList();
    final backs = ntt.cardTemplates.map((ct) => ct.back).toList();
    expect(fronts, [
      ["field1", "field2"],
      ["field1", "field3"],
    ]);
    expect(backs, [
      ["field3", "field4"],
      ["field2", "field4"],
    ]);
  });

  test("Create invalid note template", () {
    final mockedDatabase = MockedDatabase();
    final noteTemplateRepo = NoteTemplateRepo(
        noteTemplateApi: mockedDatabase, cardTemplateApi: mockedDatabase);
    expect(
        () => noteTemplateRepo.createNewNoteTemplate("template1", [
              "field1",
              "field2",
              "field3",
              "field4",
            ], [
              (["field1", "field2"], ["field3", "field4"]),
              (["field152", "field3"], ["field2", "field4"]),
            ]),
        throwsArgumentError);
  });
}
