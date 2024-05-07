import 'package:acc/models/bookmark_model.dart';
import 'package:acc/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/note_model.dart';
import '../../../models/update_model.dart';
import '../../../models/user_model.dart';

final bookmarkRepositoryProvider = Provider((ref) {
  return BookmarkRepository(firestore: ref.watch(firestoreProvider));
});

class BookmarkRepository {
  final FirebaseFirestore _firestore;
  BookmarkRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid uploadProduct(ProductModel product, UserModel vendor) async {
    try {
      return right(_products.doc(product.id).set(product.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteUpdate(Update update) async {
    try {
      return right(_updates.doc(update.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String schoolName, List<String> uids) async {
    try {
      return right(_schools.doc(schoolName).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void bookmarkNote(Note note, String userId) async {
    try {
      if (note.bookmarks.contains(userId)) {
        _notes.doc(note.id).update({
          'bookmarks': FieldValue.arrayRemove([userId]),
        });
      } else {
        _notes.doc(note.id).update({
          'bookmarks': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void bookmarkProduct(ProductModel product, String userId) async {
    try {
      if (product.bookmarks.contains(userId)) {
        _products.doc(product.id).update({
          'bookmarks': FieldValue.arrayRemove([userId]),
        });
      } else {
        _products.doc(product.id).update({
          'bookmarks': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<ProductModel> getProductById(
    String productId,
  ) {
    return _products.doc(productId).snapshots().map(
        (event) => ProductModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<ProductModel>> getSchoolsProductApplications(String schoolId) {
    return _products
        .where('schoolId', isEqualTo: schoolId)
        .where('approve', isEqualTo: 1)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => ProductModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Note>> getBookmarkedNotesProvider(String uid) {
    return _notes
        .where('bookmarks', arrayContains: uid)
        .orderBy('createdAt', descending: true)
        // .limit(15)
        // .where('schoolId', isEqualTo: schoolId)
        // .where('categorie', isEqualTo: prototype.categorie)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Note.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<ProductModel>> getBookmarkedProductsProvider(String uid) {
    return _products
        .where('approve', isEqualTo: 2)
        .where('bookmarks', arrayContains: uid)
        .orderBy('createdAt', descending: true)
        // .limit(15)
        // .where('schoolId', isEqualTo: schoolId)
        // .where('categorie', isEqualTo: prototype.categorie)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => ProductModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  // Stream<List<ProductModel>> getProductById(String name) {
  //   return _Notes.where('schoolName', isEqualTo: "")
  //       .where('repliedTo', isEqualTo: '')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (event) => event.docs
  //             .map(
  //               (e) => ProductModel.fromMap(
  //                 e.data() as Map<String, dynamic>,
  //               ),
  //             )
  //             .toList(),
  //       );
  // }

  CollectionReference get _notes =>
      _firestore.collection(FirebaseConstants.notesCollection);
  CollectionReference get _schools =>
      _firestore.collection(FirebaseConstants.schoolsCollection);
  CollectionReference get _updates =>
      _firestore.collection(FirebaseConstants.updatesCollection);
  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
