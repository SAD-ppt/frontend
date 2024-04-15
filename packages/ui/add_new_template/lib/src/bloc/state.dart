import 'package:add_new_template/src/card_type.dart';
import 'package:equatable/equatable.dart';

enum AddNewTemplateStatus {
  initial,
  loading,
  success,
  error,
}

enum AddNewTemplateStep {
  templateNameAndFields,
  cardTypes,
}

class AddNewTemplateState extends Equatable {
  final AddNewTemplateStatus status;
  final String templateName;
  final List<String> fields;
  final List<CardType> cardTypes;
  final AddNewTemplateStep step;

  const AddNewTemplateState({
    this.status = AddNewTemplateStatus.initial,
    this.templateName = "",
    this.fields = const [],
    this.step = AddNewTemplateStep.templateNameAndFields,
    this.cardTypes = const [
      CardType.empty(),
    ],
  });

  AddNewTemplateState copyWith({
    AddNewTemplateStatus? status,
    String? templateName,
    List<String>? fields,
    List<CardType>? cardTypes,
    AddNewTemplateStep? step,
  }) {
    return AddNewTemplateState(
      status: status ?? this.status,
      templateName: templateName ?? this.templateName,
      fields: fields ?? this.fields,
      cardTypes: cardTypes ?? this.cardTypes,
      step: step ?? this.step,
    );
  }

  @override
  List<Object> get props => [
        status,
        templateName,
        fields,
        cardTypes,
        step,
      ];
}
