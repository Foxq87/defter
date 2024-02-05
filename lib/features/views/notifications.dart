import 'package:acc/core/commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/palette.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 1, color: Palette.textfieldColor)),
        middle: largeText('notifications', false),
      ),
    );
  }
}
