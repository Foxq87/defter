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

class CreateAccButton extends StatelessWidget {
  final WidgetRef ref;
  const CreateAccButton({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
            onPressed: () {
              Routemaster.of(context).push('/create-account');
              // List<School> schools = [
              //   School(
              //       id: 'BAIHL',
              //       title: "Beyoğlu Anadolu İmam-Hatip Lisesi",
              //       banner: '',
              //       avatar: '',
              //       students: [],
              //       mods: []),
              //   School(
              //       id: 'CFL',
              //       title: "Çapa Fen Lisesi",
              //       banner: '',
              //       avatar: '',
              //       students: [],
              //       mods: []),
              //   School(
              //       id: 'KAIHL',
              //       title: "Kartal Anadolu İmam-Hatip Lisesi",
              //       banner: '',
              //       avatar: '',
              //       students: [],
              //       mods: []),
              // ];
              // final _firestore = ref.read(firestoreProvider);
              // final _schoolsRef = FirebaseConstants.schoolsCollection;

              // for (var school in schools) {
              //   _firestore
              //       .collection(_schoolsRef)
              //       .doc(school.id)
              //       .set(school.toMap());
              // }
            },
            color: Palette.themeColor,
            borderRadius: BorderRadius.circular(17),
            child: const Center(
                child: Text(
              "hesap oluştur",
              style: TextStyle(fontSize: 20, fontFamily: "JetBrainsMonoBold"),
            ))),
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  const LogInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: () {
          //   FirebaseFirestore.instance
          //       .collection('users')
          //       .get()
          //       .then((querySnapshot) {
          //     querySnapshot.docs.forEach((doc) {
          //       doc.reference.update({

          //       });
          //     });
          //   });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(17.0),
          ),
          minimumSize: const Size(double.infinity, 55),
        ),
        child: const Text(
          "giriş yap",
          style: TextStyle(
              fontSize: 20,
              fontFamily: "JetBrainMonoRegulars",
              color: Palette.themeColor),
        ),
      ),
    );
  }
}
