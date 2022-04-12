import 'package:flutter/material.dart';

import 'app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({required String label}) {
    return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.checkApptextLight),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.checkApptextLigher),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ));
  }
}
