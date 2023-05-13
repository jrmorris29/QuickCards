import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCards(String setName, Map<String, String> entries) async {
  final prefs = await SharedPreferences.getInstance();
  final entriesList =
      entries.entries.map((e) => '${e.key}:${e.value}').toList();
  print(entriesList);
  await prefs.setStringList(setName, entriesList);
}

Future<Map<String, String>> loadCards(String setName) async {
  final prefs = await SharedPreferences.getInstance();
  final entriesList = prefs.getStringList(setName) ?? [];
  print(entriesList);
  final entriesMap = entriesList.map((e) {
    final parts = e.split(':');
    return MapEntry(parts[0], parts[1]);
  });

  return Map.fromEntries(entriesMap);
}
