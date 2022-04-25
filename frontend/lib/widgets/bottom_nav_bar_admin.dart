import 'package:checkapp/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarAdmin extends StatelessWidget {
  const BottomNavBarAdmin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIprovider>(context);

    var currentIndex = uiProvider.selectedMenuOpt;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
          boxShadow: [
            BoxShadow(color: Color.fromARGB(46, 57, 56, 56), blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          child: BottomNavigationBar(
            onTap: (value) {
              uiProvider.selectMenuOptions(value);
            },
            currentIndex: currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Resumen'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.airline_seat_individual_suite_outlined),
                  label: 'Info'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Historial'),
            ],
          ),
        ),
      ),
    );
  }
}
