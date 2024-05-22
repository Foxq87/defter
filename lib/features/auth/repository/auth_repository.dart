import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/failure.dart';
import 'package:acc/core/type_defs.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/core/providers/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider),
    ));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _schools =>
      _firestore.collection(FirebaseConstants.schoolsCollection);
  CollectionReference get _mail =>
      _firestore.collection(FirebaseConstants.mailCollection);

  Stream<User?> get authStatesChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    String appbeyogluUserUid = '';
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = await GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel userModel = await UserModel(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        name_insensitive: userCredential.user!.displayName?.toLowerCase() ?? '',
        username: '',
        username_insensitive: '',
        profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
        schoolId: '',
        banner: Constants.bannerDefault,
        email: userCredential.user!.email ?? '',
        bio: '',
        isSuspended: false,
        creation: DateTime.now(),
        roles: [],
        followers: [],
        following: [],
        closeFriends: [],
        ofCloseFriends: [],
        closeFriendsFeedNoteIds: [],
      );
      // String formattedEmail = await emailFormatter(userCredential.user!.email!);

      // _users.get().then((value) {
      //   for (var element in value.docs) {
      //     element.reference.update(
      //       {
      //         "email": emailFormatter(element.get('email')),
      //       },
      //     );
      //   }
      // });
      // List<String> waiterEmails = [];
      // await _mail.doc('subscribers').get().then((value) {
      //   if (value.exists) {
      //     List<String> waiterEmailList = value.get('subscribers');
      //     for (var element in waiterEmailList) {
      //       waiterEmails.add(element.to);
      //     }
      //   }
      // });

      // print(waiterEmails.toList());
      _users
          .where('email', isEqualTo: userCredential.user!.email)
          .get()
          .then((value) async {
        if (value.docs.isEmpty /* this is new user */ &&
            userCredential.additionalUserInfo!.isNewUser) {
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        } else if (value.docs.isNotEmpty /*this is appbeyoglu user */ &&
            userCredential.additionalUserInfo!.isNewUser) {
          appbeyogluUserUid = await value.docs.first.get('uid');

          //get appbeyoglu user data
          userModel = await getUserData(appbeyogluUserUid).first;

          //change uid, username, creation, roles and schoolId
          userModel = userModel.copyWith(
            uid: userCredential.user!.uid,
            username: '',
            creation: userModel.creation,
            roles: ['appbeyoglu-user'],
            schoolId: 'BAIHL',
          );

          //update database values
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());

          //delete old user
          await _users.doc(appbeyogluUserUid).delete();
        } else /* this is defter user */ {
          userModel = await getUserData(userCredential.user!.uid).first;
        }
        // if (waiterEmails.contains(userCredential.user!.email)) {
        //   await _users.doc(userCredential.user!.uid).set(userModel.copyWith(
        //         roles: ['waitLister'],
        //         email: formattedEmail,
        //       ));
        // }
      });
      //return user
      return await right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> suspendAccount(String uid) async {
    try {
      await _users.doc(uid).update({
        "isSuspended": true,
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  List<String> getUsernames() {
    List<String> usernames = [];
    _users.get().then((value) {
      for (var element in value.docs) {
        if (element.get('username').toString().isNotEmpty) {
          usernames.add(element.get('username'));
        }
      }
    });

    print("provider: $usernames");

    return usernames;
  }

  FutureEither setupUser(
      String uid,
      String fullName,
      String fullNameInsensitive,
      String username,
      String usernameInsensitive,
      String schoolId) async {
    try {
      _users.doc(uid).update({
        "username": username,
        "username_insensitive": usernameInsensitive,
        "name": fullName,
        "name_insensitive": fullNameInsensitive,
        "schoolId": schoolId,
      });
      _schools.doc(schoolId).update({
        "students": FieldValue.arrayUnion([uid]),
      });

      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // bool isUserSetup(WidgetRef ref) {
  //   final UserModel myUser = ref.watch(userProvider)!;
  //   return myUser.name.isEmpty ||
  //       myUser.username.isEmpty ||
  //       myUser.schoolId.isEmpty;
  // }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
