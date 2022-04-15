import 'package:checkapp/services/auth_service.dart';
import 'package:checkapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'package:checkapp/themes/app_theme.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UIprovider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AttendanceService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checkapp',
        initialRoute: 'loading',
        theme: AppTheme.lightTheme,
        routes: {
          'home': (_) => const HomeScreen(),
          'login': ((context) => const LoginScreen()),
          'loading': ((context) => const LoadingScreen()),
        },
      ),
    );
  }
}
