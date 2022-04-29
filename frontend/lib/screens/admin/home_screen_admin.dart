import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/screens/admin/employees_screen.dart';
import 'package:checkapp/screens/admin/resumen_admin_screen.dart';
import 'package:checkapp/screens/admin/screens.dart';
import 'package:checkapp/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../widgets/widgets.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uiProvider = Provider.of<UIprovider>(context);

    return Scaffold(
        appBar: mainAppBar(context, userProvider, authService),
        bottomNavigationBar: const BottomNavBarAdmin(),
        body: PageView(controller: uiProvider.pageControler, children: const [
          ResumenAdminScreen(),
          ExtraScreen(),
          EmployeesScreen()
        ]));
  }
}
