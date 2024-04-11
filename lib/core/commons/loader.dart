// import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      'assets/animations/loading_animation.json',
      height: 100,
      width: 100,
    ));
    // Center(

    //   child: Container(
    //     height: 60,
    //     width: 60,
    //     decoration: BoxDecoration(
    //         color: Palette.themeColor, borderRadius: BorderRadius.circular(15)),
    //     child: const Center(
    //       child: CupertinoActivityIndicator(
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    // );
  }
}
