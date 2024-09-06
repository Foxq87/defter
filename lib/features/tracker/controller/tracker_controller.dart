import 'dart:io';
import 'dart:math';

import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/tracker/repository/tracker_repository.dart';
import 'package:acc/models/test_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/storage_providers.dart';
import '../../../core/utils.dart';
import '../../../models/note_model.dart';
import '../../../models/school_model.dart';
import '../../auth/controller/auth_controller.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final trackerController = ref.watch(trackerControllerProvider.notifier);
  return trackerController.getUserCommunities();
});

final trackerControllerProvider =
    StateNotifierProvider<TrackerController, bool>((ref) {
  final trackerRepository = ref.watch(trackerRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return TrackerController(
    trackerRepository: trackerRepository,
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
    return ref.read(trackerControllerProvider.notifier).getWorldNotes();
  } else {
    return ref
        .read(trackerControllerProvider.notifier)
        .getSchoolNotes(schoolId);
  }
});

final getSchoolByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(trackerControllerProvider.notifier).getSchoolById(id);
});

final searchSchoolProvider = StreamProvider.family((ref, String query) {
  return ref.watch(trackerControllerProvider.notifier).searchSchool(query);
});

final searchUserProvider = StreamProvider.family((ref, String query) {
  return ref.watch(trackerControllerProvider.notifier).searchUser(query);
});

final searchFollowerProvider = StreamProvider.family((ref, String query) {
  return ref.watch(trackerControllerProvider.notifier).searchFollower(query);
});

final getSchoolNotesProvider = StreamProvider.family((ref, String name) {
  return ref.read(trackerControllerProvider.notifier).getSchoolNotes(name);
});
final getSchoolAppliersProvider = StreamProvider.family((ref, String name) {
  return ref.read(trackerControllerProvider.notifier).getSchoolAppliers(name);
});

final getWorldNotesProvider = StreamProvider((ref) {
  return ref.read(trackerControllerProvider.notifier).getWorldNotes();
});

final getCloseFriendsFeedProvider = FutureProvider.family((ref, int page) {
  return ref
      .read(trackerControllerProvider.notifier)
      .getCloseFriendsFeedProvider(page);
});

final getAllSchoolsProvider = StreamProvider((ref) {
  return ref.watch(trackerControllerProvider.notifier).getAllSchools();
});

class TrackerController extends StateNotifier<bool> {
  final TrackerRepository _trackerRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  TrackerController({
    required TrackerRepository trackerRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _trackerRepository = trackerRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);
  void refreshData(BuildContext context) {
    _ref.read(refreshControllerProvider.notifier).refresh();
  }

  void addTest(String uid, String lesson, int correct, int wrong, int empty,
      BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    TestModel test = TestModel(
      uid: uid,
      testId: Uuid().v4(),
      createdAt: DateTime.now(),
      lesson: lesson,
      correct: correct,
      wrong: wrong,
      empty: empty,
      net: correct - (1.25 * wrong),
    );

    final res = await _trackerRepository.addtest(test);
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
      res = await _trackerRepository.leaveSchool(school.id, user.uid);
    } else {
      res = await _trackerRepository.joinSchool(school.id, user.uid);
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
    return _trackerRepository.getUserCommunities(uid);
  }

  Stream<School> getSchoolById(String name) {
    return _trackerRepository.getSchoolById(name);
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

    final res = await _trackerRepository.editSchool(school);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.of(context).pop(),
    );
  }

  Stream<List<School>> searchSchool(String query) {
    return _trackerRepository.searchSchool(query);
  }

  Stream<List<UserModel>> searchUser(String query) {
    return _trackerRepository.searchUser(query);
  }

  Stream<List<UserModel>> searchFollower(String query) {
    final currentUser = _ref.read(userProvider)!;
    return _trackerRepository.searchFollower(query, currentUser);
  }

  void addMods(
      String schoolName, List<String> uids, BuildContext context) async {
    final res = await _trackerRepository.addMods(schoolName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.of(context).pop(),
    );
  }

  void userSchoolAction(String schoolName, String uid, BuildContext context,
      bool isApproved) async {
    final res =
        await _trackerRepository.userSchoolAction(schoolName, uid, isApproved);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Stream<List<Note>> getSchoolNotes(String name) {
    final currentUser = _ref.read(userProvider)!;
    return _trackerRepository.getSchoolNotes(name, currentUser);
  }

  Stream<List<UserModel>> getSchoolAppliers(String name) {
    final currentUser = _ref.read(userProvider)!;
    return _trackerRepository.getSchoolAppliers(name, currentUser);
  }

  Future<List<Note>> getCloseFriendsFeedProvider(int page) {
    UserModel currentUser = _ref.read(userProvider)!;

    // for (var i = 0; i < currentUser.closeFriendsFeedNoteIds.length; i++) {
    //   _ref
    //       .read(noteControllerProvider.notifier)
    //       .getNoteById(currentUser.closeFriendsFeedNoteIds[i]);
    // }

    // _ref.read(userProvider.notifier).update((state) => );
    return _trackerRepository.fetchFromDataSource(currentUser, page, 10);
  }

  Stream<List<Note>> getWorldNotes() {
    final currentUser = _ref.read(userProvider)!;
    return _trackerRepository.getWorldNotes(currentUser);
  }

  Stream<List<School>> getAllSchools() {
    return _trackerRepository.getAllSchools();
  }
}
