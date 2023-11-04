import 'package:flutter/material.dart';

showDeleteDialog(BuildContext context, Function()? onDelete) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Are you sure?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: const Row(
          children: [
            Text(
              "Do you really want to delete selected\nitems?",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
            ),
          ),
          TextButton(
            onPressed: () {
              onDelete!();
              Navigator.of(context).pop();
            },
            child: const Text(
              "DELETE",
            ),
          ),
        ],
      );
    },
  );
}
