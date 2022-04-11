import 'package:checkapp/providers/scan_qr_provider.dart';
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
        ChangeNotifierProvider(create: (_) => UI_provider()),
        ChangeNotifierProvider(create: (_) => ScanQrProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checkapp',
        initialRoute: 'home',
        theme: AppTheme.lightTheme,
        routes: {
          'home': (_) => const HomeScreen(),
          'login': ((context) => const LoginScreen())
        },
      ),
    );
  }
}
