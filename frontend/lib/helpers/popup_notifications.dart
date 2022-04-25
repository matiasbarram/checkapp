import 'package:flutter/material.dart';

class PopupNotification {
  static errorDialog(BuildContext context, String errorMsg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Ha ocurrido un error',
            ),
            content: Text(errorMsg),
            actions: [
              ElevatedButton(
                child: const Text("Salir"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}
