import 'package:flashcards/areyousure.dart';
import 'package:flashcards/cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetsScreen extends StatefulWidget {
  const SetsScreen({Key? key}) : super(key: key);

  @override
  State<SetsScreen> createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  final keys = <String>[];

  Future<void> getExistingSets() async {
    final prefs = await SharedPreferences.getInstance();
    final newKeys = prefs.getKeys().toList();

    if (newKeys.length != keys.length) {
      setState(() {
        keys.clear();
        keys.addAll(newKeys);
      });
    }
  }

  Future<void> newSet() async {
    final keyController = TextEditingController();

    final dialog = AlertDialog(
      title: const Text('Add set'),
      content: TextField(
        controller: keyController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text('Set name'),
          hintText: 'My new set',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);

            await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CardsScreen(set: keyController.text);
              },
            ));

            getExistingSets();
          },
          child: const Text('Add'),
        ),
      ],
    );

    await showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    getExistingSets();
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickCards'),
      ),
      body: ListView.separated(
        itemCount: keys.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final key = keys[index];
          return InkWell(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CardsScreen(set: key);
                },
              ));
              getExistingSets();
            },
            onLongPress: () async {
              final confirmed = await areYouSure(context, 'Delete this set?');

              if (confirmed) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove(key);
                setState(() {
                  keys.remove(key);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                key,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New set',
        onPressed: newSet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
