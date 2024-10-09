import 'package:acc/core/commons/nav_bar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class JustAppBar extends StatelessWidget {
  const JustAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: JustIconButton(
          icon: CupertinoIcons.back, onPressed: () => Routemaster.of(context).pop()),
      actions: [
        JustIconButton(
            icon: Icons.more_horiz, onPressed: () => Routemaster.of(context).pop()),
        const SizedBox(
          width: 5,
        ),
      ],
      centerTitle: true,
      title: const Text(
        'Article',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'SFProDisplayBold',
        ),
      ),
      // trailing: navBarButton(Icons.more_horiz),
    );
  }
}
