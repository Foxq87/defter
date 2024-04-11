import 'dart:io';
import 'package:acc/models/note_model.dart';
import 'package:acc/models/update_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '/core/failure.dart';
import 'firebase_providers.dart';
import '/core/type_defs.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
    // required Uint8List? webFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;

      // if (kIsWeb) {
      //   uploadTask = ref.putData(webFile!);
      // } else {
      uploadTask = ref.putFile(file!);
      // }

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> deletePostImages({required Note note}) async {
    try {
      return right(await _firebaseStorage
          .ref()
          .child('posts/${note.schoolName}/${note.id}')
          .listAll()
          .then((value) {
        for (var element in value.items) {
          element.delete();
        }
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> deleteUpdateImages({
    required Update update,
  }) async {
    try {
      return right(await _firebaseStorage
          .ref()
          .child('updates/${update.uid}/${update.id}')
          .listAll()
          .then((value) {
        for (var element in value.items) {
          element.delete();
        }
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
