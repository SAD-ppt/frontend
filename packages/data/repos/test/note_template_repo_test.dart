import 'package:flutter_test/flutter_test.dart';

import 'package:repos/repos.dart';
import 'mocked_database.dart';

void main() {
  test("Create new note template and get associated card templates", () async {
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

  test("Create multiple note templates", () async {
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
    noteTemplateRepo.createNewNoteTemplate("template2", [
      "field1",
      "field2",
      "field3",
      "field4",
    ], [
      (["field1", "field2"], ["field3", "field4"]),
      (["field1", "field3"], ["field2", "field4"]),
    ]);
    await noteTemplateRepo.getAllNoteTemplates().first.then((value) {
      expect(value.length, 2);
      final resultTemplateNames = value.map((nt) => nt.name).toList();
      resultTemplateNames.sort();
      expect(resultTemplateNames, ["template1", "template2"]);

    });
  });
}
