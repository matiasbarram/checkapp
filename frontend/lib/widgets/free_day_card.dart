import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';

class FreeDayCard extends StatelessWidget {
  const FreeDayCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
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
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'DISFRUTA TU DIA LIBRE',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.checkApptextLight),
              )
            ],
          ),
        ],
      ),
    );
  }
}
