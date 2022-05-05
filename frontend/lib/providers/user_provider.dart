// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  String name = 'User';

  Future<void> loadUserInfo(context) async {
    final String? userInfokey = await storage.read(key: 'userInfo');
    if (userInfokey != null) {
      //final attendanceService =Provider.of<AttendanceService>(context, listen: false);
      print('La info de la key es $userInfokey');
      Map<String, dynamic> userInfo = json.decode(userInfokey);
      name = userInfo['name'];
      //String profilePictureUrl = await attendanceService.getProfileById();
      notifyListeners();
    }
  }
}
