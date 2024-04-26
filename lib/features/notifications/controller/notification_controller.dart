import 'package:acc/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acc/core/utils.dart';
import '../../../core/providers/storage_providers.dart';
import '../repository/notification_repository.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return NotificationController(
    notificationRepository: notificationRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final getUserNotificationsProvider =
    StreamProvider.family((ref, String notificationId) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getUserNotifications(notificationId);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationRepository _notificationRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  NotificationController({
    required NotificationRepository notificationRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _notificationRepository = notificationRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void deleteNotification(
      NotificationModel notification, BuildContext context) async {
    try {
      await _notificationRepository.deleteNotification(notification);
    } catch (e) {
      showSnackBar(context, 'Notification Deleted successfully!');
    }
  }

  Stream<List<NotificationModel>> getUserNotifications(String uid) {
    return _notificationRepository.getUserNotifications(uid);
  }

  void sendNotification({
    required BuildContext context,
    required String content,
    required String type,
    required String id,
    required String receiverUid,
    required String senderId,
    String noteId = '',
  }) async {
    NotificationModel notification = NotificationModel(
      id: id,
      type: type,
      senderUid: senderId,
      receiverUid: receiverUid,
      content: content,
      postId: noteId,
      createdAt: DateTime.now(),
    );
    final res = await _notificationRepository.sendNotification(notification);

    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }
}
