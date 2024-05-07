import 'package:data_api/data_api.dart';
import 'package:sqlite_data/sqlite_data.dart';

// test that the SqliteDB class can be instantiated


Future<void> main() async {
  var sqliteDB = SqliteDB();
  if (sqliteDB != null) {
    print('SqliteDB instantiated successfully');
  } else {
    print('SqliteDB not instantiated');
  }
  sqliteDB.cardApiHandler!.getCard('1');
}