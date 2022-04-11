import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../themes/app_theme.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQRCentered extends StatelessWidget {
  const ScanQRCentered({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: AppTheme.checkAppBlue,
      child: const Icon(
        Icons.qr_code,
      ),
      onPressed: () => scanQr(context),
    );
  }
}

scanQr(BuildContext context) async {
  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#174A7C', 'Cancelar', false, ScanMode.QR);

  confirmDialog(context, barcodeScanRes);

  final scanQrProvider = Provider.of<ScanQrProvider>(context, listen: false);
  scanQrProvider.nuevoScan(barcodeScanRes);
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
