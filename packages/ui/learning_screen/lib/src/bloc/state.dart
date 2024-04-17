import 'package:equatable/equatable.dart';
import 'package:learning_screen/src/learning_panel_widget.dart';

enum LearningScreenStatus { initial, loading, success, error }

enum LearningCardSide { front, back }

class LearningScreenState extends Equatable {
  const LearningScreenState({required this.side, required this.status, required this.cardInfo});

  final LearningScreenStatus status;
  final LearningCardSide side;
  final CardInfo? cardInfo;

  @override
  List<Object?> get props => [side, status, cardInfo];

  LearningScreenState copyWith({LearningCardSide? side, LearningScreenStatus? status, CardInfo? cardInfo}) {
    return LearningScreenState(
      side: side ?? this.side,
      status: status ?? this.status,
      cardInfo: cardInfo ?? this.cardInfo,
    );
  }

  const LearningScreenState.initial() : this(side: LearningCardSide.front, status: LearningScreenStatus.initial, cardInfo: null);
}
