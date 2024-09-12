import 'package:acc/core/type_defs.dart';
import 'package:acc/features/auth/repository/auth_repository.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/features/widget_tree.dart';
import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => print(l.message), //showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void signInWithApple(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithApple();
    state = false;
    user.fold(
      (l) => print(l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signInWithEmailAndPassword(
        context, email, password);
    state = false;
    user.fold(
      (error) {
        // showSnackBar(context, error.message);
        print(error.message);
      },
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.createUserWithEmailAndPassword(
        context, email, password);
    state = false;
    user.fold((l) {
      print(l);
      // showSnackBar(context,
      //     'bir hata oluştu. lütfen daha sonra tekrar deneyin: ' + l.toString());
    }, //showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout(BuildContext context) async {
    final res = await _authRepository.logOut();
    res.fold((l) => showSnackBar(context, "bir hata oluştu"), (r) {
      for (var i = 0; i < 1; i++) {
        Navigator.pop(context);
      }
    });
  }

  void deleteAccount(String uid, BuildContext context) async {
    state = true;
    final result = await _authRepository.deleteAccount(uid);
    state = false;
    result.fold(
      (error) => showSnackBar(context, error.message),
      (success) => showSnackBar(context, 'hesabınız silinmiştir'),
    );
  }

  void suspendAccount(String uid, BuildContext context) async {
    state = true;
    final result = await _authRepository.suspendAccount(uid);
    state = false;
    result.fold(
      (error) => showSnackBar(context, error.message),
      (success) => print('Account suspended successfully.'),
    );
  }

  void blockAccount(String uid, BuildContext context) async {
    state = true;
    UserModel currentUser = _ref.read(userProvider)!;
    final result = await _authRepository.blockAccount(currentUser, uid);
    currentUser.blockedAccountIds.add(uid);
    final updatedCurrentUser =
        currentUser.copyWith(blockedAccountIds: currentUser.blockedAccountIds);
    print("blockeds:" + updatedCurrentUser.blockedAccountIds.toString());
    state = false;
    result.fold(
      (error) => showSnackBar(context, error.message),
      (success) => _ref
          .read(userProvider.notifier)
          .update((state) => updatedCurrentUser),
    );
  }

  void warnUser(String uid, BuildContext context) async {
    state = true;
    final result = await _authRepository.suspendAccount(uid);
    state = false;
    result.fold(
      (error) => showSnackBar(context, error.message),
      (success) => print('Account suspended successfully.'),
    );
  }

  List<String> getUsernames() {
    return _authRepository.getUsernames();
  }

  void setupUser(
    BuildContext context,
    String uid,
    String fullName,
    String fullNameInsensitive,
    String username,
    String usernameInsensitive,
    String schoolId,
  ) async {
    String defterUid = 'ku0DDDpShoR8dqhhhx3IIbtpE5u1';
    // state = true;
    UserModel currentUser = _ref.read(userProvider)!;
    if (currentUser.schoolId.isNotEmpty) {
      schoolId = currentUser.schoolId;
    } else if (currentUser.schoolId.isEmpty) {
      schoolId = "onay bekliyor: " + schoolId;
    }
    _ref.read(notificationControllerProvider.notifier).sendNotification(
          context: context,
          content: "aramıza hoşgeldin!",
          type: "follow",
          id: uid,
          receiverUid: uid,
          senderId: defterUid,
        );
    final res = await _authRepository.setupUser(uid, fullName,
        fullNameInsensitive, username, usernameInsensitive, schoolId);

    res.fold(
        (l) => showSnackBar(
            context,
            'bir hata oluştu. lütfen daha sonra tekrar deneyin: ' +
                l.toString()),
        (r) => null);
    // state = false;
  }

  void acceptEULA(
    BuildContext context,
    String uid,
  ) async {
    UserModel myUser = _ref.read(userProvider)!;
    // String defterUid = 'vchV88dY6FMdXcT1mwac8VWFPG73';
    // state = true;
    // _ref.read(notificationControllerProvider.notifier).sendNotification(
    //       context: context,
    //       content: "aramıza hoşgeldin!",
    //       type: "follow",
    //       id: uid,
    //       receiverUid: uid,
    //       senderId: defterUid,
    //     );
    myUser = myUser.copyWith(didAcceptEula: true);
    _ref.read(userProvider.notifier).update((state) => myUser);
    final res = await _authRepository.acceptEULA(uid);

    res.fold((l) => print(l.message), (r) => null);
    // state = false;
  }

  bool isUserNotSetup(WidgetRef ref, UserModel myUser) {
    return myUser.name.isEmpty ||
        myUser.username.isEmpty ||
        myUser.schoolId.isEmpty ||
        !myUser.didAcceptEula;
  }

  bool didNotUserAcceptedEula(WidgetRef ref) {
    UserModel myUser = ref.read(userProvider)!;

    print("did i accept eula:" + myUser.didAcceptEula.toString());
    return myUser.didAcceptEula;
  }
}
