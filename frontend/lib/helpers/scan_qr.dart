import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:checkapp/services/services.dart';
import 'package:checkapp/models/models.dart';
import 'package:checkapp/helpers/user_location.dart';
import 'dart:convert';

scanQr(BuildContext context) async {
  String scannedAns = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);
  print('Respuesta del qr:  $scannedAns');
  var attendanceCompleted = true;

  //Scaned QR is valid
  if (scannedAns != (-1).toString()) {
    final userLocation = await getUserLocation();

    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);
    //final lastEvent = await attendanceService.getLastAttendance();
    final todayEventsList = await attendanceService.getTodayAttendance();
    final eventLen = todayEventsList.length;
    var index = 0;
    while ((index < eventLen) && attendanceCompleted) {
      final event = todayEventsList[index];
      //for (var event in todayEventsList) {
      ScanModel qrModel = createScanModel(scannedAns);
      if (event['pending'] == true && event['event_type'] == 'CHECK_IN') {
        attendanceCompleted = false;
        //CHECK_IN -> First post of the day
        Navigator.of(context).pushNamed("confirm", arguments: {
          'answer': qrModel,
          'textInfo': 'entrada',
          'todo': 'CHECK_IN',
          'userLocation': userLocation,
        });
      }
      //CHECK_OUT -> lastEvent was a CHECK_IN
      else if (event['pending'] == true && event['event_type'] == 'CHECK_OUT') {
        attendanceCompleted = false;
        Navigator.of(context).pushNamed("confirm", arguments: {
          'answer': qrModel,
          'textInfo': 'salida',
          'todo': 'CHECK_OUT',
          'userLocation': userLocation,
        });
      }
    }
    index += 1;
  }
  //ERROR PORQUE SE HICIERON LOS 2 CHECKS.
  if (attendanceCompleted == true) {
    errorDialog(context,
        'Ya has marcado tu entrada y tu salida, si ocurrió un problema por favor contacta a tu encargado');
  }
}

errorDialog(BuildContext context, String errorMsg) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Ha ocurrido un error',
          ),
          content: Text(errorMsg),
          actions: [
            ElevatedButton(
              child: const Text("Salir"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}

ScanModel createScanModel(String qrScanRes) {
  Map<String, dynamic> mapQr = jsonDecode(qrScanRes);
  final qrInfo = ScanModel(
      id: mapQr['id'], name: mapQr['name'], location: mapQr['location']);
  return qrInfo;
}
