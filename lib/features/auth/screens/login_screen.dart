import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/sign_in_buttons.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            : Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: "bize katıl >>> ",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: "JetBrainsMonoExtraBold")),
                        TextSpan(
                            text: 'defter',
                            style: TextStyle(
                                color: Palette.themeColor,
                                fontSize: 30,
                                fontFamily: "JetBrainsMonoExtraBold"))
                      ]),
                    ),
                  ),
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
                  const LogInButton(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          endIndent: 10,
                          indent: 20,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "veya",
                        style: TextStyle(
                            fontSize: 17, fontFamily: 'JetBrainsMonoRegular'),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          endIndent: 20,
                          indent: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const ContinueWithGoogleButton(),
                  const Spacer(),
                  Text(
                    'henüz hesabın yok mu?',
                    style: TextStyle(
                        color: Palette.placeholderColor,
                        fontSize: 17,
                        fontFamily: 'JetBrainsMonoRegular'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CreateAccButton(
                    ref: ref,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 0.45,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  agreements(),
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
