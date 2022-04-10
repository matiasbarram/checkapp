import 'package:flutter/material.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:checkapp/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hola John Cena'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            color: AppTheme.checkappPrim,
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  const ScanQRButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: Offset(3, 4))
                            ],
                          ),
                          width: double.infinity,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Text('Llegada'),
                                  Text('08:05 am')
                                ],
                              ),
                              const VerticalDivider(
                                width: 1,
                                thickness: 0.5,
                                color: AppTheme.checkApptextLight,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Text('Llegada'),
                                  Text('08:05 am')
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          '¿Tienes algún problema?',
                          style: TextStyle(color: AppTheme.checkApptextLight),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
