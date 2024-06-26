import 'dart:async';

import 'package:add_new_template/src/bloc/event.dart';
import 'package:add_new_template/src/bloc/state.dart';
import 'package:add_new_template/src/card_type.dart';
import 'package:bloc/bloc.dart';
import 'package:repos/repos.dart';

class AddNewTemplateBloc
    extends Bloc<AddNewTemplateEvent, AddNewTemplateState> {
  final NoteTemplateRepo noteTemplateRepo;
  final void Function() onSuccess;
  AddNewTemplateBloc({required this.onSuccess, required this.noteTemplateRepo})
      : super(const AddNewTemplateState()) {
    on<NameChanged>(_onNameChanged);
    on<FieldsChanged>(_onFieldsChanged);
    on<AddNewCardType>(_onAddNewCardType);
    on<RemoveCardType>(_onRemoveCardType);
    on<Submit>(_onSubmit);
    on<Cancel>(_onCancel);
    on<AddFieldToCardType>(_onAddFieldToCardType);
    on<RemoveFieldFromCardType>(_onRemoveFieldFromCardType);
    on<CardTypeNameChanged>(_onCardTypeNameChanged);
  }

  FutureOr<void> _onNameChanged(
      NameChanged event, Emitter<AddNewTemplateState> emit) {
    emit(state.copyWith(templateName: event.name));
  }

  FutureOr<void> _onFieldsChanged(
      FieldsChanged event, Emitter<AddNewTemplateState> emit) {
    final cardTypes = state.cardTypes.map((cardType) {
      final frontFields = cardType.frontFields.where((field) {
        return event.fields.contains(field);
      }).toList();
      final backFields = cardType.backFields.where((field) {
        return event.fields.contains(field);
      }).toList();
      return cardType.copyWith(
          frontFields: frontFields, backFields: backFields);
    }).toList();
    emit(state.copyWith(fields: event.fields, cardTypes: cardTypes));
  }

  FutureOr<void> _onAddNewCardType(
      AddNewCardType event, Emitter<AddNewTemplateState> emit) {
    emit(state.copyWith(
      cardTypes: [
        ...state.cardTypes,
        const CardType.empty(),
      ],
    ));
  }

  FutureOr<void> _onRemoveCardType(
      RemoveCardType event, Emitter<AddNewTemplateState> emit) {
    emit(state.copyWith(
      cardTypes: state.cardTypes..removeAt(event.index),
    ));
  }

  FutureOr<void> _onSubmit(
      Submit event, Emitter<AddNewTemplateState> emit) async {
    final cardTypes = state.cardTypes.map((cardType) {
      final frontFields = cardType.frontFields;
      final backFields = cardType.backFields;
      return (frontFields, backFields);
    }).toList();
    await noteTemplateRepo.createNewNoteTemplate(
      state.templateName,
      state.fields,
      cardTypes,
    );
    emit(state.copyWith(status: AddNewTemplateStatus.success));
    onSuccess();
  }

  FutureOr<void> _onCancel(Cancel event, Emitter<AddNewTemplateState> emit) {}

  FutureOr<void> _onAddFieldToCardType(
      AddFieldToCardType event, Emitter<AddNewTemplateState> emit) {
    final newCardTypes = state.cardTypes.indexed.map((e) {
      final (index, cardType) = e;
      if (index == event.index) {
        if (event.isFront) {
          return cardType.addFieldToFront(event.field);
        } else {
          return cardType.addFieldToBack(event.field);
        }
      }
      return cardType;
    }).toList();
    emit(state.copyWith(cardTypes: newCardTypes));
  }

  FutureOr<void> _onRemoveFieldFromCardType(
      RemoveFieldFromCardType event, Emitter<AddNewTemplateState> emit) {
    final newCardTypes = state.cardTypes.indexed.map((e) {
      final (index, cardType) = e;
      if (index == event.index) {
        if (event.isFront) {
          return cardType.removeFieldFromFront(event.field);
        } else {
          return cardType.removeFieldFromBack(event.field);
        }
      }
      return cardType;
    }).toList();
    emit(state.copyWith(cardTypes: newCardTypes));
  }

  FutureOr<void> _onCardTypeNameChanged(
      CardTypeNameChanged event, Emitter<AddNewTemplateState> emit) {
    final newCardTypes = state.cardTypes.indexed.map((e) {
      final (index, cardType) = e;
      if (index == event.index) {
        return cardType.copyWith(name: event.name);
      }
      return cardType;
    }).toList();
    emit(state.copyWith(cardTypes: newCardTypes));
  }
}
