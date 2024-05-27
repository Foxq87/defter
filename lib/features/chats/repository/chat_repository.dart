import 'package:acc/models/chat_model.dart';
import 'package:acc/models/message_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/core/failure.dart';
import 'package:acc/core/providers/firebase_providers.dart';
import 'package:acc/core/type_defs.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _chats =>
      _firestore.collection(FirebaseConstants.chatsCollection);
  // CollectionReference get _comments =>
  //     _firestore.collection(FirebaseConstants.commentsCollection);
  // CollectionReference get _users =>
  //     _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid startChat(ChatModel chat) async {
    try {
      return right(_chats.doc(chat.id).set(chat.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid sendMessage(MessageModel message, String username) async {
    try {
      print(message.chatId);
      await _chats.doc(message.chatId).update({
        'latest': "@$username: " + message.text,
        "lastEditedAt": DateTime.now().millisecondsSinceEpoch,
      });
      return right(_chats
          .doc(message.chatId)
          .collection('chatContent')
          .doc(message.id)
          .set(message.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteMessage(MessageModel message) async {
    try {
      print(message.chatId);

      return right(_chats
          .doc(message.chatId)
          .collection('chatContent')
          .doc(message.id)
          .delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid reactMessage(
      MessageModel message, UserModel currentUser, String reaction) async {
    try {
      bool userReacted = false;
      String databaseReaction = '';
      print(message.chatId);
      if (reaction.isEmpty) //remove reaction
      {}
      await _chats.doc(message.chatId).update({
        'latest': reaction.isEmpty
            ? "@${currentUser.username} " + "ifadesini geri aldı"
            : "@${currentUser.username} " + "'$reaction' ifadesini bıraktı",
        "lastEditedAt": DateTime.now().millisecondsSinceEpoch,
      });

      return right(_chats
          .doc(message.chatId)
          .collection('chatContent')
          .doc(message.id)
          .get()
          .then((val) {
        List<dynamic> reactions = val.get('reactions');
        reactions.forEach((element) {
          String uid = element['uid']!;
          if (uid == currentUser.uid) {
            userReacted = true;

            if (reaction.isEmpty) {
              val.reference.update({
                "reactions": FieldValue.arrayRemove([
                  {"reaction": element['reaction'], "uid": currentUser.uid}
                ])
              });
            } else {
              element['reaction'] = reaction;
              val.reference.update({"reactions": reactions});
            }
          }
        });
        if (!userReacted) {
          val.reference.update({
            "reactions": FieldValue.arrayUnion([
              {"reaction": reaction, "uid": currentUser.uid}
            ])
          });
        }

        print(reactions);
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //****UPDATE MEMBERS******

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

//   Stream<List<NotificationModel>> fetchUserNotifications(List<School> schools) {
//     return _notifications
//         .where('schoolName', whereIn: schools.map((e) => e.id).toList())
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map(
//           (event) => event.docs
//               .map(
//                 (e) => NotificationModel.fromMap(
//                   e.data() as Map<String, dynamic>,
//                 ),
//               )
//               .toList(),
//         );
//   }

//   FutureVoid clearNotifications(String uid) async {
//     try {
//       final instance = FirebaseFirestore.instance;
//       final batch = instance.batch();
//       var collection = instance
//           .collection('notifications')
//           .doc(uid)
//           .collection('userNotifications');
//       var snapshots = await collection.get();
//       for (var doc in snapshots.docs) {
//         batch.delete(doc.reference);
//       }
//       return right(await batch.commit());
//     } on FirebaseException catch (e) {
//       throw e.chat!;
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }

  FutureVoid leaveGroup(UserModel currentUser, ChatModel chat) async {
    try {
      if (chat.members.length - 1 > 0) {
        return right(() {
          _chats.doc(chat.id).update({});
        });
      } else {
        return right(_chats.doc(chat.id).delete());
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

//   FutureVoid sendNotification(NotificationModel notification) async {
//     try {
//       return right(_notifications
//           .doc(notification.receiverUid)
//           .collection('userNotifications')
//           .doc(notification.id)
//           .set(notification.toMap()));
//     } on FirebaseException catch (e) {
//       throw e.chat!;
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }

  Stream<List<ChatModel>> getUserChats(String uid) {
    return _chats
        .where('members', arrayContains: uid)
        .orderBy('lastEditedAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => ChatModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<MessageModel>> getChatContent(String chatId) {
    return _chats
        .doc(chatId)
        .collection('chatContent')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => MessageModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
