import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/widgets/main_app_bar.dart';
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const ScanQRCentered(),
      appBar: mainAppBar(context, userProvider, authService),
      body: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIprovider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;
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
