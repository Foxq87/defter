import 'package:acc/features/auth/repository/auth_repository.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Stream<User?> get authStateChanges => _authRepository.authStatesChanges;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => print(l.message), //showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logOut();
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
    String defterUid = 'vchV88dY6FMdXcT1mwac8VWFPG73';
    // state = true;
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

    res.fold((l) => print(l.message), (r) => null);
    // state = false;
  }

  bool isUserNotSetup(WidgetRef ref) {
    final UserModel myUser = ref.watch(userProvider)!;
    return myUser.name.isEmpty ||
        myUser.username.isEmpty ||
        myUser.schoolId.isEmpty;
  }
}
