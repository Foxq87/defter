import 'dart:io';

import 'package:acc/core/utils.dart';
import 'package:acc/features/updates/repository/update_repository.dart';
import 'package:acc/models/update_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_providers.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';

final updateControllerProvider =
    StateNotifierProvider<UpdateController, bool>((ref) {
  final updateRepository = ref.watch(updateRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UpdateController(
    updateRepository: updateRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

// final getSchoolByIdProvider = StreamProvider.family((ref, String id) {
//   return ref.watch(schoolControllerProvider.notifier).getSchoolById(id);
// });

// final searchSchoolProvider = StreamProvider.family((ref, String query) {
//   return ref.watch(schoolControllerProvider.notifier).searchSchool(query);
// });

// final searchUserProvider = StreamProvider.family((ref, String query) {
//   return ref.watch(schoolControllerProvider.notifier).searchUser(query);
// });

final getUpdatesProvider = StreamProvider((ref) {
  return ref.read(updateControllerProvider.notifier).getUpdates();
});

// final getWorldNotesProvider = StreamProvider.family((ref, String name) {
//   return ref.read(schoolControllerProvider.notifier).getWorldPosts(name);
// });

// final getAllSchoolsProvider = StreamProvider((ref) {
//   return ref.watch(schoolControllerProvider.notifier).getAllSchools();
// });

class UpdateController extends StateNotifier<bool> {
  final UpdateRepository _updateRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UpdateController({
    required UpdateRepository updateRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _updateRepository = updateRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareUpdate(UserModel currentUser, String title, String description,
      List<File> imageFiles, BuildContext context) async {
    state = true;
    // Remove the unused variable 'errorCounter'
    int errorCounter = 0;
    List<String> imageLinks = [];
    Either imageRes;
    String updateId = const Uuid().v4();
    final uid = _ref.read(userProvider)?.uid ?? '';
    for (int i = 0; i < imageFiles.length; i++) {
      var file = imageFiles[i];
      String imageId = const Uuid().v4();

      imageRes = await _storageRepository.storeFile(
        path: 'updates/$uid/$updateId',
        id: imageId,
        file: await compressImage(updateId, file, i),
      );

      imageRes.fold((l) => showSnackBar(context, l.message), (r) {
        imageLinks.add(r);
        errorCounter++;
      });
      print(imageLinks);
    }
    Update update = Update(
      id: Uuid().v4(),
      uid: currentUser.uid,
      title: title,
      description: description,
      imageLinks: imageLinks,
      creation: DateTime.now(),
    );

    final res = await _updateRepository.shareUpdate(update);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'yenilik başarıyla paylaşıldı');
      Routemaster.of(context).pop();
    });
  }

  void deleteUpdate(Update update, BuildContext context) async {
    try {
      await _updateRepository.deleteUpdate(update);
      if (update.imageLinks.isNotEmpty) {
        final res = await _storageRepository.deleteUpdateImages(update: update);
        res.fold((l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, 'yenilik başarıyla silindi'));
      }
    } catch (e) {
      showSnackBar(context, 'hata oluştu, lütfen daha sonra tekrar deneyin');
    }
  }

  // void createSchool(String name, BuildContext context) async {
  //   state = true;
  //   final uid = _ref.read(userProvider)?.uid ?? '';
  //   School school = School(
  //     id: name,
  //     title: name,
  //     banner: Constants.bannerDefault,
  //     avatar: Constants.avatarDefault,
  //     students: [uid],
  //     mods: [uid],
  //   );

  //   final res = await _updateRepository.createSchool(school);
  //   state = false;
  //   res.fold((l) => showSnackBar(context, l.message), (r) {
  //     showSnackBar(context, 'School created successfully!');
  //     Routemaster.of(context).pop();
  //   });
  // }

  // void joinSchool(School school, BuildContext context) async {
  //   final user = _ref.read(userProvider)!;

  //   Either<Failure, void> res;
  //   if (school.students.contains(user.uid)) {
  //     res = await _updateRepository.leaveSchool(school.id, user.uid);
  //   } else {
  //     res = await _updateRepository.joinSchool(school.id, user.uid);
  //   }

  //   res.fold((l) => showSnackBar(context, l.message), (r) {
  //     if (school.students.contains(user.uid)) {
  //       showSnackBar(context, 'School left successfully!');
  //     } else {
  //       showSnackBar(context, 'School joined successfully!');
  //     }
  //   });
  // }

  // Stream<List<School>> getUserCommunities() {
  //   final uid = _ref.read(userProvider)!.uid;
  //   return _updateRepository.getUserCommunities(uid);
  // }

  // Stream<School> getSchoolById(String name) {
  //   return _updateRepository.getSchoolById(name);
  // }

  // void editSchool({
  //   required File? profileFile,
  //   required File? bannerFile,
  //   required Uint8List? profileWebFile,
  //   required Uint8List? bannerWebFile,
  //   required BuildContext context,
  //   required School school,
  // }) async {
  //   state = true;
  //   if (profileFile != null || profileWebFile != null) {
  //     // communities/profile/memes
  //     final res = await _storageRepository.storeFile(
  //       path: 'communities/profile',
  //       id: school.id,
  //       file: profileFile,
  //       // webFile: profileWebFile,
  //     );
  //     res.fold(
  //       (l) => showSnackBar(context, l.message),
  //       (r) => school = school.copyWith(avatar: r),
  //     );
  //   }

  //   if (bannerFile != null || bannerWebFile != null) {
  //     // communities/banner/memes
  //     final res = await _storageRepository.storeFile(
  //       path: 'communities/banner',
  //       id: school.id,
  //       file: bannerFile,
  //       // webFile: bannerWebFile,
  //     );
  //     res.fold(
  //       (l) => showSnackBar(context, l.message),
  //       (r) => school = school.copyWith(banner: r),
  //     );
  //   }

  //   final res = await _updateRepository.editSchool(school);
  //   state = false;
  //   res.fold(
  //     (l) => showSnackBar(context, l.message),
  //     (r) => Routemaster.of(context).pop(),
  //   );
  // }

  // Stream<List<School>> searchSchool(String query) {
  //   return _updateRepository.searchSchool(query);
  // }

  // Stream<List<UserModel>> searchUser(String query) {
  //   return _updateRepository.searchUser(query);
  // }

  // void addMods(
  //     String schoolName, List<String> uids, BuildContext context) async {
  //   final res = await _updateRepository.addMods(schoolName, uids);
  //   res.fold(
  //     (l) => showSnackBar(context, l.message),
  //     (r) => Routemaster.of(context).pop(),
  //   );
  // }

  Stream<List<Update>> getUpdates() {
    return _updateRepository.getUpdates();
  }

  // Stream<List<Note>> getWorldPosts(String name) {
  //   return _updateRepository.getWorldPosts(name);
  // }

  // Stream<List<School>> getAllSchools() {
  //   return _updateRepository.getAllSchools();
  // }
}
