import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/screens/admin/employees_screen.dart';
import 'package:checkapp/screens/admin/resumen_admin_screen.dart';
import 'package:checkapp/screens/admin/screens.dart';
import 'package:checkapp/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../widgets/widgets.dart';
import '../worker/screens.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
        appBar: mainAppBar(context, userProvider, authService),
        bottomNavigationBar: const BottomNavBarAdmin(),
        body: const _HomePageBody());
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
        return const ResumenAdminScreen();
      case 1:
        return const ExtraScreen();
      case 2:
        return const EmployeesScreen();
      default:
        return const ResumenAdminScreen();
    }
  }
}
