import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Palette.themeColor, borderRadius: BorderRadius.circular(15)),
        child: const Center(
          child: CupertinoActivityIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
