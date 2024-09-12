import 'dart:io';

import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/sign_in_buttons.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget loginButton(BuildContext context, WidgetRef ref) {
    bool isValidEmail(String email) {
      // Use a regular expression to validate the email format
      final emailRegex = RegExp(
          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
      return emailRegex.hasMatch(email);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
            onPressed: () {
              if (emailController.text.trim().isEmpty ||
                  passwordController.text.trim().isEmpty) {
                showSnackBar(context, 'lütfen tüm alanları doldurun');
              } else if (!isValidEmail(emailController.text.trim())) {
                showSnackBar(context, 'lütfen geçerli bir email girin');
              } else if (passwordController.text.trim().length < 6) {
                showSnackBar(context, 'şifre en az 6 karakter içermeli');
              } else {
                ref
                    .read(authControllerProvider.notifier)
                    .signInWithEmailAndPassword(
                        context,
                        emailController.text.trim(),
                        passwordController.text.trim());
              }
            },
            color: Palette.themeColor,
            borderRadius: BorderRadius.circular(17),
            child: const Center(
                child: Text(
              "giriş yap",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "JetBrainsMonoBold",
                  color: Colors.white),
            ))),
      ),
    );
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Loader()
            : ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/defter-icon-rounded.png',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text: 'defter',
                                style: TextStyle(
                                    color: Palette.themeColor,
                                    fontSize: 35,
                                    fontFamily: "JetBrainsMonoExtraBold"))
                          ]),
                        ),
                        RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text: "bize katıl",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "JetBrainsMonoExtraBold")),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CupertinoTextField(
                      style: TextStyle(color: Colors.white),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      controller: emailController,
                      placeholder: 'email',
                      cursorColor: Palette.themeColor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Palette.justGreyColor,
                          border: Border.all(
                              width: 0.45, color: Palette.darkGreyColor2)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CupertinoTextField(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      style: TextStyle(color: Colors.white),
                      controller: passwordController,
                      placeholder: 'şifre',
                      cursorColor: Palette.themeColor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Palette.justGreyColor,
                          border: Border.all(
                              width: 0.45, color: Palette.darkGreyColor2)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  loginButton(context, ref),
                  const SizedBox(
                    height: 15,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          endIndent: 10,
                          indent: 20,
                          thickness: 0.25,
                          color: Palette.noteIconColor,
                        ),
                      ),
                      Text(
                        "veya",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'JetBrainsMonoRegular',
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.25,
                          endIndent: 20,
                          indent: 10,
                          color: Palette.noteIconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ContinueWithGoogleButton(),
                      if (Platform.isIOS)
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: const ContinueWithAppleButton(),
                        ),
                    ],
                  )
                ],
              ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              thickness: 0.45,
              color: Colors.grey,
              height: 40,
            ),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'henüz hesabın yok mu? ',
                    style: TextStyle(
                        color: Palette.placeholderColor,
                        fontSize: 17,
                        fontFamily: 'JetBrainsMonoRegular'),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Routemaster.of(context).push('/create-account');
                      },
                    text: 'hesap oluştur',
                    style: TextStyle(
                        color: Palette.orangeColor,
                        // decoration: TextDecoration.underline,
                        fontSize: 17,
                        fontFamily: 'JetBrainsMonoRegular'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            // agreements(),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Padding agreements() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "kayıt olarak\t",
                style: TextStyle(
                    fontSize: 15, fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
              text: 'kullanıcı sözleşmemizi',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchURL(Constants.eulaLink);
                },
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Palette.themeColor,
                fontSize: 15,
                fontFamily: "JetBrainsMonoExtraBold",
              ),
            ),
            TextSpan(
                text: '\tve',
                style: TextStyle(
                    fontSize: 15, fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tgizlilik politikamızı',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchURL(Constants.privacyPolicyLink);
                  },
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Palette.themeColor,
                    fontSize: 15,
                    fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tkabul etmiş olursunuz',
                style: TextStyle(
                    fontSize: 15, fontFamily: "JetBrainsMonoExtraBold")),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
