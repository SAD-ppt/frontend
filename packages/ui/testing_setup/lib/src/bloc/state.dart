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
  
  final List<String> selectedTags;
  final List<String> selectedCardType;

  final List<CardOverview> cardList;
  final List<String> availableTags;
  final List<String> availableCardTypes;

  final int totalFilteredCard;

  final String deliverDeckId;

  final Map<String, String> dictionary;

  const TestingSetupState({
    this.status = TestingSetupStatus.initial,
    this.deckID = '',
    this.cardList = const [],
    this.availableTags = const [],
    this.selectedTags = const [],
    this.availableCardTypes = const [],
    this.selectedCardType = const [],
    this.totalFilteredCard = 0,
    this.deliverDeckId = '',
    this.dictionary = const {},
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
        totalFilteredCard,
        deliverDeckId,
        dictionary,
      ];
  
  TestingSetupState copyWith({
    TestingSetupStatus? status,
    String? deckID,
    
    List<String>? selectedTags,
    List<String>? selectedCardType,

    List<CardOverview>? cardList,
    List<String>? availableTags,
    List<String>? availableCardTypes,

    int? totalFilteredCard,

    String? deliverDeckId,
    Map<String, String>? dictionary,
  }) {
    return TestingSetupState(
      status: status ?? this.status,
      deckID: deckID ?? this.deckID,
      cardList: cardList ?? this.cardList,
      availableTags: availableTags ?? this.availableTags,
      selectedTags: selectedTags ?? this.selectedTags,
      availableCardTypes: availableCardTypes ?? this.availableCardTypes,
      selectedCardType: selectedCardType ?? this.selectedCardType,
      totalFilteredCard: totalFilteredCard ?? this.totalFilteredCard,
      deliverDeckId: deliverDeckId ?? this.deliverDeckId,
      dictionary: dictionary ?? this.dictionary,
    );
  }
}