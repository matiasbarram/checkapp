import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

scanQr(BuildContext context) async {
  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);

  confirmDialog(context, barcodeScanRes);

  final scanQrProvider = Provider.of<ScanQrProvider>(context, listen: false);
  if (barcodeScanRes != '-1') {
    scanQrProvider.qrResp = barcodeScanRes.toString();
    scanQrProvider.nuevoScan();
  }
}

confirmDialog(BuildContext context, String barcodeScanRes) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Respuesta',
          ),
          content: Text(barcodeScanRes),
          actions: [
            ElevatedButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      });
}
