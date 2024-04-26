import 'dart:io';

import 'package:acc/core/commons/error_text.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:acc/core/utils.dart';

import 'package:acc/features/user_profile/repository/user_profile_repository.dart';
import 'package:acc/models/note_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/failure.dart';
import '../../../core/providers/storage_providers.dart';
import '../../auth/controller/auth_controller.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getUserNotesProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserNotes(uid);
});

final getUserFollowersProvider =
    StreamProvider.family((ref, List<String> followerUids) {
  return ref
      .read(userProfileControllerProvider.notifier)
      .getUserFollowers(followerUids);
});

final getUserFollowingsProvider =
    StreamProvider.family((ref, List<String> followingUids) {
  return ref
      .read(userProfileControllerProvider.notifier)
      .getUserFollowings(followingUids);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUserProfile({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required String name,
    required String username,
    required String bio,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        // webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
        // webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(
      name: name,
      username: username,
      bio: bio,
    );
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Note>> getUserNotes(String uid) {
    return _userProfileRepository.getUserNotes(uid);
  }

  Stream<List<UserModel>> getUserFollowers(List<String> followerUids) {
    return _userProfileRepository.getUserFollowers(followerUids);
  }

  Stream<List<UserModel>> getUserFollowings(List<String> followingUids) {
    return _userProfileRepository.getUserFollowings(followingUids);
  }

  void followUser(
    BuildContext context,
    UserModel user,
    UserModel currentUser,
    WidgetRef ref,
  ) async {
    // if (currentUser.following.contains(user.uid) /*if i am following him*/) {
    //   user.followers.remove(currentUser.uid); //
    //   currentUser.following.remove(user.uid); //
    // } else {
    //   user.followers.add(currentUser.uid);
    //   currentUser.following.add(user.uid);
    // }
    _ref.read(notificationControllerProvider.notifier).sendNotification(
          context: context,
          type: 'follow',
          content: "${currentUser.username} seni takip ediyor",
          senderId: currentUser.uid,
          receiverUid: user.uid,
          id: currentUser.uid,
        );

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);
    final res = await _userProfileRepository.followUser(user, currentUser);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => currentUser);
      },
    );
  }

  // void updateUserKarma(UserKarma karma) async {
  //   UserModel user = _ref.read(userProvider)!;
  //   user = user.copyWith(karma: user.karma + karma.karma);

  //   final res = await _userProfileRepository.updateUserKarma(user);
  //   res.fold((l) => null, (r) => _ref.read(userProvider.notifier).update((state) => user));
  // }
}
