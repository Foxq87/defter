import 'package:acc/core/constants/constants.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_plus/share_plus.dart';

void showShareModalBottomSheet(BuildContext context, String url) {
  showModalBottomSheet(
    backgroundColor: Palette.darkGreyColor,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: SvgPicture.asset(
                Constants.upload,
                width: 22,
                height: 22,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              title: Text('paylaş'),
              onTap: () {
                Share.share(url);
                Routemaster.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('link\'i kopyala'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: url));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('link kopyalandı'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                );
                 Routemaster.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.clear,
                color: Palette.redColor,
              ),
              title: Text('geri',
                  style: TextStyle(
                    color: Palette.redColor,
                  )),
              onTap: () {
                  Routemaster.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
