import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'fields_list.dart';
import 'template_name.dart';

class AddFieldsScreen extends StatelessWidget {
  const AddFieldsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Fields'),
          leading: const BackButton(),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                TemplateName(onChanged: (p) {
                  context.read<AddNewTemplateBloc>().add(NameChanged(p));
                }),
                const Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 16),
                    child: Divider()),
                FieldsList(onFieldsChanged: (p) {
                  context.read<AddNewTemplateBloc>().add(FieldsChanged(p));
                }),
                const SizedBox(height: 16),
              ],
            )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton.outlined(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('add_new_template/add_card_types');
                    },
                    icon: const Icon(Icons.navigate_next),
                  ),
                ))
          ],
        ));
  }
}
