// ignore_for_file: avoid_print

import 'package:checkapp/screens/home_screen.dart';
import 'package:checkapp/screens/login_screen.dart';
import 'package:checkapp/services/auth_service.dart';
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
            print('Valor de la snapshot: ' + snapshot.data);
            authService.checkKeys();
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
              Future.microtask(() {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) {
                    final attanceProvider =
                        Provider.of<AttendanceService>(context, listen: false);
                    attanceProvider.updateCurrentStatus();
                    return const HomeScreen();
                  },
                ));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
