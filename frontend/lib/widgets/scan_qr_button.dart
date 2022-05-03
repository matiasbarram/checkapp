import 'package:flutter/material.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:provider/provider.dart';

import '../helpers/scan_qr.dart';
import '../services/services.dart';

class ScanQRButton extends StatelessWidget {
  const ScanQRButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attendace = Provider.of<AttendanceService>(context, listen: false);

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            primary: AppTheme.checkAppBlue),
        onPressed: attendace.freeDay ? null : () async => await scanQr(context),
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
