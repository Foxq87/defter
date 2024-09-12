import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/failure.dart';
import 'package:acc/core/type_defs.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/core/providers/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String normalizeEmail(String email) {
    final parts = email.split('@');
    return '${parts[0].replaceAll('.', '')}@${parts[1]}';
  }

  FutureEither<UserModel> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      email = normalizeEmail(email);
      // bool isEmailRegistered = false;
      // await _users.get().then((value) {
      //   value.docs.forEach((element) {
      //     if ((email == element.get('email') ||
      //             normalizeEmail(email) == element.get('email')) &&
      //         element.get('dormType') == null) {
      //       isEmailRegistered = true;
      //     }
      //   });
      // });

      // if (isEmailRegistered) {
      //   throw FirebaseAuthException(
      //     code: 'email-already-in-use',
      //     message: 'The email address is already in use by another account.',
      //   );
      // } else {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
        warningCount: 0,
        uid: userCredential.user!.uid,
        name: '',
        name_insensitive: '',
        username: '',
        username_insensitive: '',
        profilePic: Constants.avatarDefault,
        schoolId: '',
        banner: Constants.bannerDefault,
        email: email,
        bio: '',
        isSuspended: false,
        creation: DateTime.now(),
        roles: [],
        followers: [],
        following: [],
        closeFriends: [],
        ofCloseFriends: [],
        didAcceptEula: false,
        blockedAccountIds: [],
      );

      // if (/* this is new user */
      //     userCredential.additionalUserInfo!.isNewUser) {
      //   print("sikecem aa" + userCredential.user!.uid);
      //   await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      // } else /* this is defter user */ {
      //   userModel = await getUserData(userCredential.user!.uid).first;
      // }
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        final docSnapshot = await _users.doc(userCredential.user!.uid).get();

        if (docSnapshot.exists) {
          userModel =
              UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
        } else {
          // Handle the situation when the document doesn't exist, e.g., create it.
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        }
      }
      // if (waiterEmails.contains(userCredential.user!.email)) {
      //   await _users.doc(userCredential.user!.uid).set(userModel.copyWith(
      //         roles: ['waitLister'],
      //         email: formattedEmail,
      //       ));
      // }

      // await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return right(userModel);
      // }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'şifre en az 6 karakter içermeli');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            context, 'bu email ile kayıt olmuş bir hesap zaten bulunuyor');
      } else if (e.code == 'invalid-email') {
        showSnackBar(context, 'lütfen geçerli bir email girin');
      } else {
        showSnackBar(context, e.message.toString());
      }
      print(e.code);
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      email = normalizeEmail(email);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseException catch (e) {
      print(e.message! + 'code:' + e.code);
      if (e.code == "user-not-found") {
        showSnackBar(
            context, 'bu email ile kayıt olmuş bir kullanıcı bulunamadı');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "yanlış şifre");
      } else if (e.code == 'invalid-email') {
        showSnackBar(context, 'Lütfen geçerli bir email girin');
      } else {
        showSnackBar(context, e.message.toString());
      }
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

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
        warningCount: 0,
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        name_insensitive: userCredential.user!.displayName?.toLowerCase() ?? '',
        username: '',
        username_insensitive: '',
        profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
        schoolId: '',
        banner: Constants.bannerDefault,
        email: userCredential.user!.email == null
            ? ''
            : normalizeEmail(userCredential.user!.email!),
        bio: '',
        isSuspended: false,
        creation: DateTime.now(),
        roles: [],
        followers: [],
        following: [],
        closeFriends: [],
        ofCloseFriends: [],
        didAcceptEula: false,
        blockedAccountIds: [],
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

  // FutureEither<UserModel> signInWithApple(
  //     {List<Scope> scopes = const []}) async {
  //   final result = await TheAppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);

  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final AppleIdCredential = result.credential!;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //           idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
  //       final userCredential = await _auth.signInWithCredential(credential);
  //       final firebaseUser = userCredential.user!;
  //       UserModel userModel = await UserModel(
  //         warningCount: 0,
  //         uid: userCredential.user!.uid,
  //         name: userCredential.user!.displayName ?? '',
  //         name_insensitive:
  //             userCredential.user!.displayName?.toLowerCase() ?? '',
  //         username: '',
  //         username_insensitive: '',
  //         profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
  //         schoolId: '',
  //         banner: Constants.bannerDefault,
  //         email: userCredential.user!.email == null
  //             ? ''
  //             : normalizeEmail(userCredential.user!.email!),
  //         bio: '',
  //         isSuspended: false,
  //         creation: DateTime.now(),
  //         roles: [],
  //         followers: [],
  //         following: [],
  //         closeFriends: [],
  //         ofCloseFriends: [],
  //         didAcceptEula: false,
  //         blockedAccountIds: [],
  //       );
  //       return right(userModel);
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //           code: 'ERROR_AUTHORIZATION_DENIED',
  //           message: result.error.toString());

  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //           code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

  //     default:
  //       throw UnimplementedError();
  //   }
  // }

  FutureEither<UserModel> signInWithApple() async {
    String appbeyogluUserUid = '';
    try {
      // Request Apple ID credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Use the credentials to sign in with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(
        OAuthProvider('apple.com').credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        ),
      );
      // Check if the user already exists in Firestore
      // final userSnapshot = await _users.doc(authResult.user?.uid).get();
      // if (userSnapshot.exists) {
      //   // User already exists, retrieve the existing data
      //   final userData = userSnapshot.data() as Map<String, dynamic>;
      //   UserModel userModel = UserModel.fromMap(userData);
      //   return right(userModel);
      // }

      // Create a new UserModel object with the necessary data
      UserModel userModel = UserModel(
        warningCount: 0,
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        name_insensitive: userCredential.user!.displayName?.toLowerCase() ?? '',
        username: '',
        username_insensitive: '',
        profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
        schoolId: '',
        banner: Constants.bannerDefault,
        email: userCredential.user!.email == null
            ? ''
            : normalizeEmail(userCredential.user!.email!),
        bio: '',
        isSuspended: false,
        creation: DateTime.now(),
        roles: [],
        followers: [],
        following: [],
        closeFriends: [],
        ofCloseFriends: [],
        didAcceptEula: false,
        blockedAccountIds: [],
        // Set the other properties of the userModel object
        // ...
      );

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

      // Save the user data to the Firestore collection
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      // Return the userModel object
      return right(userModel);
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

  FutureEither<void> deleteAccount(String uid) async {
    try {
      await _users.doc(uid).delete();
      await _auth.currentUser!.delete();
      await _googleSignIn.signOut();
      await _auth.signOut();
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> blockAccount(UserModel currentUser, String uid) async {
    try {
      await _users.doc(currentUser.uid).update({
        "blockedAccountIds": FieldValue.arrayUnion([uid]),
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> warnUser(String uid) async {
    try {
      final user = await _users.doc(uid).get();
      int warningCount = user.get('warningCount');
      if (warningCount + 1 >= 3) {
        await suspendAccount(uid);
      }
      await _users.doc(uid).update({
        "warningCount": warningCount + 1,
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
      final userdoc = await _users.doc(uid).get();
      if (userdoc.exists) {
        _users.doc(uid).update({
          "username": username,
          "username_insensitive": usernameInsensitive,
          "name": fullName,
          "name_insensitive": fullNameInsensitive,
          "schoolId": schoolId,
          "didAcceptEula": true,
        });
        _schools.doc(schoolId).update({
          "students": FieldValue.arrayUnion([uid]),
        });
      } else {
        return left(Failure('bir hata oluştu, daha sonra tekrar deneyin'));
      }

      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither acceptEULA(
    String uid,
  ) async {
    try {
      _users.doc(uid).update({
        "didAcceptEula": true,
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

  Future<Either> logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _googleSignIn.disconnect();

      return right(null);
    } catch (e) {
      return left(null);
    }
    // Disconnect from Google account

    // await GoogleSignIn().currentUser.clearAuthCache();
  }
}
