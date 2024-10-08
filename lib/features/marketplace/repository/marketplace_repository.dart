import 'package:acc/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/user_model.dart';

final marketplaceRepositoryProvider = Provider((ref) {
  return MarketplaceRepository(firestore: ref.watch(firestoreProvider));
});

class MarketplaceRepository {
  final FirebaseFirestore _firestore;
  MarketplaceRepository({required FirebaseFirestore firestore})
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

  FutureVoid deleteProduct(ProductModel product) async {
    try {
      return right(_products.doc(product.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // FutureVoid addMods(String schoolName, List<String> uids) async {
  //   try {
  //     return right(_schools.doc(schoolName).update({
  //       'mods': uids,
  //     }));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

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

  Stream<List<ProductModel>> getSchoolProducts(String schoolId) {
    return _products
        .where('approve', isEqualTo: 2)
        .where('schoolId', isEqualTo: schoolId)
        // .orderBy('categorie')
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

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productsCollection);
}
