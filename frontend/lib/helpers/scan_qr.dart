import 'package:checkapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

scanQr(BuildContext context) async {
  String qrScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);
  if (qrScanRes != (-1).toString()) {
    final attanceProvider =
        Provider.of<AttendanceService>(context, listen: false);
    final lastEvent = await attanceProvider.getLastAttendance();
    print(lastEvent);
    if (lastEvent['event_type'] == 'CHECK_IN' &&
        attanceProvider.salida == 'PENDIENTE') {
      //await confirmDialog(context, qrScanRes, 'salida');

    }

    //Se hicieron ambos scans
    if (attanceProvider.entrada != 'PENDIENTE' &&
        attanceProvider.salida != 'PENDIENTE') {
      await errorDialog(context, 'Ya se registró la entrada y salida');
    }
    //Salida pero no entrada
    if (attanceProvider.entrada == 'PENDIENTE' &&
        attanceProvider.salida != 'PENDIENTE') {
      await errorDialog(context, 'Hubo un error trigido');
      //Aún no se hace el primero
    } else if (attanceProvider.entrada == 'PENDIENTE' &&
        attanceProvider.salida == 'PENDIENTE') {
      await confirmDialog(context, qrScanRes, 'entrada');
      //Falta hacer la salida
    }
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
              onPressed: () => Navigator.of(context).pop(true),
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
