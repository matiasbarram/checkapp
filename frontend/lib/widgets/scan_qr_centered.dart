import 'package:checkapp/models/scan_model.dart';
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
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#174A7C', 'Cancelar', false, ScanMode.QR);

        final scanQrProvider =
            Provider.of<ScanQrProvider>(context, listen: false);
        scanQrProvider.nuevoScan(barcodeScanRes);
      },
    );
  }
}
