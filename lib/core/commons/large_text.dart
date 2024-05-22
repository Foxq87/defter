import 'package:flutter/material.dart';
import '../../theme/palette.dart';

Text largeText(String title, bool isHome,) {
  return Text(
    title,
    style: TextStyle(
        fontSize: isHome ? 25 : 20,
        fontFamily: "JetBrainsMonoExtraBold",
        color: isHome ? Palette.themeColor : Colors.white),
  );
}

TextButton smallTextButton(
    {required String title,
    required Color color,
    required double fontSize,
    required VoidCallback onPressed}) {
  return TextButton(
    style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 15),
        // minimumSize: Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerRight),
    onPressed: onPressed,
    child: Text(
      title,
      style: TextStyle(
          fontSize: fontSize, fontFamily: "JetBrainsMonoRegular", color: color),
    ),
  );
}
