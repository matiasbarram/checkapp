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
    ScanModel qrModel = createScanModel(scannedAns);

    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);
    final lastEvent = await attendanceService.getLastAttendance();

    //CHECK_IN -> First post of the day
    if (lastEvent['message'] == "sql: no rows in result set") {
      await confirmDialog(context, 'entrada', attendanceService, qrModel,
          userLocation, 'CHECK_IN');
    }
    //Post a Check-out
    else if (lastEvent['event_type'] == 'CHECK_IN') {
      await confirmDialog(context, 'salida', attendanceService, qrModel,
          userLocation, 'CHECK_OUT');
    }
    //Se hicieron los 2.
    else if (lastEvent['event_type'] == 'CHECK_OUT') {
      //ERROR PORQUE SE HICIERON LOS 2 CHECKS.
      errorDialog(context, 'Se hizo el checkout del día');
    }
  }
}

Future<void> postAttendance(BuildContext context, ScanModel qrModel,
    String userLocation, String check) async {
  final attendanceService =
      Provider.of<AttendanceService>(context, listen: false);
  await attendanceService.postNewAttendance(qrModel.id, check, userLocation);
  //Actualizar cambios
  //await attendanceService.updateCurrentStatus(); MORIRR
}

confirmDialog(
    BuildContext context,
    String checkText,
    AttendanceService attendanceService,
    ScanModel qrModel,
    String userLocation,
    String check) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmación',
          ),
          content: Text('¿Estás seguro que deseas registrar tu $checkText ?'),
          actions: [
            ElevatedButton(
              child: const Text("Si"),
              onPressed: () async {
                await postAttendance(context, qrModel, userLocation, check);
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      });
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
