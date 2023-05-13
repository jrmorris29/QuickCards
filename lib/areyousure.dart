import 'package:flutter/material.dart';

Future<bool> areYouSure(BuildContext context, String message) async {
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      ) ??
      false;
}
