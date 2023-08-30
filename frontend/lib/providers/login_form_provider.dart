import 'package:flutter/material.dart';
import '../helpers/variables.dart' as variables;

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = variables.envDebug ? variables.testData["email"] : '';
  String password = variables.envDebug ? variables.testData["pass"] : '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool i) {
    _isLoading = i;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
