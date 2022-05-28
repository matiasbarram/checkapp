import 'package:checkapp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/widgets.dart';

class ResumenScreen extends StatelessWidget {
  const ResumenScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final attendence = Provider.of<AttendanceService>(context);
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              height: 270,
              color: AppTheme.checkappPrim,
              width: double.infinity,
            ),
            Column(
              children: [
                const ScanQRButton(),
                const SizedBox(height: 40),
                _AttendanceCards(attendence: attendence)
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _AttendanceCards extends StatelessWidget {
  const _AttendanceCards({
    Key? key,
    required this.attendence,
  }) : super(key: key);

  final AttendanceService attendence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          if (attendence.freeDay) ...[
            const FreeDayCard()
          ] else ...[
            const AttendanceCard(title: 'Entrada'),
            const SizedBox(
              height: 40,
            ),
            const AttendanceCard(title: 'Salida'),
          ],
          const SizedBox(
            height: 10,
          ),
          const Text(
            '¿Tienes algún problema?',
            style: TextStyle(color: AppTheme.checkApptextLight),
          )
        ],
      ),
    );
  }
}
