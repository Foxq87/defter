import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/failure.dart';
import 'package:acc/core/providers/firebase_providers.dart';
import 'package:acc/core/type_defs.dart';
// import 'package:acc/models/comment_model.dart';
import 'package:acc/models/school_model.dart';
import 'package:acc/models/note_model.dart';


final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _notes =>
      _firestore.collection(FirebaseConstants.notesCollection);
  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Note note) async {
    try {
      return right(_notes.doc(note.id).set(note.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  bool isThread(Note note) {
    bool res = false;
    try {
      _notes.where('repliedTo', isEqualTo: note.id).get().then((value) {
        for (var element in value.docs) {
          if (element.get('uid') == note.id) {
            res = true;
          }
        }
      });
      print(res);
      return res;
    } catch (e) {}
    return true;
  }

  Stream<List<Note>> fetchUserPosts(List<School> schools) {
    return _notes
        .where('schoolName', whereIn: schools.map((e) => e.id).toList())
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

  Stream<List<Note>> fetchGuestPosts() {
    return _notes
        .orderBy('createdAt', descending: true)
        .limit(10)
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

  FutureVoid deleteNote(Note note) async {
    try {
      //delete note
      await _notes.where('id', isEqualTo: note.id).get().then((val) {
        for (var element in val.docs) {
          element.reference.delete();
        }
      });

      //delete replies
      await _notes.where('repliedTo', isEqualTo: note.id).get().then((val) {
        for (var element in val.docs) {
          //delete post
          element.reference.delete();
        }
      });

      //delete notifications
      await _notifications
          .doc(note.uid)
          .collection('userNotifications')
          .where('postId', isEqualTo: note.id)
          .get()
          .then((val) {
        for (var element in val.docs) {
          element.reference.delete();
        }
      });
      return right(_notes.doc(note.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void like(Note note, String userId) async {
    if (note.likes.contains(userId)) {
      _notes.doc(note.id).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _notes.doc(note.id).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Note> getPostById(String postId) {
    return _notes
        .doc(postId)
        .snapshots()
        .map((event) => Note.fromMap(event.data() as Map<String, dynamic>));
  }

  // FutureVoid addComment(Comment comment) async {
  //   try {
  //     await _comments.doc(comment.id).set(comment.toMap());

  //     return right(_posts.doc(comment.postId).update({
  //       'commentCount': FieldValue.increment(1),
  //     }));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  Stream<List<Note>> getCommentsOfPost(String postId) {
    return _notes
        .where('repliedTo', isEqualTo: postId)
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

  FutureVoid awardPost(Note note, String award, String senderId) async {
    try {
      _notes.doc(note.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(_users.doc(note.uid).update({
        'awards': FieldValue.arrayUnion([award]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
