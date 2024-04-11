import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.darkGreyColor,
                  ),
                ),
                Image.asset(
                  'assets/images/no_internet.png',
                  width: 270,
                  height: 270,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Lütfen internet bağlantınızı kontrol edin...",
              style: TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                color: Palette.orangeColor,
                borderRadius: BorderRadius.circular(19),
                child: const Text(
                  'Yenile',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'JetBrainsMonoBold'),
                ),
                onPressed: () {}),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
