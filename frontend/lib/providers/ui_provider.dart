import 'package:flutter/material.dart';

class UIprovider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  int get selectMenuOpt {
    return _selectedMenuOpt;
  }

  set selectMenuOpt(int i) {
    _selectedMenuOpt = i;
    notifyListeners();
  }
}
