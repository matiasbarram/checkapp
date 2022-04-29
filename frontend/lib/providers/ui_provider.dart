import 'package:flutter/material.dart';

class UIprovider extends ChangeNotifier {
  int selectedMenuOpt = 0;

  PageController pageControler = PageController();

  selectMenuOptions(int i) {
    selectedMenuOpt = i;
    pageControler.animateToPage(i,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyListeners();
  }
}
