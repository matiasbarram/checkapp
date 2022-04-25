import 'package:checkapp/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../providers/providers.dart';

PreferredSizeWidget mainAppBar(
    BuildContext context, UserProvider userProvider, AuthService authService) {
  return AppBar(
    title: Text('Hola ${userProvider.name}!'),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            authService.checkKeys();
            Navigator.pushReplacementNamed(context, 'login');
            authService.logout();
          },
          child: const CircleAvatar(
            backgroundColor: Colors.white,
          ),
        ),
      )
    ],
  );
}
