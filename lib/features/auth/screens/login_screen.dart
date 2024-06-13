import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/sign_in_buttons.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
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
                  const SizedBox(
                    height: 40,
                  ),
                  const SignInButton(),
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
                  CreateAccButton(
                    ref: ref,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  agreements(),
                  const Spacer(),
                  Text(
                    'zaten bir hesabın var mı?',
                    style: TextStyle(
                        fontFamily: 'JetBrainsMonoRegular',
                        fontSize: 15,
                        color: Palette.placeholderColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  const LogInButton(),
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
