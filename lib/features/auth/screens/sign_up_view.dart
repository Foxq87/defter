import 'package:acc/core/commons/large_text.dart';
import 'package:acc/core/commons/nav_bar_button.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:routemaster/routemaster.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerNewUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // The user has been created successfully.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'şifreniz çok zayıf');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            context, 'bu email ile kayıt olmuş bir hesap zaten bulunuyor');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 13),
        borderRadius: BorderRadius.circular(20),
        color: Palette.orangeColor,
        onPressed: () {
          ref
              .read(authControllerProvider.notifier)
              .createUserWithEmailAndPassword(context,
                  emailController.text.trim(), passwordController.text.trim());
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'kaydet',
              style: TextStyle(
                  fontFamily: 'JetBrainsMonoRegular', color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              CupertinoIcons.check_mark_circled,
              color: Colors.white,
            ),
          ],
        ),
      ),
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        transitionBetweenRoutes: false,
        backgroundColor: Colors.transparent,
        leading: JustIconButton(
          icon: CupertinoIcons.back,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        border: const Border(
            bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
        middle: largeText('kayıt ol', false),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Image.asset(
            'assets/defter-icon-rounded.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CupertinoTextField(
              style: TextStyle(color: Colors.white),
              controller: emailController,
              placeholder: 'email',
              cursorColor: Palette.themeColor,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Palette.justGreyColor,
                  border:
                      Border.all(width: 0.45, color: Palette.darkGreyColor2)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CupertinoTextField(
              style: TextStyle(color: Colors.white),
              controller: passwordController,
              placeholder: 'şifre',
              cursorColor: Palette.themeColor,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Palette.justGreyColor,
                  border:
                      Border.all(width: 0.45, color: Palette.darkGreyColor2)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
