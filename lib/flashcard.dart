import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({
    Key? key,
    required this.front,
    required this.back,
    required this.onEdit,
  }) : super(key: key);

  final void Function() onEdit;

  final String front;
  final String back;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  var facingFront = true;

  Widget cardWithText(String text, Color? color) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(32),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onLongPress: widget.onEdit,
      child: FlipCard(
        front: cardWithText(widget.front, null),
        back: cardWithText(widget.back, Colors.blueGrey.shade50),
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: true,
      ),
    );
  }
}
