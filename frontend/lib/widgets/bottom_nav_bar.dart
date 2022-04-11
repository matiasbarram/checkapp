import 'package:checkapp/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ui_provider = Provider.of<UI_provider>(context);

    var currentIndex = ui_provider.selectMenuOpt;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
        onTap: (value) {
          ui_provider.selectMenuOpt = value;
        },
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }
}
