import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/school_model.dart';

final schoolRepositoryProvider = Provider((ref) {
  return SchoolRepository(firestore: ref.watch(firestoreProvider));
});

class SchoolRepository {
  final FirebaseFirestore _firestore;
  SchoolRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createSchool(School school) async {
    try {
      var schoolDoc = await _schools.doc(school.id).get();
      if (schoolDoc.exists) {
        throw 'School with the same name already exists!';
      }

      return right(_schools.doc(school.id).set(school.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinSchool(String schoolName, String userId) async {
    try {
      return right(_schools.doc(schoolName).update({
        'members': FieldValue.arrayUnion([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveSchool(String schoolName, String userId) async {
    try {
      return right(_schools.doc(schoolName).update({
        'members': FieldValue.arrayRemove([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<School>> getUserCommunities(String uid) {
    return _schools
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<School> communities = [];
      for (var doc in event.docs) {
        communities.add(School.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<School> getSchoolById(String id) {
    return _schools
        .doc(id)
        .snapshots()
        .map((event) => School.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editSchool(School school) async {
    try {
      return right(_schools.doc(school.id).update(school.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<School>> searchSchool(String query) {
    return _schools
        .where(
          'title',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<School> schools = [];
      for (var school in event.docs) {
        schools.add(School.fromMap(school.data() as Map<String, dynamic>));
      }
      return schools;
    });
  }

  Stream<List<UserModel>> searchUser(String query) {
    return _users
        .where(
          'username',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var user in event.docs) {
        users.add(UserModel.fromMap(user.data() as Map<String, dynamic>));
      }
      return users;
    });
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

  // Stream<List<Post>> getSchoolPosts(String name) {
  //   return _posts.where('schoolName', isEqualTo: name).orderBy('createdAt', descending: true).snapshots().map(
  //         (event) => event.docs
  //             .map(
  //               (e) => Post.fromMap(
  //                 e.data() as Map<String, dynamic>,
  //               ),
  //             )
  //             .toList(),
  //       );
  // }

  // CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _schools =>
      _firestore.collection(FirebaseConstants.schoolsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
