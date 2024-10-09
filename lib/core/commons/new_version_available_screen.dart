import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/palette.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionAvailable extends ConsumerWidget {
  const NewVersionAvailable({super.key});
  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            Icon(
              CupertinoIcons.alarm,
              color: Palette.orangeColor,
              size: 50,
            ),
            Text(
              "defter'in yeni bir sürümü mevcut. kullanmaya devam etmek için defter'i güncelleyin",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 40,
              child: CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  borderRadius: BorderRadius.circular(100),
                  color: Palette.themeColor,
                  child: Text(
                    'güncelle',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFProDisplayRegular',
                    ),
                  ),
                  onPressed: () {
                    String url = '';
                    if (Platform.isIOS) {
                      url = 'https://apps.apple.com/tr/app/defder/id6503184877';
                    } else if (Platform.isAndroid) {
                      url =
                          'https://play.google.com/store/apps/details?id=app.web.defter.defter';
                    }
                    launchURL(url);
                  }),
            )
          ],
        ),
      ),
    ));
  }
}
