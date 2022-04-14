// ignore_for_file: avoid_print

import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/services/auth_service.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:checkapp/themes/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.checkApptextLigher,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WelcomeInfo(),
            const SizedBox(
              height: 40,
            ),
            ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: const _TextFieldsLogin()),
          ],
        ),
      ),
    );
  }
}

class WelcomeInfo extends StatelessWidget {
  const WelcomeInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/no-logo-orange.png'),
        const SizedBox(
          height: 40,
        ),
        const Text('¡Bienvenido!'),
        const SizedBox(
          height: 10,
        ),
        const Text('Por favor ingresa tus datos para ingresar'),
      ],
    );
  }
}

class _TextFieldsLogin extends StatelessWidget {
  const _TextFieldsLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tu correo'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecorations.authInputDecoration(
                    label: 'Ingresa tu correo'),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El formato de correo no es valido.';
                }),
            const SizedBox(
              height: 30,
            ),
            const Text('Tu contraseña'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  label: 'Ingresa tu contraseña'),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                if (value != null && value.length > 3) {
                  return null;
                } else {
                  return 'Debe ingresar una contraseña.';
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: AppTheme.checkAppBlue,
              elevation: 0,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      loginForm.isLoading = true;
                      final status = loginForm.isValidForm();
                      if (status) {
                        print("Valido pana mio");

                        final answ = await authService.loginUser(
                            loginForm.email, loginForm.password);
                        if (answ.containsKey('error')) {
                          print('hay error -> $answ');
                          loginForm.isLoading = false;
                        } else {
                          print('no hay error');
                          Navigator.pushReplacementNamed(context, 'home');
                        }
                      } else {
                        loginForm.isLoading = false;
                        print('No es valido pero tamo jugando');
                        loginForm.email = '';
                        loginForm.password = '';
                      }
                    },
              child: Text(loginForm.isLoading ? 'Cargando...' : 'Ingresar'),
            )
          ],
        ),
      ),
    );
  }
}
