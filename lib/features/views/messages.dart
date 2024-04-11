import 'package:acc/core/commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/commons/not_available_card.dart';
import '../../theme/palette.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 1, color: Palette.textFieldColor)),
        middle: largeText('mesajlar', false),
      ),
      body: Column(
        children: [
          const NotAvailable(),
        ],
      ),
    );
  }
}
