import 'package:equatable/equatable.dart';

class CardBrowserEvent extends Equatable {
  const CardBrowserEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends CardBrowserEvent {
  final String deckId;

  const InitialEvent(this.deckId);

  @override
  List<Object> get props => [deckId];
}

class ReviewEvent extends CardBrowserEvent {}

class TestEvent extends CardBrowserEvent {}

class AddCardEvent extends CardBrowserEvent {}

class SearchEvent extends CardBrowserEvent {
  final String keyword;

  const SearchEvent(this.keyword);

  @override
  List<Object> get props => [keyword.toLowerCase()];
}
