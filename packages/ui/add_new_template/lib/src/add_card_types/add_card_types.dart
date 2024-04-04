import 'package:add_new_template/src/bloc/bloc.dart';
import 'package:add_new_template/src/bloc/event.dart';
import 'package:add_new_template/src/bloc/state.dart';
import 'package:add_new_template/src/card_name.dart';
import 'package:add_new_template/src/add_card_types/chosen_fields_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardTypesPage extends StatelessWidget {
  const AddCardTypesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card Types'),
      ),
      body: _AddCardTypes(),
    );
  }
}

class _AddCardTypes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewTemplateBloc, AddNewTemplateState>(
      builder: (context, state) {
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
      return ChosenFieldsList(
        availableFields: state.fields.where((element) =>
              !state.cardTypes[index].frontFields.contains(element) &&
              !state.cardTypes[index].backFields.contains(element)).toList(),
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
      );
    });
  }
}
