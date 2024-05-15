import 'package:equatable/equatable.dart';
import 'package:repos/repos.dart';

enum TestingSetupStatus {
  initial,
  loading,
  loaded,
  error,
}

class TestingSetupState extends Equatable {
  
  final TestingSetupStatus status;
  final String deckID;
  
  // final List<CardOverview> filteredCards;
  final List<String> selectedTags;
  final List<String> selectedCardType;

  final List<CardOverview> cardList;
  final List<String> availableTags;
  final List<String> availableCardTypes;

  final int totalFilteredCard;

  const TestingSetupState({
    this.status = TestingSetupStatus.initial,
    this.deckID = '',
    this.cardList = const [],
    this.availableTags = const [],
    this.selectedTags = const [],
    this.availableCardTypes = const [],
    this.selectedCardType = const [],
    // this.filteredCards = const [],
    this.totalFilteredCard = 0,
  });

  @override
  List<Object> get props => [
        status,
        deckID,
        cardList,
        availableTags,
        selectedTags,
        availableCardTypes,
        selectedCardType,
        // filteredCards,
        totalFilteredCard,
      ];
  
  TestingSetupState copyWith({
    TestingSetupStatus? status,
    String? deckID,
    
    // List<CardOverview>? filteredCards,
    List<String>? selectedTags,
    List<String>? selectedCardType,

    List<CardOverview>? cardList,
    List<String>? availableTags,
    List<String>? availableCardTypes,

    int? totalFilteredCard,
  }) {
    return TestingSetupState(
      status: status ?? this.status,
      deckID: deckID ?? this.deckID,
      cardList: cardList ?? this.cardList,
      availableTags: availableTags ?? this.availableTags,
      selectedTags: selectedTags ?? this.selectedTags,
      availableCardTypes: availableCardTypes ?? this.availableCardTypes,
      selectedCardType: selectedCardType ?? this.selectedCardType,
      // filteredCards: cardList ?? this.filteredCards,
      totalFilteredCard: totalFilteredCard ?? this.totalFilteredCard,
    );
  }
}