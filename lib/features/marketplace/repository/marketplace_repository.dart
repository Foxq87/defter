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

final updateRepositoryProvider = Provider((ref) {
  return UpdateRepository(firestore: ref.watch(firestoreProvider));
});

class UpdateRepository {
  final FirebaseFirestore _firestore;
  UpdateRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid sendProductToApproval(
      ProductModel product, UserModel vendor) async {
    try {
      return right(_products
          .doc(vendor.schoolId)
          .collection('schoolProducts')
          .doc(product.id)
          .set(product.toMap()));
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

  Stream<List<ProductModel>> getProductApplications(String schoolId) {
    return _products
        .doc(schoolId)
        .collection('schoolProducts')
        .where('approve', isEqualTo: 1)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => ProductModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Update>> getUpdates() {
    return _updates.orderBy('creation', descending: true).snapshots().map(
          (event) => event.docs
              .map(
                (e) => Update.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Note>> getWorldNotes(String name) {
    return _Notes.where('schoolName', isEqualTo: "")
        .where('repliedTo', isEqualTo: '')
        .orderBy('createdAt', descending: true)
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

  CollectionReference get _Notes =>
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
