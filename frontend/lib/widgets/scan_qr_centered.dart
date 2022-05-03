import 'package:checkapp/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/scan_qr.dart';
import '../themes/app_theme.dart';

class ScanQRCentered extends StatelessWidget {
  const ScanQRCentered({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attendace = Provider.of<AttendanceService>(context, listen: false);
    return FloatingActionButton(
      elevation: 0,
      backgroundColor:
          attendace.freeDay ? Colors.grey.shade400 : AppTheme.checkAppBlue,
      child: Icon(
        Icons.qr_code,
        color: attendace.freeDay ? Colors.grey.shade600 : null,
      ),
      onPressed: attendace.freeDay
          ? null
          : () async {
              return await scanQr(context);
            },
    );
  }
}
