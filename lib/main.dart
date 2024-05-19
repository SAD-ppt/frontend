import 'package:add_new_template/add_new_template.dart';
import 'package:card_browser/card_browser.dart';
import 'package:data_api/data_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:testing_screen/testing_screen.dart';
// import 'package:testing_screen/testing_screen.dart';
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
                  noteApi: db.noteApiHandler,
                  cardTemplateApi: db.cardTemplateApiHandler,
                  deckApi: db.deckApiHandler,
                  cardApi: db.cardApiHandler)),
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

  onBackCallback() => Navigator.of(context).pop();

  onFinishedCallBack() => Navigator.of(context).popUntil((route) => route.isFirst);

  // Create builder functions for each screen
  builderAddNewCard(context) => AddNewCardPage(
    onBack: onBackCallback,
    onDone: onBackCallback,
  );

  builderAddNewTemplate(context) => AddNewTemplateScreen(
    onBack: onBackCallback,
    onDone: onBackCallback,
  );

  // Create MaterialPageRoute for each screen
  MaterialPageRoute addNewCardRoute = MaterialPageRoute(
    builder: builderAddNewCard,
  );

  MaterialPageRoute addNewTemplateRoute = MaterialPageRoute(
    builder: builderAddNewTemplate,
  );

  MaterialPageRoute testingRoute( deckId ) => MaterialPageRoute(
    builder: (context) => TestingScreen(
      deckId: deckId,
      onBack: onBackCallback,
      onFinished: onFinishedCallBack,
    ),
  );

  MaterialPageRoute learningRoute( deckId ) => MaterialPageRoute(
    builder: (context) => LearningScreen(
      deckId: deckId,
      onBack: onBackCallback,
      onFinished: onFinishedCallBack,
    ),
  );

  MaterialPageRoute cardBrowserRoute( deckId ) => MaterialPageRoute(
    builder: (context) => CardBrowserScreen(
      deckId: deckId,
      onBack: onBackCallback,
      onReviewDeck: (deckId) => Navigator.of(context).push( learningRoute(deckId) ),
      onTestDeck: (deckId) => Navigator.of(context).push( testingRoute(deckId) ),
      onAddNewCard: () => Navigator.of(context).push( addNewCardRoute ),
    ),
  );

  MaterialPageRoute testingSetupRoute( deckId ) => MaterialPageRoute(
    builder: (context) => TestingSetupScreen(
      deckId: deckId,
      onCancel: onBackCallback,
      onStart: (deckId) => Navigator.of(context).push( testingRoute(deckId) ),
    ),
  );
  
    return MainScreen(
      onReviewDeck: (deckId) => Navigator.of(context).push( learningRoute(deckId) ),
      onTestDeck: (deckId) => Navigator.of(context).push( testingSetupRoute(deckId) ),
      onAddNewCard: () => Navigator.of(context).push( addNewCardRoute ),
      onDeckSelected: (deckId) => Navigator.of(context).push( cardBrowserRoute(deckId) ),
      onAddNewTemplate: () => Navigator.of(context).push( addNewTemplateRoute ),
    );
  }
}
