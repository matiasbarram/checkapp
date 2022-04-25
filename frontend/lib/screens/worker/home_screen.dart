import 'package:checkapp/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:checkapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../worker/screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final uiProvider = Provider.of<UIprovider>(context);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const ScanQRCentered(),
      appBar: AppBar(
        title: Text('Hola ${uiProvider.name}!'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                authService.checkKeys();
                Navigator.pushReplacementNamed(context, 'login');
                authService.logout();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIprovider>(context);

    final currentIndex = uiProvider.selectMenuOpt;
    switch (currentIndex) {
      case 0:
        return const ResumenScreen();
      case 1:
        return const HistorialScreen();
      default:
        return const ResumenScreen();
    }
  }
}
