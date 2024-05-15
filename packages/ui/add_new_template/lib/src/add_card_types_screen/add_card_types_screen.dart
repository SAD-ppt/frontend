import 'package:add_new_template/src/add_card_types_screen/card_type_name.dart';

import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drag_and_drop_fields_select_form.dart';

class AddCardTypesScreen extends StatelessWidget {
  const AddCardTypesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Add Card Types'),
          IconButton(
              onPressed: () {
                context.read<AddNewTemplateBloc>().add(const Submit());
              },
              icon: const Icon(Icons.check))
        ]),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _AddCardTypes(),
      ),
    );
  }
}

class _AddCardTypes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewTemplateBloc, AddNewTemplateState>(
      builder: (context, state) {
        if (state.status == AddNewTemplateStatus.success) {
          Navigator.of(context).pop();
        }
        return ListView(
          children: [
            for (var i = 0; i < state.cardTypes.length; i++)
              _CardTypeForm(index: i),
            ElevatedButton(
              onPressed: () {
                context.read<AddNewTemplateBloc>().add(const AddNewCardType());
              },
              child: const Text('Add Card Type'),
            ),
          ],
        );
      },
    );
  }
}

class _CardTypeForm extends StatelessWidget {
  final int index;
  const _CardTypeForm({required this.index});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewTemplateBloc, AddNewTemplateState>(
        builder: (context, state) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CardTypeName(
                  onChanged: (name) => context
                      .read<AddNewTemplateBloc>()
                      .add(CardTypeNameChanged(index, name))),
              const SizedBox(height: 16),
              DragAndDropFieldsSelectForm(
                availableFields: state.fields
                    .where((element) =>
                        !state.cardTypes[index].frontFields.contains(element) &&
                        !state.cardTypes[index].backFields.contains(element))
                    .toList(),
                frontFields: state.cardTypes[index].frontFields,
                backFields: state.cardTypes[index].backFields,
                onFrontFieldAdded: (field) {
                  context.read<AddNewTemplateBloc>().add(
                        AddFieldToCardType(index, field, true),
                      );
                },
                onBackFieldAdded: (field) {
                  context.read<AddNewTemplateBloc>().add(
                        AddFieldToCardType(index, field, false),
                      );
                },
                onFrontFieldRemoved: (field) {
                  context.read<AddNewTemplateBloc>().add(
                        RemoveFieldFromCardType(index, field, true),
                      );
                },
                onBackFieldRemoved: (field) {
                  context.read<AddNewTemplateBloc>().add(
                        RemoveFieldFromCardType(index, field, false),
                      );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
