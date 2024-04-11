import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/failure.dart';
import 'package:acc/core/providers/firebase_providers.dart';
import 'package:acc/core/type_defs.dart';
// import 'package:acc/models/comment_model.dart';
import 'package:acc/models/school_model.dart';
import 'package:acc/models/notification_model.dart';

final notificationRepositoryProvider = Provider((ref) {
  return NotificationRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);
  // CollectionReference get _comments =>
  //     _firestore.collection(FirebaseConstants.commentsCollection);
  // CollectionReference get _users =>
  //     _firestore.collection(FirebaseConstants.usersCollection);

  Stream<List<NotificationModel>> fetchUserNotifications(List<School> schools) {
    return _notifications
        .where('schoolName', whereIn: schools.map((e) => e.id).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => NotificationModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deleteNotification(NotificationModel notification) async {
    try {
      return right(_notifications
          .doc(notification.receiverUid)
          .collection('userNotifications')
          .doc(notification.id)
          .delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid sendNotification(NotificationModel notification) async {
    try {
      return right(_notifications
          .doc(notification.receiverUid)
          .collection('userNotifications')
          .doc(notification.id)
          .set(notification.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<NotificationModel>> getUserNotifications(String uid) {
    return _notifications
        .doc(uid)
        .collection('userNotifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => NotificationModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
