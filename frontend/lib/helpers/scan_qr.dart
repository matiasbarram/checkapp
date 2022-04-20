import 'dart:convert';

import 'package:checkapp/models/models.dart';
import 'package:checkapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:checkapp/helpers/user_location.dart';

scanQr(BuildContext context) async {
  String PENDING = 'PENDIENTE';
  String qrScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);
  print('Respuesta del qr:  $qrScanRes');

  //Scan a valid QR
  if (qrScanRes != (-1).toString()) {
    ScanModel qrInfo = createScanModel(qrScanRes);

    final attendanceProvider =
        Provider.of<AttendanceService>(context, listen: false);
    final lastEvent = await attendanceProvider.getLastAttendance();

    //TODO: ERRORS

    //Post a Check-out
    if (lastEvent['event_type'] == 'CHECK_IN') {
      //bool confirm = await confirmDialog(context, qrScanRes, 'salida');
      //print('Seleccionó $confirm');
      if (true) {
        final userLocation = await getUserLocation();
        attendanceProvider.postNewAttendance(
            qrInfo.id, 'CHECK_OUT', userLocation);
      }
    }

    //Post a Check-in
    else if (lastEvent['event_type'] == 'CHECK_OUT') {
      //bool confirm = await confirmDialog(context, qrScanRes, 'entrada');
      //print('Seleccionó $confirm');
      if (true) {
        final userLocation = await getUserLocation();
        attendanceProvider.postNewAttendance(
            qrInfo.id, 'CHECK_IN', userLocation);
      }
    }

    //Actualizar cambios
    attendanceProvider.updateCurrentStatus();
  }
}

confirmDialog(BuildContext context, String barcodeScanRes, String llegaStrr) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmación',
          ),
          content: Text('¿Estás seguro que deseas registrar tu $llegaStrr ?'),
          actions: [
            ElevatedButton(
              child: const Text("Si"),
              onPressed: () {
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
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '¡Error!',
          ),
          content: Text(errorMsg),
          actions: [
            ElevatedButton(
              child: const Text("Salir"),
              onPressed: () => Navigator.of(context).pop(true),
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
