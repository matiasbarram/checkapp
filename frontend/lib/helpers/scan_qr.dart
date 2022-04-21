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

  //Scaned QR is valid
  if (scannedAns != (-1).toString()) {
    final userLocation = await getUserLocation();
    ScanModel qrModel = createScanModel(scannedAns);

    final attendanceProvider =
        Provider.of<AttendanceService>(context, listen: false);
    final lastEvent = await attendanceProvider.getLastAttendance();

    //CHECK_IN -> First post of the day
    if (lastEvent['message'] == "sql: no rows in result set") {
      //bool confirm = await confirmDialog(context, qrScanRes, 'salida');
      attendanceProvider.postNewAttendance(
          qrModel.id, 'CHECK_IN', userLocation);
      //Actualizar cambios
      await attendanceProvider.updateCurrentStatus();
    }
    //Post a Check-out
    else if (lastEvent['event_type'] == 'CHECK_IN') {
      //bool confirm = await confirmDialog(context, qrScanRes, 'salida');
      attendanceProvider.postNewAttendance(
          qrModel.id, 'CHECK_OUT', userLocation);
      //Actualizar cambios
      await attendanceProvider.updateCurrentStatus();
    }
    //Post a Check-in
    else if (lastEvent['event_type'] == 'CHECK_OUT') {
      //ERROR PORQUE SE HICIERON LOS 2 CHECKS.
      errorDialog(context, 'Se hizo el checkout del día');
    }
  }
}

confirmDialog(BuildContext context, String barcodeScanRes, String check) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmación',
          ),
          content: Text('¿Estás seguro que deseas registrar tu $check ?'),
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
            'Ha ocurrido un error',
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
