import 'package:equatable/equatable.dart';

class CardType extends Equatable {
  final String name;
  final List<String> frontFields;
  final List<String> backFields;

  const CardType({
    required this.name,
    required this.backFields,
    required this.frontFields,
  });

  const CardType.empty()
      : name = "",
        frontFields = const [],
        backFields = const [];

  CardType addFieldToFront(String field) {
    if (frontFields.contains(field) || backFields.contains(field)) {
      return this;
    }
    return copyWith(
        frontFields: [...frontFields, field]);
  }

  CardType addFieldToBack(String field) {
    if (backFields.contains(field) || frontFields.contains(field)) {
      return this;
    }
    return copyWith(
        backFields: [...backFields, field]);
  }

  CardType removeFieldFromFront(String field) {
    return copyWith(
      frontFields: frontFields.where((element) => element != field).toList(),
    );
  }

  CardType removeFieldFromBack(String field) {
    return copyWith(
      backFields: backFields.where((element) => element != field).toList(),
    );
  }

  CardType copyWith({
    String? name,
    List<String>? frontFields,
    List<String>? backFields,
  }) {
    return CardType(
      name: name ?? this.name,
      frontFields: frontFields ?? this.frontFields,
      backFields: backFields ?? this.backFields,
    );
  }

  @override
  List<Object> get props => [name, frontFields, backFields];
}
