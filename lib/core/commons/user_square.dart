import 'package:acc/theme/palette.dart';
import 'package:flutter/material.dart';

Widget userSquare(BuildContext context, String imageLink) => GestureDetector(
    onTap: () => Scaffold.of(context).openDrawer(),
    child: Container(
      height: 30.0,
      width: 30.0,
      decoration: BoxDecoration(
          color: Palette.textFieldColor,
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(
              imageLink,
            ),
            fit: BoxFit.cover,
          )),
    ));
