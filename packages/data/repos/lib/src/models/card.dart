import 'package:data_api/data_api.dart' as api;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CardKey extends Equatable {
  final String deckId;
  final String noteId;
  final String cardTemplateId;

  const CardKey({
    required this.deckId,
    required this.noteId,
    required this.cardTemplateId,
  });

  @override
  List<Object> get props => [deckId, noteId, cardTemplateId];
}

extension ToCardKey on api.CardKey {
  CardKey toCardKey() {
    return CardKey(
      deckId: deckId,
      noteId: noteId,
      cardTemplateId: cardTemplateId,
    );
  }
}

extension ToCard on api.CardDetail {
  Card toCard() {
    final ctfs = cardTemplateFields.toList()
      ..sort((a, b) => a.orderNumber - b.orderNumber);
    final ntfs = noteTemplateFields.toList()
      ..sort((a, b) => a.orderNumber - b.orderNumber);
    final nfs = noteFields.toList()
      ..sort((a, b) => a.orderNumber - b.orderNumber);
    final List<(String, String, bool)> front = [];
    final List<(String, String, bool)> back = [];
    for (var i = 0; i < ctfs.length; i++) {
      final ctf = ctfs[i];
      final ntf = ntfs[i];
      final nf = nfs[i];
      if (ctf.side == api.CardSide.front) {
        front.add((ntf.name, nf.value, true));
      } else {
        back.add((ntf.name, nf.value, false));
      }
    }
    return Card(
      key: CardKey(
          deckId: card.deckId,
          noteId: card.noteId,
          cardTemplateId: card.cardTemplateId),
      front: front,
      back: back,
    );
  }
}

@immutable
class Card extends Equatable {
  final CardKey key;
  final List<(String name, String data, bool isFront)> front;
  final List<(String name, String data, bool isFront)> back;

  const Card({
    required this.key,
    required this.front,
    required this.back,
  });

  @override
  List<Object> get props => [front, back];
}
