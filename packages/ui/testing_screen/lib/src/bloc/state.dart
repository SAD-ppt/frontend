import 'package:equatable/equatable.dart';
import 'package:testing_screen/src/testing_panel_widget.dart';

enum TestingCardStatus { initial, loading, success, finish, error }

enum TestingCardSide { front, back }

class TestingScreenState extends Equatable {
  const TestingScreenState(
      {required this.deckId,
      required this.side,
      required this.status,
      required this.cardInfo,
      required this.noteId,
      required this.cardTemplateId,
      required this.numCardOfDeck,
      required this.numCorrectDeck});
  final String deckId;
  final String noteId;
  final String cardTemplateId;
  final TestingCardStatus status;
  final TestingCardSide side;
  final CardInfo? cardInfo;
  final int numCardOfDeck;
  final int numCorrectDeck;

  @override
  List<Object?> get props => [deckId, side, status, cardInfo, numCardOfDeck, numCorrectDeck, noteId, cardTemplateId];

  TestingScreenState copyWith(
      {TestingCardSide? side,
      TestingCardStatus? status,
      CardInfo? cardInfo,
      String? deckId,
      String? noteId,
      String? cardTemplateId,
      int? numCardOfDeck,
      int? numCorrectDeck
      }) {
    return TestingScreenState(
      noteId: noteId ?? this.noteId,
      cardTemplateId: cardTemplateId ?? this.cardTemplateId,
      deckId: deckId ?? this.deckId,
      side: side ?? this.side,
      status: status ?? this.status,
      cardInfo: cardInfo ?? this.cardInfo,
      numCardOfDeck: numCardOfDeck ?? this.numCardOfDeck,
      numCorrectDeck: numCorrectDeck ?? this.numCorrectDeck
    );
  }

  const TestingScreenState.initial()
      : this(
            deckId: "",
            side: TestingCardSide.front,
            status: TestingCardStatus.initial,
            cardInfo: null,
            noteId: "",
            cardTemplateId: "",
            numCardOfDeck: 0,
            numCorrectDeck: 0
            );
}
