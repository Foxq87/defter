import 'package:acc/theme/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaitingToLogin extends StatelessWidget {
  const WaitingToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Center(
          child: CupertinoButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('posts')
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              // final name = doc.get('name');
              // final username = doc.get('username');
              // final nameInsensitive = name.toLowerCase();
              // final usernameInsensitive = username.toLowerCase();
              List likes = doc.get('likes');
              doc.reference.update({
                'likesCount': likes.length,
              });
            });
          });
        },
        child: Image.asset(
          'assets/defter-icon-rounded.png',
          height: 150,
          width: 150,
        ),
      )),
    );
  }
}
