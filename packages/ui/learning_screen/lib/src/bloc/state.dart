import 'package:equatable/equatable.dart';
import 'package:learning_screen/src/learning_panel_widget.dart';

enum LearningScreenStatus { initial, loading, success, error }

enum LearningCardSide { front, back }

class LearningScreenState extends Equatable {
  const LearningScreenState({required this.deckId, required this.side, required this.status, required this.cardInfo, required this.noteId, required this.cardTemplateId});
  final String deckId;
  final String noteId;
  final String cardTemplateId;
  final LearningScreenStatus status;
  final LearningCardSide side;
  final CardInfo? cardInfo;

  @override
  List<Object?> get props => [deckId, side, status, cardInfo];

  LearningScreenState copyWith({LearningCardSide? side, LearningScreenStatus? status, CardInfo? cardInfo, String? deckId, String? noteId, String? cardTemplateId}) {
    return LearningScreenState(
      noteId: noteId ?? this.noteId,
      cardTemplateId: cardTemplateId ?? this.cardTemplateId,
      deckId: deckId ?? this.deckId,
      side: side ?? this.side,
      status: status ?? this.status,
      cardInfo: cardInfo ?? this.cardInfo,
    );
  }

  const LearningScreenState.initial() : this(deckId: "", side: LearningCardSide.front, status: LearningScreenStatus.initial, cardInfo: null, noteId: "", cardTemplateId: "");
}
