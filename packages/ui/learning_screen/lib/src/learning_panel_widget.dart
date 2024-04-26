import 'package:flutter/material.dart';

class CardInfo {
  final List<String> frontFields;
  final List<String> backFields;
  final bool side;

  const CardInfo(
      {required this.frontFields,
      required this.backFields,
      required this.side});
  const CardInfo.empty()
      : frontFields = const [],
        backFields = const [],
        side = true;

  CardInfo copyWith({
    List<String>? frontFields,
    List<String>? backFields,
    bool? side,
  }) {
    return CardInfo(
      frontFields: frontFields ?? this.frontFields,
      backFields: backFields ?? this.backFields,
      side: side ?? this.side,
    );
  }
}

class LearningPanelWidget extends StatelessWidget {
  final CardInfo cardInfo;
  const LearningPanelWidget({super.key, required this.cardInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Card(
          elevation: 4,
          child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                if (cardInfo.side == true) ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text:
                        // If the card is on the front side, display the front fields
                        TextSpan(
                      text: cardInfo.frontFields.join('\n'),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ] else ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text:
                        // If the card is on the front side, display the front fields
                        TextSpan(
                      text: cardInfo.backFields.join('\n'),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
