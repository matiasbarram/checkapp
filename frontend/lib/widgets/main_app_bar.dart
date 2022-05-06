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
            child: FadeInImage(
              placeholder: NetworkImage(
                  'https://www.api.asiendosoftware.xyz/api/v1/im2.png'),
              image: NetworkImage(
                'https://www.api.asiendosoftware.xyz/api/v1/image/2',
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      )
    ],
  );
}
