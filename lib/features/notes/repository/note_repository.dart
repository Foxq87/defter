import 'package:acc/models/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/failure.dart';
import 'package:acc/core/providers/firebase_providers.dart';
import 'package:acc/core/type_defs.dart';
import 'package:acc/models/school_model.dart';
import 'package:acc/models/note_model.dart';

import '../../../models/user_model.dart';

final noteRepositoryProvider = Provider((ref) {
  return NoteRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class NoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _notes =>
      _firestore.collection(FirebaseConstants.notesCollection);
  CollectionReference get _reports =>
      _firestore.collection(FirebaseConstants.reportsCollection);
  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addNote(Note note, UserModel currentUser) async {
    try {
      currentUser.closeFriends.add(currentUser.uid);
      if (note.schoolName.contains('closeFriends-')) {
        print("close-friend-note");
        for (var i = 0; i < currentUser.closeFriends.length; i++) {
          FirebaseFirestore.instance
              .collection('users')
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              doc.reference.update({
                'closeFriendsFeedNoteIds': FieldValue.arrayUnion([note.id]),
              });
            });
          });
        }
      }
      return right(_notes.doc(note.id).set(note.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addReport(Report report) async {
    try {
      return right(_reports
          .doc(report.accountId.isEmpty
              ? report.uid + report.noteId
              : report.uid + report.accountId)
          .set(report.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Note>> threads(String noteId, String uid) {
    try {
   
      return _notes
          .where("repliedTo", isEqualTo: noteId)
          .where("uid", isEqualTo: uid)
          .snapshots()
          .map((event) => event.docs
              .map(
                (e) => Note.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList());
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  Stream<List<Note>> fetchUserNotes(List<School> schools) {
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

  Stream<List<Note>> fetchGuestNotes() {
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

  FutureVoid deleteNote(Note note, String currentUid) async {
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
          //delete note
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
      await _notifications
          .doc(currentUid)
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
    try {
      if (note.likes.contains(userId)) {
        _notes.doc(note.id).update({
          'likes': FieldValue.arrayRemove([userId]),
        });
      } else {
        _notes.doc(note.id).update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<Note> getNoteById(String noteId) {
    return _notes
        .doc(noteId)
        .snapshots()
        .map((event) => Note.fromMap(event.data() as Map<String, dynamic>));
  }

  // FutureVoid addComment(Comment comment) async {
  //   try {
  //     await _comments.doc(comment.id).set(comment.toMap());

  //     return right(_notes.doc(comment.noteId).update({
  //       'commentCount': FieldValue.increment(1),
  //     }));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  Stream<List<Note>> getCommentsOfNote(String noteId) {
    return _notes
        .where('repliedTo', isEqualTo: noteId)
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

  Stream<List<UserModel>> getNoteLikers(List<String> likerUids) {
    return Stream.fromIterable(likerUids)
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

  FutureVoid awardNote(Note note, String award, String senderId) async {
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
