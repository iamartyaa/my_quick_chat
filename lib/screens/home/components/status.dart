import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';

class Status extends StatelessWidget {
  const Status({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: Image.asset(
              'assets/images/hourglass.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          'Coming Soon ...',
          style: MyTheme.heading2,
        ),
      ],
    );
  }
}
