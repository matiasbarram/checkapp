import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:checkapp/services/services.dart';
import 'package:checkapp/models/models.dart';
import 'package:checkapp/helpers/user_location.dart';
import 'dart:convert';

import '../providers/providers.dart';

scanQr(BuildContext context) async {
  String scannedAns = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);
  print('Respuesta del qr:  $scannedAns');

  //Scaned QR is valid
  if (scannedAns != (-1).toString()) {
    final userLocation = await getUserLocation();

    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);
    final lastEvent = await attendanceService.getLastAttendance();

    if (lastEvent['event_type'] == 'CHECK_OUT') {
      //ERROR PORQUE SE HICIERON LOS 2 CHECKS.
      errorDialog(context,
          'Ya has marcado tu entrada y tu salida, si ocurrió un problema por favor contacta a tu encargado');
    } else {
      ScanModel qrModel = createScanModel(scannedAns);
      //CHECK_IN -> First post of the day
      if (lastEvent['message'] == "sql: no rows in result set") {
        Navigator.of(context).pushNamed("confirm", arguments: {
          'answer': qrModel,
          'textInfo': 'entrada',
          'todo': 'CHECK_IN',
          'userLocation': userLocation,
        });
      }
      //CHECK_OUT -> lastEvent was a CHECK_IN
      else if (lastEvent['event_type'] == 'CHECK_IN') {
        Navigator.of(context).pushNamed("confirm", arguments: {
          'answer': qrModel,
          'textInfo': 'salida',
          'todo': 'CHECK_OUT',
          'userLocation': userLocation,
        });
      }
    }
  }
}

errorDialog(BuildContext context, String errorMsg) {
  final alertProvider = Provider.of<AlertProvider>(context, listen: false);

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
                alertProvider.doAttendance = true;
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
