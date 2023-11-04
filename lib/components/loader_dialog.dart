import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, String message) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  message,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
