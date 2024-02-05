import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/palette.dart';
import '../constants/constants.dart';

Widget userSquare(BuildContext context) => GestureDetector(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: SvgPicture.asset(
        Constants.squareOutlined,
        colorFilter:
            const ColorFilter.mode(Palette.themeColor, BlendMode.srcIn),
        height: 30,
        
      ),
    );
