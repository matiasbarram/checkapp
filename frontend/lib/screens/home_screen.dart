import 'package:checkapp/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:checkapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../helpers/helpers.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const ScanQRCentered(),
      appBar: AppBar(
        title: const Text('Hola John Cena'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
      body: _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UI_provider>(context);

    final currentIndex = uiProvider.selectMenuOpt;
    switch (currentIndex) {
      case 0:
        return ResumenScreen();
      case 1:
        return HistorialScreen();
      default:
        return ResumenScreen();
    }
  }
}
