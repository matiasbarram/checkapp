import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:checkapp/screens/admin/employee_info_screen.dart';
import 'package:checkapp/screens/admin/home_screen_admin.dart';
import 'package:checkapp/services/notification_service.dart';
import 'package:checkapp/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:checkapp/screens/worker/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize('resource://drawable/ic_no_logo_orange', [
    NotificationChannel(
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelKey: 'basic_channel',
        channelName: 'Basic notification',
        channelDescription: 'Channel description'),
  ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      //@TODO HACER MODAL DE PERMITIR NOTIFICACIONES
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      final String title = message.notification?.title ?? '';
      final String body = message.notification?.body ?? '';
      NotificationService.createNotifications(title, body);
    }
  });

  runApp(const AppState());
}

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
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checkapp',
        initialRoute: 'loading',
        theme: AppTheme.lightTheme,
        routes: {
          'home': (_) => const HomeScreen(),
          'homeadmin': (_) => const HomeScreenAdmin(),
          'login': ((context) => const LoginScreen()),
          'loading': ((context) => const LoadingScreen()),
          'confirm': ((context) => const ConfirmAttendanceScreen()),
          'employee_info': ((context) => const EmployeeInfoScreen()),
        },
      ),
    );
  }
}
