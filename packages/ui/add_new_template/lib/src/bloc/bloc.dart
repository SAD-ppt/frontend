import 'dart:async';

import 'package:add_new_template/src/bloc/event.dart';
import 'package:add_new_template/src/bloc/state.dart';
import 'package:add_new_template/src/card_type.dart';
import 'package:bloc/bloc.dart';

class AddNewTemplateBloc
    extends Bloc<AddNewTemplateEvent, AddNewTemplateState> {
  AddNewTemplateBloc() : super(const AddNewTemplateState()) {
    on<NameChanged>(_onNameChanged);
    on<FieldsChanged>(_onFieldsChanged);
    on<AddNewCardType>(_onAddNewCardType);
    on<RemoveCardType>(_onRemoveCardType);
    on<Submit>(_onSubmit);
    on<Cancel>(_onCancel);
    on<AddFieldToCardType>(_onAddFieldToCardType);
    on<RemoveFieldFromCardType>(_onRemoveFieldFromCardType);
  }

  FutureOr<void> _onNameChanged(
      NameChanged event, Emitter<AddNewTemplateState> emit) {
    emit(state.copyWith(templateName: event.name));
  }

  FutureOr<void> _onFieldsChanged(
      FieldsChanged event, Emitter<AddNewTemplateState> emit) {
    emit(state.copyWith(fields: event.fields));
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

  FutureOr<void> _onSubmit(Submit event, Emitter<AddNewTemplateState> emit) {}

  FutureOr<void> _onCancel(Cancel event, Emitter<AddNewTemplateState> emit) {}

  FutureOr<void> _onAddFieldToCardType(
      AddFieldToCardType event, Emitter<AddNewTemplateState> emit) {
    final cardType = state.cardTypes[event.index];
    if (event.isFront) {
      emit(state.copyWith(
        cardTypes: [
          ...state.cardTypes..removeAt(event.index),
          cardType.copyWith(frontFields: [...cardType.frontFields, event.field]),
        ],
        fields: state.fields..remove(event.field),
      ));
    } else {
      emit(state.copyWith(
        cardTypes: [
          ...state.cardTypes..removeAt(event.index),
          cardType.copyWith(backFields: [...cardType.backFields, event.field]),
        ],
        fields: state.fields..remove(event.field),
      ));
    }
  }

  FutureOr<void> _onRemoveFieldFromCardType(
      RemoveFieldFromCardType event, Emitter<AddNewTemplateState> emit) {
    final cardType = state.cardTypes[event.index];
    if (event.isFront) {
      emit(state.copyWith(
        cardTypes: [
          ...state.cardTypes..removeAt(event.index),
          cardType.copyWith(frontFields: cardType.frontFields..removeAt(event.fieldIndex)),
        ],
        fields: [...state.fields, cardType.frontFields[event.fieldIndex]],
      ));
    } else {
      emit(state.copyWith(
        cardTypes: [
          ...state.cardTypes..removeAt(event.index),
          cardType.copyWith(backFields: cardType.backFields..removeAt(event.fieldIndex)),
        ],
        fields: [...state.fields, cardType.backFields[event.fieldIndex]],
      ));
    }
  }
}
