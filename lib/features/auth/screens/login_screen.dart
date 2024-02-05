import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/sign_in_buttons.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

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
                            text: "join us\t>>>",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "JetBrainsMonoExtraBold")),
                        TextSpan(
                            text: '\tacc.',
                            style: TextStyle(
                                color: Palette.themeColor,
                                fontSize: 35,
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
                        "or",
                        style: TextStyle(fontSize: 17),
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
                  const LogInButton(),
                ],
              ),
      ),
    );
  }

  Padding agreements() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
                text: "by signing up, you agree to the",
                style: TextStyle(
                    fontSize: 15, fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tterms of service.',
                style: TextStyle(
                    color: Palette.themeColor,
                    fontSize: 15,
                    fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tand',
                style: TextStyle(
                    fontSize: 15, fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tprivacy policy,',
                style: TextStyle(
                    color: Palette.themeColor,
                    fontSize: 15,
                    fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tincluding',
                style: TextStyle(
                    fontSize: 15, fontFamily: "JetBrainsMonoExtraBold")),
            TextSpan(
                text: '\tcookie use.',
                style: TextStyle(
                    color: Palette.themeColor,
                    fontSize: 15,
                    fontFamily: "JetBrainsMonoExtraBold")),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
