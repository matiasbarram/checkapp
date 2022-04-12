import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/scan_qr.dart';
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
