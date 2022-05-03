import 'package:checkapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/widgets.dart';

class ResumenScreen extends StatelessWidget {
  const ResumenScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final attendence = Provider.of<AttendanceService>(context);
    return Column(
      children: [
        Container(
          height: 420,
          color: AppTheme.checkappPrim,
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                const ScanQRButton(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      if (attendence.freeDay)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                          height: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<AttendanceService>(
                                      builder: (_, attendance, ___) => Text(
                                            'DISFRUTA TU DIA LIBRE',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: attendance.checkInColor),
                                          ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (!attendence.freeDay)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Entrada',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppTheme.textPrimColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Esperado',
                                        style: TextStyle(
                                            color: AppTheme.textPending,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Consumer<AttendanceService>(
                                          builder: (_, attendance, ___) => Text(
                                                attendance.entradaEsperada,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color:
                                                        AppTheme.textPending),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<AttendanceService>(
                                      builder: (_, attendance, ___) => Text(
                                            attendance.entrada,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: attendance.checkInColor),
                                          ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 40,
                      ),
                      if (!attendence.freeDay)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Salida',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppTheme.textPrimColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Esperado ',
                                        style: TextStyle(
                                            color: AppTheme.textPending,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Consumer<AttendanceService>(
                                          builder: (_, attendance, ___) => Text(
                                                attendance.salidaEsperada,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color:
                                                        AppTheme.textPending),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<AttendanceService>(
                                      builder: (_, attendance, ___) => Text(
                                            attendance.salida,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    attendance.checkOutColor),
                                          ))
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Column(
            children: const [
              Text(
                'Así va tu asistencia de este mes',
                style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textPrimColor,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }
}
