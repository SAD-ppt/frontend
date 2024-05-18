import 'package:card_browser/src/bloc/bloc.dart';
import 'package:card_browser/src/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:card_browser/src/component/body_card_browser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_browser/src/bloc/event.dart';
import 'package:repos/repos.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class CardBrowserScreen extends StatelessWidget {
  
  final String deckId;
  
  final void Function() onBack;
  final void Function(String deckId) onReviewDeck;
  final void Function(String deckId) onTestDeck;
  final void Function() onAddNewCard;
  
  const CardBrowserScreen({
    super.key, 
    required this.deckId,
    required this.onBack,
    required this.onReviewDeck,
    required this.onTestDeck,
    required this.onAddNewCard 
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardBrowserBloc(
          deckRepository: context.read<DeckRepo>(),
          cardRepository: context.read<CardRepo>())
        ..add(InitialEvent(deckId)),
      child: _CardBrowserScreenView(
        onBack: onBack,
        onAddNewCard: onAddNewCard,
        onReviewDeck: onReviewDeck,
        onTestDeck: onTestDeck,
      ),
    );
  }
}

class _CardBrowserScreenView extends StatelessWidget {

  final void Function() onBack;
  final void Function() onAddNewCard;
  final void Function(String deckId) onReviewDeck;
  final void Function(String deckId) onTestDeck;

  const _CardBrowserScreenView({
    required this.onBack,
    required this.onAddNewCard,
    required this.onReviewDeck,
    required this.onTestDeck
  });
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBrowserBloc, CardBrowserState>(
      builder: (context, state) {
        return Scaffold(
          // Tools bar
          appBar: AppBar(
            title: SizedBox(
              height: 45,
              child: SearchBar(
                hintText: 'Search for cards',
                // no shadow
                elevation: const WidgetStatePropertyAll<double>(0),
                onChanged: (value) =>
                    context.read<CardBrowserBloc>().add(SearchEvent(value)),
              ),
            ),
            leading: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: BodyCardBrowser(
            content: state.cardList,
            total: state.selectedCards.length,
            memorized: state.selectedCards.length - state.remainingCards,
            onReview: () => {
              if (state.deckID != null) onReviewDeck(state.deckID!)
              else logger.d('Deck ID is null')
            },
            onTest: () => {
              if (state.deckID != null) onTestDeck(state.deckID!)
              else logger.d('Deck ID is null')
            },
            onAddCard: onAddNewCard,
          ),
        );
      },
    );
  }
}