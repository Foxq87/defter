import 'package:acc/theme/palette.dart';
import 'package:flutter/material.dart';

class WaitingToLogin extends StatelessWidget {
  const WaitingToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Center(
          child: Image.asset(
        'assets/defter-icon-rounded.png',
        height: 150,
        width: 150,
      )),
    );
  }
}
