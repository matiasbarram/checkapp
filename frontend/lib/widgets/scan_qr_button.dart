import 'package:flutter/material.dart';
import 'package:checkapp/themes/app_theme.dart';

import '../helpers/scan_qr.dart';

class ScanQRButton extends StatelessWidget {
  const ScanQRButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            primary: AppTheme.checkAppBlue),
        onPressed: () => scanQr(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(
              Icons.qr_code_sharp,
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              'Escanear QR asistencia',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ));
  }
}
