import 'package:flutter/material.dart';
import 'package:checkapp/themes/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.checkAppOrange,
                  borderRadius: BorderRadius.circular(60)),
              child: IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(width: 48.0),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.history,
                color: AppTheme.textPrimColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
