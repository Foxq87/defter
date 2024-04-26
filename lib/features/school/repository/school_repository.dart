import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/note_model.dart';
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
          'title_insensitive',
          isGreaterThanOrEqualTo: query.toLowerCase(),
          isLessThan: query.isEmpty
              ? null
              : query
                      .toLowerCase()
                      .substring(0, query.toLowerCase().length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.toLowerCase().length - 1) + 1,
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
        .orderBy('username_insensitive', descending: false)
        .startAt([query])
        .endAt([query + '\uf8ff'])
        // .where(
        //   'username',
        //   isGreaterThanOrEqualTo: query,
        // )
        // .where('username', isLessThan: query + 'z')
        // isLessThan: query.isEmpty
        //     ? null
        //     : query.toUpperCase().substring(0, query.length - 1) +
        //         String.fromCharCode(
        //           query.codeUnitAt(query.length - 1) + 1,
        //         ),

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

  Stream<List<Note>> getSchoolNotes(
    String name,
  ) {
    return _Notes.where('schoolName', isEqualTo: name)
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

  Stream<List<School>> getAllSchools() {
    return _schools.snapshots().map(
          (event) => event.docs
              .map(
                (e) => School.fromMap(
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
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
