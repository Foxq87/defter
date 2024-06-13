import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';
class EulaScreen extends ConsumerWidget {
  

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
    final currentUser = ref.read(userProvider)!;
    return Scaffold(
      appBar: AppBar(title: Text('End User License Agreement')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // ...

            CupertinoButton(
              child: Text('I Agree'),
              onPressed: () {
                // Save user's agreement to EULA
                ref
                    .read(authControllerProvider.notifier)
                    .acceptEULA(context, currentUser.uid);
              },
            ),
          ],
        ),
      ),
    );
  }
}
