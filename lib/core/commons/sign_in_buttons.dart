import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../theme/palette.dart';

class ContinueWithGoogleButton extends ConsumerWidget {
  const ContinueWithGoogleButton({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton.icon(
        icon: Image.asset(
          "assets/images/google.png",
          height: 40,
          width: 40,
        ),
        onPressed: () => signInWithGoogle(ref, context),
        label: const Text(
          "google ile devam et",
          style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontFamily: 'JetBrainsMonoRegular'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

class ContinueWithAppleButton extends ConsumerWidget {
  const ContinueWithAppleButton({super.key});

  void signInWithApple(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithApple(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton.icon(
        icon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            "assets/images/apple.png",
            height: 30,
            width: 30,
          ),
        ),
        onPressed: () => signInWithApple(ref, context),
        label: const Text(
          "apple ile devam et",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'JetBrainsMonoRegular',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  final WidgetRef ref;
  final String email;
  final String password;
  const LogInButton(
      {super.key,
      required this.ref,
      required this.email,
      required this.password});

  @override
  Widget build(BuildContext context) {
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
              if (email.isEmpty || password.isEmpty) {
                showSnackBar(context, 'lütfen tüm alanları doldurun');
              } else if (!isValidEmail(email)) {
                showSnackBar(context, 'lütfen geçerli bir email girin');
              } else if (password.length < 6) {
                showSnackBar(context, 'şifre en az 6 karakter içermeli');
              } else {
                ref
                    .read(authControllerProvider.notifier)
                    .signInWithEmailAndPassword(context, email, password);
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
}

// class LogInButton extends StatelessWidget {
//   const LogInButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: ElevatedButton(
//         onPressed: () {
//           //   FirebaseFirestore.instance
//           //       .collection('users')
//           //       .get()
//           //       .then((querySnapshot) {
//           //     querySnapshot.docs.forEach((doc) {
//           //       doc.reference.update({

//           //       });
//           //     });
//           //   });
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(width: 1, color: Colors.white),
//             borderRadius: BorderRadius.circular(17.0),
//           ),
//           minimumSize: const Size(double.infinity, 55),
//         ),
//         child: const Text(
//           "giriş yap",
//           style: TextStyle(
//               fontSize: 20,
//               fontFamily: "JetBrainMonoRegulars",
//               color: Palette.themeColor),
//         ),
//       ),
//     );
//   }
// }
