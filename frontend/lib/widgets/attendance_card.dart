import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../themes/app_theme.dart';

class AttendanceCard extends StatelessWidget {
  final String? title;

  const AttendanceCard({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  if (title == 'Entrada')
                    Consumer<AttendanceService>(
                        builder: (_, attendance, ___) => Text(
                              attendance.entradaEsperada,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppTheme.textPending),
                            )),
                  if (title == 'Salida')
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
              if (title == 'Entrada')
                Consumer<AttendanceService>(
                    builder: (_, attendance, ___) => Text(
                          attendance.entrada,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: attendance.checkInColor),
                        ))
              else if (title == 'Salida')
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
    );
  }
}
