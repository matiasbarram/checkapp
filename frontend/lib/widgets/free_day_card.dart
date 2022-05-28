import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';

class FreeDayCard extends StatelessWidget {
  const FreeDayCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(3, 4))
          ],
        ),
        width: double.infinity,
        height: 100,
        child: const Text('Disfruta tu día libre',
            style: TextStyle(
                color: AppTheme.checkAppBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600)));
  }
}
