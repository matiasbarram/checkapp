import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:checkapp/services/services.dart';
import 'package:checkapp/models/models.dart';
import 'package:checkapp/helpers/user_location.dart';
import 'dart:convert';

Future<void> scanQr(BuildContext context) async {
  String scannedAns = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);
  print('Respuesta del qr:  $scannedAns');

  //Scaned QR is valid
  if (scannedAns != (-1).toString()) {
    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);
    final todayEventsList = await attendanceService.getTodayAttendance();

    if (todayEventsList[0]['pending'] == false &&
        todayEventsList[1]['pending'] == false) {
      errorDialog(context,
          'Ya has marcado tu entrada y tu salida, si ocurrió un problema por favor contacta a tu encargado');
    } else {
      final userLocation = await getUserLocation();
      for (var event in todayEventsList) {
        ScanModel qrModel = createScanModel(scannedAns);
        if (event['pending'] == true && event['event_type'] == 'CHECK_IN') {
          //CHECK_IN -> First post of the day
          Navigator.of(context).pushNamed("confirm", arguments: {
            'answer': qrModel,
            'textInfo': 'entrada',
            'todo': 'CHECK_IN',
            'userLocation': userLocation,
          });
          break;
        }
        //CHECK_OUT -> lastEvent was a CHECK_IN
        else if (event['pending'] == true &&
            event['event_type'] == 'CHECK_OUT') {
          Navigator.of(context).pushNamed("confirm", arguments: {
            'answer': qrModel,
            'textInfo': 'salida',
            'todo': 'CHECK_OUT',
            'userLocation': userLocation,
          });
          break;
        }
      }
    }
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
