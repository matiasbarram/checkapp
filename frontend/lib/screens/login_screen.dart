// ignore_for_file: avoid_print
import 'package:checkapp/providers/providers.dart';
import 'package:checkapp/services/auth_service.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:checkapp/themes/custom_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.checkApptextLigher,
      body: Center(
        child: SingleChildScrollView(
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
        const Text(
          '¡Bienvenido!',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimColor),
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Por favor ingresa tus datos para ingresar.",
          style: TextStyle(fontSize: 18, color: AppTheme.textPending),
        ),
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
            const Text(
              'Tu correo',
              style: TextStyle(
                  color: AppTheme.textPrimColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                initialValue: loginForm.email,
                autocorrect: false,
                decoration: InputDecorations.authInputDecoration(
                    label: 'Ingresa tu correo'),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  RegExp regExp = RegExp(emailPattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El formato de correo no es valido.';
                }),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Tu contraseña',
              style: TextStyle(
                  color: AppTheme.textPrimColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              initialValue: loginForm.password,
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
              height: 40,
            ),
            _LoginButton(loginForm: loginForm)
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              if (!status) {
                loginForm.isLoading = false;
                print("Form not valid");
                loginForm.email = '';
                loginForm.password = '';
              }
              final response = await authService.loginUser(
                  loginForm.email, loginForm.password);
              if (response.containsKey('error') || response.isEmpty) {
                print('hay error -> $response');
                loginForm.isLoading = false;
                loginForm.password = "";
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Error al iniciar sesión. Por favor, verifica tus credenciales.'),
                  ),
                );
              } else {
                print("Valid API response");
                Navigator.pushReplacementNamed(context, 'loading');
              }
            },
      child: loginForm.isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const Text(
              'Ingresar',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
