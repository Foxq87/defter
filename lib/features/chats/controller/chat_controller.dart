import 'dart:io';

import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/type_defs.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/repository/chat_repository.dart';
import 'package:acc/features/chats/screens/chat_screen.dart';
import 'package:acc/models/chat_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/storage_providers.dart';
import '../../../core/utils.dart';
import '../../../models/message_model.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, bool>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getUserChatsProvider =
    StreamProvider.family((ref, String notificationId) {
  final chatController = ref.watch(chatControllerProvider.notifier);
  return chatController.getUserChats(notificationId);
});

final getChatByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(chatControllerProvider.notifier).getChatById(id);
});

final getChatContentProvider = StreamProvider.family((ref, String chatId) {
  final chatController = ref.watch(chatControllerProvider.notifier);
  return chatController.getChatContent(chatId);
});

class ChatController extends StateNotifier<bool> {
  final ChatRepository _chatRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ChatController({
    required ChatRepository chatRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _chatRepository = chatRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  // void clearNotifications(String uid, BuildContext context) async {
  //   try {
  //     await _notificationRepository.clearNotifications(uid);
  //     Navigator.pop(context);
  //     showSnackBar(context, 'bildirimler temizlendi');
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  void leaveGroup(
      UserModel currentUser, ChatModel chat, BuildContext context) async {
    try {
      await _chatRepository.leaveGroup(currentUser, chat);
      Routemaster.of(context).pop();
      Routemaster.of(context).pop();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<ChatModel>> getUserChats(String uid) {
    return _chatRepository.getUserChats(uid);
  }

  Stream<List<MessageModel>> getChatContent(String chatId) {
    return _chatRepository.getChatContent(chatId);
  }

  Stream<ChatModel> getChatById(String chatId) {
    return _chatRepository.getChatById(chatId);
  }

  void reactMessage(MessageModel message, UserModel user, String reaction,
      BuildContext context) async {
    final res = await _chatRepository.reactMessage(message, user, reaction);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'grup oluşturuldu');
      Navigator.of(context).pop();
    });
  }

  void deleteMessage(MessageModel message, BuildContext context) async {
    final res = await _chatRepository.deleteMessage(message);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'grup oluşturuldu');
      Navigator.of(context).pop();
    });
  }

  void deleteChat(ChatModel chat, BuildContext context) async {
    final res = await _chatRepository.deleteChat(chat);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'sohbet silindi');
      // Navigator.of(context).pop();
    });
  }

  void startChat({
    required List<String> uids,
    required String title,
    required String description,
    required File? profilePic,
    required BuildContext context,
    required bool isDM,
  }) async {
    state = true;

    final currentUsername = _ref.read(userProvider)?.username ?? '';
    final currentUid = _ref.read(userProvider)?.uid ?? '';
    if (!uids.contains(currentUid)) {
      uids.add(currentUid);
    }
    // uids.sort();

    // bool isDM = uids.length == 2;
    String chatId = Uuid().v4();
    String imageLink = isDM ? '' : Constants.chatAvatarDefault;
    Either imageRes;
    if (profilePic != null) {
      imageRes = await _storageRepository.storeFile(
        path: 'chats/$currentUid',
        id: chatId,
        file: profilePic,
      );
      imageRes.fold((l) => showSnackBar(context, l.message), (r) {
        imageLink = r;
      });
    }

    uids.sort();
    print(uids);
    ChatModel chat = ChatModel(
      id: chatId,
      members: uids,
      title: title,
      description: description,
      profilePic: imageLink,
      latest:
          "@$currentUsername ${isDM ? 'bir sohbet baslatti' : 'bir grup oluşturdu'}",
      createdAt: DateTime.now(),
      lastEditedAt: DateTime.now(),
      type: '',
      permissions: [],
      isDM: isDM,
      isHidden: false,
      isArchived: false,
    );

    final res = await _chatRepository.startChat(chat);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'grup oluşturuldu');
      Navigator.of(context).pop();
      Routemaster.of(context).push('/chat/${chat.id}/true');
      // Navigator.push(context,
      // MaterialPageRoute(builder: (context) => ChatScreen(chatId: chat.id)));
    });
  }

  void sendTextMessage({
    required BuildContext context,
    required String content,
    required String link,
    required String chatId,
  }) async {
    state = true;
    String messageId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final MessageModel message = MessageModel(
      id: messageId,
      uid: user.uid,
      text: content,
      chatId: chatId,
      link: link,
      createdAt: DateTime.now(),
      imageUrls: [],
      seenBy: [],
      reactions: [],
    );
    final res = await _chatRepository.sendMessage(message, user.username);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'Noteed successfully!');
    });
  }

  void sendImageMessage({
    required BuildContext context,
    required String chatId,
    required String content,
    required List<File> imageFiles,
    required String link,
  }) async {
    state = true;

    int errorCounter = 0;
    List<String> imageUrls = [];
    final currentUsername = _ref.read(userProvider)?.username ?? '';
    final currentUid = _ref.read(userProvider)?.uid ?? '';
    String messageId = const Uuid().v1();
    Either imageRes;
    for (int i = 0; i < imageFiles.length; i++) {
      var file = imageFiles[i];
      String imageId = const Uuid().v4();

      imageRes = await _storageRepository.storeFile(
        path: 'chats/$chatId/$messageId',
        id: imageId,
        file: file,
      );

      imageRes.fold((l) => showSnackBar(context, l.message), (r) {
        imageUrls.add(r);
        errorCounter++;
      });
      print(imageUrls);
    }

    if (errorCounter == imageUrls.length) {
      final MessageModel message = MessageModel(
          id: messageId,
          chatId: chatId,
          uid: currentUid,
          text: content,
          link: link,
          createdAt: DateTime.now(),
          imageUrls: imageUrls,
          seenBy: [],
          reactions: []);

      final res = await _chatRepository.sendMessage(message, currentUsername);

      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        // showSnackBar(context, 'Noteed successfully!');
        // Navigator.of(context).pop();
      });
    }
  }

  // void sendNotification({
  //   required BuildContext context,
  //   required String content,
  //   required String type,
  //   required String id,
  //   required String receiverUid,
  //   required String senderId,
  //   String? productId,
  //   String? noteId,
  //   String? articleId,
  // }) async {
  //   NotificationModel notification = NotificationModel(
  //     id: id,
  //     type: type,
  //     senderUid: senderId,
  //     receiverUid: receiverUid,
  //     content: content,
  //     postId: noteId,
  //     productId: productId,
  //     articleId: articleId,
  //     createdAt: DateTime.now(),
  //   );
  //   final res = await _notificationRepository.sendNotification(notification);

  //   res.fold((l) => showSnackBar(context, l.chat), (r) => null);
  // }
}
