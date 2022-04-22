import 'dart:convert';

import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';

class ConfirmAttendanceScreen extends StatelessWidget {
  const ConfirmAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print('Se recibe $arguments');
    ScanModel answer = arguments['answer'];
    String textInfo = arguments['textInfo'];
    String todo = arguments['todo'];
    String userLocation = arguments['userLocation'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar asistencia'),
      ),
      backgroundColor: AppTheme.checkApptextLigher,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('¿Estás seguro de que deseas marcar tu $textInfo ?'),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Este es el resumen de tu registro'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: const <TableRow>[
                  TableRow(children: [
                    Text('Hora de llegada esperada: '),
                    Text(
                      'Hora esperada',
                      textAlign: TextAlign.center,
                    )
                  ]),
                  TableRow(children: [
                    Text('Hora de llegada actual: '),
                    Text(
                      'Hora actual',
                      textAlign: TextAlign.center,
                    )
                  ]),
                  TableRow(children: [
                    Text('Estado: '),
                    Text(
                      'TARDE',
                      textAlign: TextAlign.center,
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                await postAttendance(context, answer, userLocation, todo);
                Navigator.pop(context);
              },
              child: const Text('Si'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () => Navigator.pop(context),
                child: const Text('No'))
          ],
        ),
      ),
    );
  }
}

Future<void> postAttendance(BuildContext context, ScanModel qrModel,
    String userLocation, String check) async {
  final attendanceService =
      Provider.of<AttendanceService>(context, listen: false);
  await attendanceService.postNewAttendance(qrModel.id, check, userLocation);
}
