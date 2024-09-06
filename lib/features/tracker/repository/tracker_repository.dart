import 'package:acc/models/test_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/note_model.dart';
import '../../../models/school_model.dart';

final trackerRepositoryProvider = Provider((ref) {
  return TrackerRepository(firestore: ref.watch(firestoreProvider));
});

class TrackerRepository {
  final FirebaseFirestore _firestore;
  TrackerRepository({required FirebaseFirestore firestore})
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

  FutureVoid addtest(TestModel test) async {
    try {
      return right(_tests.doc(test.testId).set(test.toMap()));
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
    if (id.contains('onay bekliyor:')) {
      String schoolId = id.replaceAll('onay bekliyor: ', '');
      print("testing school id : " + schoolId);
      return _schools
          .doc(schoolId)
          .snapshots()
          .map((event) => School.fromMap(event.data() as Map<String, dynamic>));
    } else {
      return _schools
          .doc(id)
          .snapshots()
          .map((event) => School.fromMap(event.data() as Map<String, dynamic>));
    }
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

  Stream<List<UserModel>> searchFollower(String query, UserModel currentUser) {
    return _users
        .where('followers', arrayContains: currentUser.uid)
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
        .map(
          (event) => event.docs
              .map(
                (e) => UserModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
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

  FutureVoid userSchoolAction(
      String schoolName, String uid, bool isApproved) async {
    try {
      return right(_users.doc(uid).update({
        'schoolId': isApproved ? schoolName : '',
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Note>> getSchoolNotes(
    String name,
    UserModel currentUser,
  ) {
    print(currentUser.blockedAccountIds);
    return _notes
        .where('schoolName', isEqualTo: name)
        .where('repliedTo', isEqualTo: '')
        .where('uid',
            whereNotIn: currentUser.blockedAccountIds.isNotEmpty
                ? currentUser.blockedAccountIds
                : [''])
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

  Stream<List<UserModel>> getSchoolAppliers(
    String schoolId,
    UserModel currentUser,
  ) {
    print(currentUser.blockedAccountIds);
    return _users
        .where('schoolId', isNotEqualTo: '')
        .where('schoolId', isGreaterThanOrEqualTo: 'onay bekliyor: $schoolId')
        .where('schoolId', isLessThan: 'onay bekliyor: $schoolId' + 'z')
        .orderBy('creation', descending: false)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => UserModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Future<List<Note>> fetchFromDataSource(
      UserModel currentUser, int page, int postsPerPage) async {
    List<Note> combinedNotes = [];
    List<QueryDocumentSnapshot> lastDocuments = [];
    DocumentSnapshot? lastDocument; // Keep track of the last document

    // Assuming currentUser.ofCloseFriends is available and _notes is a reference to the Firestore collection
    List<String> closeFriendOf = currentUser.ofCloseFriends;
    if (!closeFriendOf.contains(currentUser.uid)) {
      closeFriendOf.add(currentUser.uid);
    }

    for (var friendId in closeFriendOf) {
      Query query = FirebaseFirestore.instance
          .collection('posts')
          .where('schoolName', isEqualTo: "closeFriends-$friendId")
          .where('repliedTo', isEqualTo: "")
          .orderBy('timestamp', descending: true)
          .limit(postsPerPage);

      // Use lastDocument for pagination if available
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      // Convert documents to Note objects
      List<Note> newPosts = querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      combinedNotes.addAll(newPosts);

      // Update lastDocument for pagination
      if (querySnapshot.docs.isNotEmpty) {
        lastDocuments.add(querySnapshot.docs.last);
      }
    }

    // Update lastDocument with the last of the fetched documents, if needed
    if (lastDocuments.isNotEmpty) {
      lastDocument = lastDocuments
          .last; // Assuming you have a way to determine which document to use for next pagination
    }

    return combinedNotes;
  }

  Stream<List<Note>> getWorldNotes(UserModel currentUser) {
    return _notes
        .where('schoolName', isEqualTo: "")
        .where('repliedTo', isEqualTo: '')
        .where('uid',
            whereNotIn: currentUser.blockedAccountIds.isNotEmpty
                ? currentUser.blockedAccountIds
                : [''])
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

  CollectionReference get _tests =>
      _firestore.collection(FirebaseConstants.testsCollection);

  CollectionReference get _notes =>
      _firestore.collection(FirebaseConstants.notesCollection);
  CollectionReference get _schools =>
      _firestore.collection(FirebaseConstants.schoolsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
