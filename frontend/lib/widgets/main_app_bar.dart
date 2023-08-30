import 'package:checkapp/services/auth_service.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import '../providers/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/variables.dart' as variables;

PreferredSizeWidget mainAppBar(
    BuildContext context, UserProvider userProvider, AuthService authService) {
  final String _apiURL = variables.apiURL;

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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: FutureBuilder(
              future: userProvider.getUserId(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return const CircleAvatar(
                  backgroundColor: AppTheme.checkAppOrange,
                );
                // if (snapshot.hasData) {
                //   return CircleAvatar(
                //       backgroundImage: CachedNetworkImageProvider(
                //     _apiURL + '/open/users/image/${snapshot.data}',
                //   ));
                // } else {
                //   return const CircularProgressIndicator(
                //     color: AppTheme.checkAppOrange,
                //   );
                // }
              },
            ),
          ),
        ),
      )
    ],
  );
}
