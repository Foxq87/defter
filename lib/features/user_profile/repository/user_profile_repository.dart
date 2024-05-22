import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/type_defs.dart';
import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/note_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _Notes =>
      _firestore.collection(FirebaseConstants.notesCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Note>> getUserNotes(String uid) {
    return _Notes.where('uid', isEqualTo: uid)
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

  Stream<List<UserModel>> getUserFollowers(List<String> followerUids) {
    return Stream.fromIterable(followerUids)
        .asyncMap((uid) async {
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          if (snapshot.exists) {
            final userData = snapshot.data();
            return UserModel.fromMap(userData!);
          } else {
            return null;
          }
        })
        .where((user) => user != null)
        .cast<UserModel>()
        .toList()
        .asStream();
  }

  Stream<List<UserModel>> getUserFollowings(List<String> followingUids) {
    return Stream.fromIterable(followingUids)
        .asyncMap((uid) async {
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          if (snapshot.exists) {
            final userData = snapshot.data();
            return UserModel.fromMap(userData!);
          } else {
            return null;
          }
        })
        .where((user) => user != null)
        .cast<UserModel>()
        .toList()
        .asStream();
  }

  FutureVoid addCloseFriend(
    List<UserModel> users,
    UserModel currentUser,
  ) async {
    void myFunc() {
      for (var i = 0; i < users.length; i++) {
        _users.doc(users[i].uid).get().then((value) {
          if (value.exists) {
            List<dynamic> followers = value.get('ofCloseFriends');
            if (followers.contains(currentUser.uid)) {
              value.reference.update({
                "ofCloseFriends": FieldValue.arrayRemove([currentUser.uid])
              });
            } else {
              value.reference.update({
                "ofCloseFriends": FieldValue.arrayUnion([currentUser.uid])
              });
            }
          }
        });
        _users.doc(currentUser.uid).get().then((value) {
          if (value.exists) {
            List<dynamic> closeFriends = value.get('closeFriends');
            if (closeFriends.contains(users[i].uid)) {
              value.reference.update({
                "closeFriends": FieldValue.arrayRemove([users[i].uid])
              });
            } else {
              value.reference.update({
                "closeFriends": FieldValue.arrayUnion([users[i].uid])
              });
            }
          }
        });
      }
    }

    try {
      return right(myFunc());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid followUser(
    UserModel user,
    UserModel currentUser,
  ) async {
    void myFunc() {
      _users.doc(user.uid).get().then((value) {
        if (value.exists) {
          List<dynamic> followers = value.get('followers');
          if (followers.contains(currentUser.uid)) {
            value.reference.update({
              "followers": FieldValue.arrayRemove([currentUser.uid])
            });
          } else {
            value.reference.update({
              "followers": FieldValue.arrayUnion([currentUser.uid])
            });
          }
        }
      });
      _users.doc(currentUser.uid).get().then((value) {
        if (value.exists) {
          List<dynamic> following = value.get('following');
          if (following.contains(user.uid)) {
            value.reference.update({
              "following": FieldValue.arrayRemove([user.uid])
            });
          } else {
            value.reference.update({
              "following": FieldValue.arrayUnion([user.uid])
            });
          }
        }
      });
    }

    try {
      return right(myFunc());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // FutureVoid updateUserKarma(UserModel user) async {
  //   try {
  //     return right(_users.doc(user.uid).update({
  //       'karma': user.karma,
  //     }));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }
}
