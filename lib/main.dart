import 'package:add_new_template/add_new_template.dart';
import 'package:card_browser/card_browser.dart';
import 'package:data_api/data_api.dart';
import 'package:flutter/material.dart';
// import 'package:main_screen/main_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_screen/learning_screen.dart';
import 'package:login_screen/login_screen.dart';
// import 'package:login_screen/login_screen.dart';
import 'package:register_screen/register_screen.dart';
// import 'package:main_screen/main_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repos/repos.dart';
import 'package:sqlite_data/sqlite_data.dart';
import 'package:testing_setup/testing_setup.dart';
import 'package:add_new_card/add_new_card.dart';
import 'package:flutter/material.dart';
// import 'package:main_screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = SqliteDB();
  await db.init();
  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final SqliteDB db;
  const MyApp({super.key, required this.db});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext _) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CardRepo>(
              create: (context) => CardRepo(
                  cardApi: db.cardApiHandler,
                  noteApi: db.noteApiHandler,
                  learningStatApi: db.learningStatApiHandler,
                  cardTemplateApi: db.cardTemplateApiHandler)),
          RepositoryProvider<DeckRepo>(
              create: (context) => DeckRepo(
                  deckApi: db.deckApiHandler, cardApi: db.cardApiHandler)),
          RepositoryProvider<NoteRepo>(
              create: (context) => NoteRepo(
                  cardApi: db.cardApiHandler,
                  noteApi: db.noteApiHandler,
                  cardTemplateApi: db.cardTemplateApiHandler,
                  noteTemplateApi: db.noteTemplateApiHandler,
                  noteTagApi: db.noteTagApiHandler)),
          RepositoryProvider<NoteTemplateRepo>(
              create: (context) => NoteTemplateRepo(
                  noteTemplateApi: db.noteTemplateApiHandler,
                  cardTemplateApi: db.cardTemplateApiHandler)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Anki Clone',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
            useMaterial3: true,
          ),
          home: _UiRoot(),
        ));
  }
}

class _UiRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreen(
      onAddNewCard: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddNewCardPage()),
      ),
      onDeckSelected: (deckId) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CardBrowserScreen(),
        ),
      ),
      onAddNewTemplate: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddNewTemplateScreen()),
      ),
    );
  }
}
