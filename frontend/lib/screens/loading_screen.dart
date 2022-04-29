// ignore_for_file: avoid_print
import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/screens/admin/home_screen_admin.dart';
import 'package:checkapp/screens/worker/home_screen.dart';
import 'package:checkapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator.adaptive();
            }
            if (snapshot.data == 'no-key') {
              print('No tengo key');
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                    ));
              });
            } else {
              Future.microtask(() async {
                final attanceProvider =
                    Provider.of<AttendanceService>(context, listen: false);
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                userProvider.loadUserInfo();

                String userRol = await authService.logedUserRol();
                if (userRol == 'based') {
                  Navigator.pushReplacement(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) {
                    return const HomeScreenAdmin();
                  }));
                } else {
                  await attanceProvider.updateCurrentStatus();
                  Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (_, __, ___) {
                      return const HomeScreen();
                    },
                  ));
                }
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
