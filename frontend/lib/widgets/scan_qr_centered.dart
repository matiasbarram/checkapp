import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

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
      onPressed: () {},
    );
  }
}
