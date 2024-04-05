import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

enum CardSide { front, back }

@immutable
class CardTemplateField extends Equatable {
  final Uuid cardTemplateId;
  final int orderNumber;
  final CardSide side;

  const CardTemplateField({
    required this.cardTemplateId,
    required this.orderNumber,
    required this.side,
  });

  @override
  List<Object> get props => [cardTemplateId, orderNumber, side];
}

@immutable
class CardTemplate extends Equatable {
  final Uuid id;
  final Uuid noteTemplateId;
  final String name;

  const CardTemplate({
    required this.id,
    required this.noteTemplateId,
    required this.name,
  });

  @override
  List<Object> get props => [id, noteTemplateId, name];
}
