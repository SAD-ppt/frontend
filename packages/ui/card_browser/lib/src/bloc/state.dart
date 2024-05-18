import 'package:equatable/equatable.dart';
import 'package:repos/repos.dart';

enum CardBrowserStatus {
  initial,
  loading,
  loaded,
  error,
}

class CardBrowserState extends Equatable {
  final CardBrowserStatus status;
  final String? deckID;
  final List<Card> cardList;
  final List<Card> selectedCards;

  final int remainingCards;

  const CardBrowserState({
    this.status = CardBrowserStatus.initial,
    this.deckID,
    this.cardList = const [],
    this.selectedCards = const [],
    this.remainingCards = 0,
  });

  @override
  List<Object?> get props => [status, deckID, cardList];

  CardBrowserState copyWith({
    CardBrowserStatus? status,
    String? deckID,
    List<Card>? cardList,
    List<Card>? selectedCards,
    int? remainingCards,
  }) {
    return CardBrowserState(
      status: status ?? this.status,
      deckID: deckID ?? this.deckID,
      cardList: cardList ?? this.cardList,
      selectedCards: selectedCards ?? this.selectedCards,
      remainingCards: remainingCards ?? this.remainingCards,
    );
  }
}

