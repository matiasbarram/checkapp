import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.checkApptextLigher,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            WelcomeInfo(),
            SizedBox(
              height: 40,
            ),
            TextFieldsLogin()
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

class TextFieldsLogin extends StatelessWidget {
  const TextFieldsLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tu correo'),
          const SizedBox(
            height: 10,
          ),
          const TextField(
            decoration: InputDecoration(
                labelText: "Ingresa tu correo",
                labelStyle: TextStyle(color: AppTheme.checkApptextLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.checkApptextLigher),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text('Tu contraseña'),
          const SizedBox(
            height: 10,
          ),
          const TextField(
            decoration: InputDecoration(
                labelText: "Ingresa tu correo",
                labelStyle: TextStyle(color: AppTheme.checkApptextLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.checkApptextLigher),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
            obscureText: true,
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: const Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(fontSize: 12, color: AppTheme.checkAppBlue),
            ),
          ),
        ],
      ),
    );
  }
}
