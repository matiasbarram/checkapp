import 'package:flutter/material.dart';

class UIprovider extends ChangeNotifier {
  int selectedMenuOpt = 0;

  selectMenuOptions(int i) {
    selectedMenuOpt = i;
    notifyListeners();
  }
}
