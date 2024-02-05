import 'package:flutter/material.dart';
import '../../theme/palette.dart';

Text largeText(String title, bool isHome) {
  return Text(
    title,
    style: TextStyle(
        fontSize: isHome ? 25 : 20,
        fontFamily: "JetBrainsMonoExtraBold",
        color: isHome ? Palette.themeColor : Colors.white),
  );
}
