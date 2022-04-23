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

class ButtonsDecoration {
  static ButtonStyle confirmButtonStyle() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      primary: AppTheme.checkAppBlue,
      minimumSize: const Size.fromHeight(50),
    );
  }

  static ButtonStyle rejectButtonStyle() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(color: AppTheme.checkAppBlue)),
      primary: Colors.white,
      minimumSize: const Size.fromHeight(50),
    );
  }
}
