import 'package:flashcards/areyousure.dart';
import 'package:flashcards/flashcard.dart';
import 'package:flashcards/storage.dart';
import 'package:flutter/material.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key, required this.set});

  final String set;

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final cards = <String, String>{};
  final pageController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 0.9,
  );

  Future<void> addCard() async {
    final frontController = TextEditingController();
    final backController = TextEditingController();

    final dialog = AlertDialog(
      title: const Text('Add card'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: frontController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Front'),
              hintText: 'Question?',
            ),
            maxLines: 3,
          ),
          TextField(
            controller: backController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Back'),
              hintText: 'Answer!',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            setState(() {
              cards[frontController.text] = backController.text;
            });
          },
          child: const Text('Add'),
        ),
      ],
    );

    await showDialog(
      context: context,
      builder: (context) => dialog,
    );

    await saveCards(widget.set, cards);
  }

  Future<void> editCard(String front, String back) async {
    final frontController = TextEditingController(text: front);
    final backController = TextEditingController(text: back);

    final dialog = AlertDialog(
      title: const Text('Edit card'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: frontController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Front'),
              hintText: 'Question?',
            ),
            maxLines: 3,
          ),
          TextField(
            controller: backController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Back'),
              hintText: 'Answer!',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final confirmed = await areYouSure(context, 'Delete this card?');

            if (confirmed) {
              Navigator.pop(context);

              setState(() {
                cards.remove(front);
              });
            }
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            setState(() {
              cards.remove(front);
              cards[frontController.text] = backController.text;
            });
          },
          child: const Text('Save'),
        ),
      ],
    );

    await showDialog(
      context: context,
      builder: (context) => dialog,
    );

    await saveCards(widget.set, cards);
  }

  Future<void> loadSavedCards() async {
    final entries = await loadCards(widget.set);
    setState(() {
      cards.clear();
      cards.addAll(entries);
    });
  }

  @override
  void initState() {
    loadSavedCards();
    super.initState();
  }

  List<Widget> cardsToWidgets() {
    return cards.entries.map((e) {
      return FlashCard(
          front: e.key,
          back: e.value,
          onEdit: () async {
            await editCard(e.key, e.value);
          });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cardsPageView = PageView(
      scrollDirection: Axis.vertical,
      controller: pageController,
      children: cardsToWidgets(),
    );

    const noCards = Center(
      child: Text('No cards yet!'),
    );

    final realView = (cards.isEmpty) ? noCards : cardsPageView;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.set),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              final currentCards = cards.entries.toList();
              currentCards.shuffle();
              final newCards = Map.fromEntries(currentCards);

              setState(() {
                pageController.animateToPage(0,
                    duration: const Duration(seconds: 2),
                    curve: Curves.decelerate);
                cards.clear();
                cards.addAll(newCards);
              });
            },
          ),
        ],
      ),
      body: realView,
      floatingActionButton: FloatingActionButton(
        onPressed: addCard,
        tooltip: 'Add card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
