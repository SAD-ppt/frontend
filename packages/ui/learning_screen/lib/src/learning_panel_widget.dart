import 'package:flutter/material.dart';

class CardInfo {
  final List<String> fields;

  const CardInfo({required this.fields});
  const CardInfo.empty() : fields = const [];
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
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: cardInfo.fields.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
