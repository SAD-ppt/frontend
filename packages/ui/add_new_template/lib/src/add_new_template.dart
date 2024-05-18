import '/src/add_card_types_screen/add_card_types_screen.dart';
import '/src/add_fields_screen/add_fields_screen.dart';
import '/src/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repos/repos.dart';

class AddNewTemplateScreen extends StatelessWidget {
  final void Function() onDone;
  final void Function() onBack;
  const AddNewTemplateScreen({
    required this.onDone,
    required this.onBack,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNewTemplateBloc(
          onSuccess: onDone,
          noteTemplateRepo: context.read<NoteTemplateRepo>()),
      child: Navigator(
        initialRoute: 'add_new_template/add_fields',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case 'add_new_template/add_fields':
              builder = (BuildContext _) => AddFieldsScreen(
                    onBack: onBack,
                  );
            case 'add_new_template/add_card_types':
              builder = (BuildContext context) => const AddCardTypesScreen();
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }
}
