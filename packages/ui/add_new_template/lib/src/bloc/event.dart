import 'package:equatable/equatable.dart';

sealed class AddNewTemplateEvent extends Equatable {
  const AddNewTemplateEvent();

  @override
  List<Object> get props => [];
}

final class NameChanged extends AddNewTemplateEvent {
  final String name;

  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}

final class FieldsChanged extends AddNewTemplateEvent {
  final List<String> fields;

  const FieldsChanged(this.fields);

  @override
  List<Object> get props => [fields];
}

final class AddNewCardType extends AddNewTemplateEvent {
  const AddNewCardType();
}

final class RemoveCardType extends AddNewTemplateEvent {
  final int index;

  const RemoveCardType(this.index);

  @override
  List<Object> get props => [index];
}

final class Submit extends AddNewTemplateEvent {
  const Submit();
}

final class Cancel extends AddNewTemplateEvent {
  const Cancel();
}

final class CardTypeNameChanged extends AddNewTemplateEvent {
  final int index;
  final String name;

  const CardTypeNameChanged(this.index, this.name);

  @override
  List<Object> get props => [index, name];
}

final class AddFieldToCardType extends AddNewTemplateEvent {
  final int index;
  final String field;
  final bool isFront;

  const AddFieldToCardType(this.index, this.field, this.isFront);

  @override
  List<Object> get props => [index, field, isFront];
}

final class RemoveFieldFromCardType extends AddNewTemplateEvent {
  final int index;
  final String field;
  final bool isFront;

  const RemoveFieldFromCardType(this.index, this.field, this.isFront);

  @override
  List<Object> get props => [index, field, isFront];
}

