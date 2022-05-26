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
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              height: 270,
              color: AppTheme.checkappPrim,
              width: double.infinity,
            ),
            Column(
              children: [
                const ScanQRButton(),
                const SizedBox(height: 40),
                _AttendanceCards(attendence: attendence)
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _AttendanceCards extends StatelessWidget {
  const _AttendanceCards({
    Key? key,
    required this.attendence,
  }) : super(key: key);

  final AttendanceService attendence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          if (attendence.freeDay)
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
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
                            'Esperado ',
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
                                        color: AppTheme.textPending),
                                  )),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        color: AppTheme.textPending),
                                  )),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Consumer<AttendanceService>(
                          builder: (_, attendance, ___) => Text(
                                attendance.salida,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: attendance.checkOutColor),
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
    );
  }
}
