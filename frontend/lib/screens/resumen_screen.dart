import 'package:checkapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../themes/app_theme.dart';
import '../widgets/widgets.dart';

class ResumenScreen extends StatelessWidget {
  const ResumenScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final attendence = Provider.of<AttendanceService>(context);
    return Column(
      children: [
        ClipPath(
          clipper: ClippingClass(),
          child: Container(
            height: 320,
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
                                children: [
                                  const Text('Llegada'),
                                  Consumer<AttendanceService>(
                                      builder: (_, attendance, ___) =>
                                          Text(attendance.entrada))
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
                                children: [
                                  const Text('Salida'),
                                  Consumer<AttendanceService>(
                                      builder: (_, attendance, ___) =>
                                          Text(attendance.salida))
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
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Column(
            children: const [Text('Así va tu asistencia de este mes')],
          ),
        )
      ],
    );
  }
}
