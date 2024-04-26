import 'dart:io';

import 'package:acc/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:routemaster/routemaster.dart';

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

final getSchoolByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(schoolControllerProvider.notifier).getSchoolById(id);
});

final searchSchoolProvider = StreamProvider.family((ref, String query) {
  return ref.watch(schoolControllerProvider.notifier).searchSchool(query);
});

final searchUserProvider = StreamProvider.family((ref, String query) {
  return ref.watch(schoolControllerProvider.notifier).searchUser(query);
});

final getSchoolNotesProvider = StreamProvider.family((ref, String name) {
  return ref.read(schoolControllerProvider.notifier).getSchoolNotes(name);
});

final getWorldNotesProvider = StreamProvider.family((ref, String name) {
  return ref.read(schoolControllerProvider.notifier).getWorldNotes(name);
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
      Routemaster.of(context).pop();
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
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<School>> searchSchool(String query) {
    return _schoolRepository.searchSchool(query);
  }

  Stream<List<UserModel>> searchUser(String query) {
    return _schoolRepository.searchUser(query);
  }

  void addMods(
      String schoolName, List<String> uids, BuildContext context) async {
    final res = await _schoolRepository.addMods(schoolName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Note>> getSchoolNotes(String name) {
    return _schoolRepository.getSchoolNotes(name);
  }

  Stream<List<Note>> getWorldNotes(String name) {
    return _schoolRepository.getWorldNotes(name);
  }

  Stream<List<School>> getAllSchools() {
    return _schoolRepository.getAllSchools();
  }
}
