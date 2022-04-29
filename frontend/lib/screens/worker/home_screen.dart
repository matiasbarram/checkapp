import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/services/attendance_service.dart';
import 'package:checkapp/themes/app_theme.dart';
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
    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);
    final uiProvider = Provider.of<UIprovider>(context);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const ScanQRCentered(),
      appBar: mainAppBar(context, userProvider, authService),
      body: RefreshIndicator(
          color: AppTheme.checkAppOrange,
          onRefresh: () => attendanceService.getTodayAttendance(),
          child: PageView(
              controller: uiProvider.pageControler,
              children: const [ResumenScreen(), HistorialScreen()])),
    );
  }
}
