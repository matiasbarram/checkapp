import 'package:checkapp/helpers/helpers.dart';
import 'package:checkapp/helpers/scan_qr.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:checkapp/themes/custom_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/date_time_helper.dart';
import '../../models/models.dart';
import '../../services/services.dart';

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
        iconTheme: const IconThemeData(color: AppTheme.textPrimColor),
        title: const Text('Confirmar asistencia'),
      ),
      backgroundColor: AppTheme.checkApptextLigher,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ButtonsDecoration.confirmButtonStyle(),
              onPressed: () async {
                //TODO: BLOQUEAR BOTTÓN DESPÚES DEL PRIMER POST
                String msgAnswer =
                    await postAttendance(context, answer, userLocation, todo);
                if (msgAnswer != 'OK') {
                  PopupNotification.errorDialog(context, msgAnswer);
                }
                //Navigator.pop(context);
              },
              child: const Text('Si'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ButtonsDecoration.rejectButtonStyle(),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'No',
                  style: TextStyle(color: AppTheme.checkAppBlue),
                ))
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '¿Estás seguro de que deseas marcar tu $textInfo ?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Este es el resumen de tu registro',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<String>(
                future: getAttendanceInfo(context, todo),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  print(snapshot.data);
                  if (snapshot.hasData) {
                    final attendanceService =
                        Provider.of<AttendanceService>(context);
                    return Table(
                      border: TableBorder.all(
                          color: AppTheme.checkAppBlue, width: 1),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 10),
                            child: Text(
                              'Hora de $textInfo esperada: ',
                              style: const TextStyle(
                                  color: AppTheme.textPrimColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 10),
                            child: Text(
                              attendanceService.horaEsperada,
                              style: const TextStyle(
                                  color: AppTheme.textPrimColor,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 10),
                            child: Text(
                              'Hora de escaneo: ',
                              style: TextStyle(color: AppTheme.textPrimColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getCurrentTime(),
                              style: const TextStyle(
                                color: AppTheme.textPrimColor,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 20),
                            child: Text(
                              'Estado: ',
                              style: TextStyle(color: AppTheme.textPrimColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 10),
                            child: Text(
                              attendanceService.status,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: attendanceService.statusColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                      ],
                    );
                  } else {
                    return const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> postAttendance(BuildContext context, ScanModel qrModel,
    String userLocation, String check) async {
  final attendanceService =
      Provider.of<AttendanceService>(context, listen: false);
  String msgAnswer = await attendanceService.postNewAttendance(
      qrModel.id, check, userLocation);
  return msgAnswer;
}

Future<String> getAttendanceInfo(BuildContext context, String todo) async {
  final attendanceService =
      Provider.of<AttendanceService>(context, listen: false);
  final String response = await attendanceService.setFuturePostInfo(todo);
  print('Terminó de cambiar la info, retorando DONE...');
  return response;
}
