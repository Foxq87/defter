import 'dart:io';

import 'package:acc/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';


import '../../../core/constants/constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/storage_providers.dart';
import '../../../core/utils.dart';
import '../../../models/note_model.dart';
import '../../../models/school_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/school_repository.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final schoolController = ref.watch(schoolControllerProvider.notifier);
  return schoolController.getUserCommunities();
});

final schoolControllerProvider =
    StateNotifierProvider<SchoolController, bool>((ref) {
  final schoolRepository = ref.watch(schoolRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return SchoolController(
    schoolRepository: schoolRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class RefreshController extends StateNotifier<bool> {
  RefreshController() : super(false);

  void refresh() {
    state = !state;
  }
}

final refreshControllerProvider =
    StateNotifierProvider<RefreshController, bool>(
        (ref) => RefreshController());

final notesProvider = StreamProvider.autoDispose.family((ref, String schoolId) {
  ref.watch(refreshControllerProvider);
  if (schoolId.isEmpty) {
    return ref.read(schoolControllerProvider.notifier).getWorldNotes();
  } else {
    return ref.read(schoolControllerProvider.notifier).getSchoolNotes(schoolId);
  }
});

final getSchoolByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(schoolControllerProvider.notifier).getSchoolById(id);
});

final searchSchoolProvider = StreamProvider.family((ref, String query) {
  return ref.watch(schoolControllerProvider.notifier).searchSchool(query);
});

final searchUserProvider = StreamProvider.family((ref, String query) {
  return ref.watch(schoolControllerProvider.notifier).searchUser(query);
});

final searchFollowerProvider = StreamProvider.family((ref, String query) {
  return ref.watch(schoolControllerProvider.notifier).searchFollower(query);
});

final getSchoolNotesProvider = StreamProvider.family((ref, String name) {
  return ref.read(schoolControllerProvider.notifier).getSchoolNotes(name);
});
final getSchoolAppliersProvider = StreamProvider.family((ref, String name) {
  return ref.read(schoolControllerProvider.notifier).getSchoolAppliers(name);
});

final getWorldNotesProvider = StreamProvider((ref) {
  return ref.read(schoolControllerProvider.notifier).getWorldNotes();
});

final getCloseFriendsFeedProvider = FutureProvider.family((ref, int page) {
  return ref
      .read(schoolControllerProvider.notifier)
      .getCloseFriendsFeedProvider(page);
});

final getAllSchoolsProvider = StreamProvider((ref) {
  return ref.watch(schoolControllerProvider.notifier).getAllSchools();
});

class SchoolController extends StateNotifier<bool> {
  final SchoolRepository _schoolRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  SchoolController({
    required SchoolRepository schoolRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _schoolRepository = schoolRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);
  void refreshData(BuildContext context) {
    _ref.read(refreshControllerProvider.notifier).refresh();
  }

  void createSchool(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    School school = School(
      id: name,
      title: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      students: [uid],
      mods: [uid],
    );

    final res = await _schoolRepository.createSchool(school);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'School created successfully!');
      Navigator.of(context).pop();
    });
  }

  void joinSchool(School school, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (school.students.contains(user.uid)) {
      res = await _schoolRepository.leaveSchool(school.id, user.uid);
    } else {
      res = await _schoolRepository.joinSchool(school.id, user.uid);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (school.students.contains(user.uid)) {
        showSnackBar(context, 'School left successfully!');
      } else {
        showSnackBar(context, 'School joined successfully!');
      }
    });
  }

  Stream<List<School>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _schoolRepository.getUserCommunities(uid);
  }

  Stream<School> getSchoolById(String name) {
    return _schoolRepository.getSchoolById(name);
  }

  void editSchool({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required School school,
  }) async {
    state = true;
    if (profileFile != null || profileWebFile != null) {
      // communities/profile/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: school.id,
        file: profileFile,
        // webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => school = school.copyWith(avatar: r),
      );
    }

    if (bannerFile != null || bannerWebFile != null) {
      // communities/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: school.id,
        file: bannerFile,
        // webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => school = school.copyWith(banner: r),
      );
    }

    final res = await _schoolRepository.editSchool(school);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.of(context).pop(),
    );
  }

  Stream<List<School>> searchSchool(String query) {
    return _schoolRepository.searchSchool(query);
  }

  Stream<List<UserModel>> searchUser(String query) {
    return _schoolRepository.searchUser(query);
  }

  Stream<List<UserModel>> searchFollower(String query) {
    final currentUser = _ref.read(userProvider)!;
    return _schoolRepository.searchFollower(query, currentUser);
  }

  void addMods(
      String schoolName, List<String> uids, BuildContext context) async {
    final res = await _schoolRepository.addMods(schoolName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.of(context).pop(),
    );
  }

  void userSchoolAction(String schoolName, String uid, BuildContext context,
      bool isApproved) async {
    final res =
        await _schoolRepository.userSchoolAction(schoolName, uid, isApproved);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Stream<List<Note>> getSchoolNotes(String name) {
    final currentUser = _ref.read(userProvider)!;
    return _schoolRepository.getSchoolNotes(name, currentUser);
  }

  Stream<List<UserModel>> getSchoolAppliers(String name) {
    final currentUser = _ref.read(userProvider)!;
    return _schoolRepository.getSchoolAppliers(name, currentUser);
  }

  Future<List<Note>> getCloseFriendsFeedProvider(int page) {
    UserModel currentUser = _ref.read(userProvider)!;

    // for (var i = 0; i < currentUser.closeFriendsFeedNoteIds.length; i++) {
    //   _ref
    //       .read(noteControllerProvider.notifier)
    //       .getNoteById(currentUser.closeFriendsFeedNoteIds[i]);
    // }

    // _ref.read(userProvider.notifier).update((state) => );
    return _schoolRepository.fetchFromDataSource(currentUser, page, 10);
  }

  Stream<List<Note>> getWorldNotes() {
    final currentUser = _ref.read(userProvider)!;
    return _schoolRepository.getWorldNotes(currentUser);
  }

  Stream<List<School>> getAllSchools() {
    return _schoolRepository.getAllSchools();
  }
}
