import 'dart:async';

import 'package:acc/core/providers/storage_providers.dart';
import 'package:acc/features/bookmarks/repository/bookmark_repository.dart';
import 'package:acc/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/product_model.dart';
import '../../auth/controller/auth_controller.dart';

final bookmarkControllerProvider =
    StateNotifierProvider<BookmarkController, bool>((ref) {
  final bookmarkRepository = ref.watch(bookmarkRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return BookmarkController(
    bookmarkRepository: bookmarkRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getBookmarkedNotesProvider = StreamProvider.family((ref, String uid) {
  return ref
      .read(bookmarkControllerProvider.notifier)
      .getBookmarkedNotesProvider(uid);
});
final getBookmarkedProductsProvider = StreamProvider.family((ref, String uid) {
  return ref
      .read(bookmarkControllerProvider.notifier)
      .getBookmarkedProductsProvider(uid);
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

// final getProductByIdProvider = StreamProvider.family((ref, String productId) {
//   final marketplaceController =
//       ref.watch(bookmarkControllerProvider.notifier);
//   return marketplaceController.getProductById(productId);
// });

// final getUpdatesProvider = StreamProvider((ref) {
//   return ref.read(marketplaceControllerProvider.notifier).getUpdates();
// });
// final getProductApplications = StreamProvider.family((ref, String schoolId) {
//   return ref
//       .read(bookmarkControllerProvider.notifier)
//       .getSchoolsProductApplications(schoolId);
// });

// final getWorldNotesProvider = StreamProvider.family((ref, String name) {
//   return ref.read(schoolControllerProvider.notifier).getWorldNotes(name);
// });

// final getAllSchoolsProvider = StreamProvider((ref) {
//   return ref.watch(schoolControllerProvider.notifier).getAllSchools();
// });

class BookmarkController extends StateNotifier<bool> {
  final BookmarkRepository _bookmarkRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  BookmarkController({
    required BookmarkRepository bookmarkRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _bookmarkRepository = bookmarkRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void bookmarkNote(Note note, BuildContext context) async {
    final currentUser = _ref.read(userProvider)!;
    _bookmarkRepository.bookmarkNote(note, currentUser.uid);
  }

  void bookmarkProduct(ProductModel product, BuildContext context) async {
    final currentUser = _ref.read(userProvider)!;
    _bookmarkRepository.bookmarkProduct(product, currentUser.uid);
  }

  // void sendProductToApproval({
  //   required UserModel vendor,
  //   required String title,
  //   required double price,
  //   required int stock,
  //   required String description,
  //   required String categorie,
  //   required String subcategorie,
  //   required List<File> imageFiles,
  //   required BuildContext context,
  // }) async {
  //   state = true;
  //   int errorCounter = 0;
  //   List<String> imageLinks = [];
  //   Either imageRes;
  //   String productId = const Uuid().v4();
  //   final uid = _ref.read(userProvider)?.uid ?? '';
  //   for (int i = 0; i < imageFiles.length; i++) {
  //     var file = imageFiles[i];
  //     String imageId = const Uuid().v4();

  //     imageRes = await _storageRepository.storeFile(
  //       path: 'products/${vendor.schoolId}/$uid/$productId',
  //       id: imageId,
  //       file: file,
  //     );

  //     imageRes.fold((l) => showSnackBar(context, l.message), (r) {
  //       imageLinks.add(r);
  //       errorCounter++;
  //     });
  //     print(imageLinks);
  //   }
  //   ProductModel product = ProductModel(
  //     id: productId,
  //     uid: vendor.uid,
  //     title: title,
  //     schoolId: vendor.schoolId,
  //     price: price,
  //     stock: stock,
  //     categorie: categorie,
  //     subcategorie: subcategorie,
  //     approve: 1,
  //     description: description,
  //     images: imageLinks,
  //     createdAt: DateTime.now(),
  //   );

  //   final res = await _marketplaceRepository.uploadProduct(product, vendor);
  //   state = false;
  // res.fold((l) => showSnackBar(context, l.message), (r) {
  //   showSnackBar(context, 'ürün onaya gönderildi, sonucu sana bildireceğiz.');
  //   Navigator.of(context).pop();
  // });
  // }

  // void deleteUpdate(Update update, BuildContext context) async {
  //   try {
  //     await _marketplaceRepository.deleteUpdate(update);
  //     if (update.imageLinks.isNotEmpty) {
  //       final res = await _storageRepository.deleteUpdateImages(update: update);
  //       res.fold((l) => showSnackBar(context, l.message),
  //           (r) => showSnackBar(context, 'yenilik başarıyla silindi'));
  //     }
  //   } catch (e) {
  //     showSnackBar(context, 'hata oluştu, lütfen daha sonra tekrar deneyin');
  //   }
  // }

  // void approveProduct({
  //   required UserModel vendor,
  //   required String productId,
  //   required String title,
  //   required double price,
  //   required int stock,
  //   required String description,
  //   required String categorie,
  //   required String subcategorie,
  //   required List<String> imageLinks,
  //   required DateTime createdAt,
  //   required BuildContext context,
  // }) async {
  //   state = true;

  //   ProductModel product = ProductModel(
  //     id: productId,
  //     uid: vendor.uid,
  //     title: title,
  //     schoolId: vendor.schoolId,
  //     price: price,
  //     stock: stock,
  //     categorie: categorie,
  //     subcategorie: subcategorie,
  //     approve: 2,
  //     description: description,
  //     images: imageLinks,
  //     createdAt: createdAt,
  //   );

  //   final res = await _marketplaceRepository.uploadProduct(product, vendor);
  //   _ref.read(notificationControllerProvider.notifier).sendNotification(
  //         context: context,
  //         content: "${categorie} ürünün onaylandı ve satışa hazır!",
  //         type: "product-approval",
  //         id: productId + 'approval',
  //         productId: productId,
  //         receiverUid: vendor.uid,
  //         senderId: Constants.systemUid,
  //       );
  //   state = false;
  //   res.fold((l) => showSnackBar(context, l.message), (r) {
  //     showSnackBar(context, 'ürün onaylandı.');
  //   });
  // }

  // Stream<ProductModel> getProductById(String productId) {
  //   return _marketplaceRepository.getProductById(productId);
  // }

  // Stream<List<ProductModel>> getSchoolsProductApplications(String schoolId) {
  //   return _marketplaceRepository.getSchoolsProductApplications(schoolId);
  // }
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
  //     Navigator.of(context).pop();
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
  //     (r) => Navigator.of(context).pop(),
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
  //     (r) => Navigator.of(context).pop(),
  //   );
  // }

  Stream<List<Note>> getBookmarkedNotesProvider(String uid) {
    return _bookmarkRepository.getBookmarkedNotesProvider(uid);
  }

  Stream<List<ProductModel>> getBookmarkedProductsProvider(String uid) {
    return _bookmarkRepository.getBookmarkedProductsProvider(uid);
  }

  // Stream<List<Note>> getWorldNotes(String name) {
  //   return _updateRepository.getWorldNotes(name);
  // }

  // Stream<List<School>> getAllSchools() {
  //   return _updateRepository.getAllSchools();
  // }
}
