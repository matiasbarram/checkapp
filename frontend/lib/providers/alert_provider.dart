import 'package:flutter/cupertino.dart';

class AlertProvider extends ChangeNotifier {
  bool _doAttendance = false;

  bool get doAttendance => _doAttendance;

  set doAttendance(bool i) {
    print('se cambió el valor a -> $i');
    _doAttendance = i;
    notifyListeners();
  }
}
