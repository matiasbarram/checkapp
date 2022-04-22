import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UIprovider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  int _selectedMenuOpt = 0;
  String name = 'User';

  int get selectMenuOpt {
    return _selectedMenuOpt;
  }

  set selectMenuOpt(int i) {
    _selectedMenuOpt = i;
    notifyListeners();
  }

  Future<void> loadUserInfo() async {
    final String? userName = await storage.read(key: 'userName');
    if (userName != null) {
      name = userName;
      notifyListeners();
    }
  }
}
