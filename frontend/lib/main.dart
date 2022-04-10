import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      initialRoute: 'home',
      theme: AppTheme.lightTheme,
      routes: {
        'home': (_) => const HomeScreen(),
      },
    );
  }
}
