import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigo;
  static const Color secondary = Colors.pink;
  static const Color checkappPrim = Color.fromRGBO(235, 242, 250, 1);
  static const Color textPrimColor = Color.fromRGBO(66, 84, 102, 1);
  static const Color checkAppBlue = Color.fromRGBO(23, 74, 124, 1);
  static const Color checkApptextLight = Color.fromRGBO(172, 186, 200, 1);
  static const Color checkApptextLigher = Color.fromRGBO(235, 242, 250, 1);
  static const Color checkAppOrange = Color.fromRGBO(238, 166, 7, 1);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: checkAppOrange,
    appBarTheme: const AppBarTheme(
      color: checkappPrim,
      elevation: 0,
      toolbarHeight: 70,
      titleTextStyle: TextStyle(fontSize: 20, color: textPrimColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(color: checkAppOrange),
    ),
  );
}
